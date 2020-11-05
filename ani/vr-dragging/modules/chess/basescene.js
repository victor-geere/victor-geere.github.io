import * as THREE from "../../lib/three/build/three.module.js";
import {colorsGrey, rainbow} from "../colors.js";
import {VRButton} from "../../lib/three/examples/jsm/webxr/VRButton.js";
import {Interaction} from "../../lib/three.interaction/three.interaction.module.js";
import {OrbitControls} from "../../lib/three/examples/jsm/controls/OrbitControls.js";
import {loadModel} from "../loadmodels.js";
import { GLTFLoader } from '../../lib/three/examples/jsm/loaders/GLTFLoader.js';

const rank = {
    PAWN: 1,
    ROOK: 2,
    KNIGHT: 3,
    BISHOP: 4,
    QUEEN: 5,
    KING: 6,
};

const playerType = {
    WHITE: 1,
    BLACK: 2,
};

function getMaterial(colorN, palette = rainbow, metal = 0) {
    return new THREE.MeshStandardMaterial({
        color: palette[colorN],
        roughness: metal > 0 ? 0.8 : 0.7,
        metalness: metal
    });
}

function getPlayerTypeName(playerTypeNum) {
    if (playerTypeNum === playerType.WHITE) {
        return 'white';
    } else if(playerTypeNum === playerType.BLACK) {
        return 'black';
    }
    return null;
}

const objectType = {
    PIECE: 1,
    TILE: 2,
};

const getUserData = function(type) {
    const colNum = type === playerType.WHITE ? 12 : 40;
    const mat = getMaterial(colNum);
    // console.log(mat);
    return {
        objectType: 0, // objectType.PIECE or objectType.TILE
        rotation: 0, // radians
        player: {
            type: 0, // playerType.WHITE or playerType.BLACK
            material: mat,
            pieces: [] // [{type: rank.PAWN, position: {x: 0, z: 0}, id}]
        },
        state: {
            selected: false,
            intersected: false,
            taken: false
        },
        tile: {} // the tile mesh that the piece is standing on
    }
};

function makePlayer(playerT) {
    const colNum = playerT === playerType.WHITE ? 12 : 40;
    const mat = getMaterial(colNum);
    return {
        type: playerT,
        material: mat,
        pieces: [
            // {type: rank.PAWN, position: {x: 0, z: 0}, id}
        ],
        addPiece: function (id, rank, x, z) {
            this.pieces.push({id, rank, position: {x, z}});
        }
    }
}

const geometries = {
    getCastle: {
        rotation: 1,
        make: function (universe, player, callback) {
            const loader = new GLTFLoader();
            loader.load('assets/castle.glb',
            function (gltf) {
                const mesh = gltf.scene.children[0].children[0];
                mesh.material = player.material.clone();
                console.log(`mesh : `, mesh);
                // universe.scene.add(mesh);
                mesh.userData = getUserData(player.type);
                mesh.userData.objectType = objectType.PIECE;
                mesh.userData.rotation = 8;
                callback(mesh);
            },
                undefined,
                function (error) {
                console.error(error);
            });
        }
    },
    getCylinder: {
        rotation: 8,
        make: function (universe, player, callback) {
            let radius = universe.game.board.pieceRadius;
            let height = universe.game.board.pieceHeight;
            let geometry = new THREE.CylinderBufferGeometry(radius, radius, height, 8);
            const mesh = new THREE.Mesh(geometry, player.material.clone());
            mesh.userData = getUserData(player.type);
            mesh.userData.objectType = objectType.PIECE;
            mesh.userData.rotation = 8;
            callback(mesh);
        }
    },
    getBox: {
        rotation: 1,
        make: function (universe, player, callback) {
            let radius = universe.game.board.pieceRadius;
            let height = universe.game.board.pieceHeight;
            let geometry = new THREE.BoxBufferGeometry(radius * 1.5, height, radius * 1.5, 8);
            const mesh = new THREE.Mesh(geometry, player.material.clone());
            mesh.userData = getUserData(player.type);
            mesh.userData.objectType = objectType.PIECE;
            mesh.userData.rotation = 1;
            callback(mesh);
        }
    }
};

function setEmission(target, source) {
    target.r = source.r;
    target.g = source.g;
    target.b = source.b;
}

function getBaseScene() {
    return {
        settings: {
            tiles: {
                emissive: {
                    intersected: {r: 0, g: 0, b: 0.1},
                    default: {r: 0.1, g: 0.1, b: 0.1},
                    selected: {r: 0.2, g: 0.2, b: 0.2}
                }
            },
            pieces: {
                emissive: {
                    intersected: {
                        black: {r: 0, g: 0, b: 1},
                        white: {r: 0.5, g: 0, b: 0},
                    },
                    default: {r: 0, g: 0, b: 0},
                    selected: {
                        black: {r: 1, g: 0, b: 0},
                        white: {r: 1, g: 0, b: 0}
                    },
                }
            },
        },
        camera: null,
        scene: null,
        renderer: null,
        container: null,
        vrSupported: false,
        ctrl: {
            controller: [],
            controllerGrip: [],
        },
        controls: null,
        group: null,
        raycaster: new THREE.Raycaster(),
        intersected: [],
        tempMatrix: new THREE.Matrix4(),
        game: {
            players: {
                white: makePlayer(playerType.WHITE),
                black: makePlayer(playerType.BLACK)
            },
            tiles: [[]],
            addTile: (gameObj, tile, x, z) => {
                const tiles = gameObj.tiles;
                while (tiles.length - 1 < x) {
                    tiles.push([]);
                }
                while (tiles[x].length - 1 < z) {
                    tiles[x].push([]);
                }
                tiles[x][z] = tile;
            },
            getTileAt: function(x, z) {
                return this.tiles[x][z];
            },
            info: {
                selectedPieces: [],
                selectedTiles: [],
            },
            board: {
                pieceHeight: 0.32,
                pieceRadius: 0.12,
                pieces: 8,
                size: 4 * (8 / 10),
                gapRatio: 0.25,
                blockSize: 0.4
            },
            setPiece: () => {
            },
            onSqeezeEnd: () => {
            },
            onSqeezeStart: () => {
            },
            onSelect: () => {
            },
            onSelectStart: () => {
            },
            onSelectEnd: () => {
            },
            onPieceOver: function(universe, piece) {
                // console.log('piece ', piece);
                const playerName = getPlayerTypeName(piece.userData.player.type);
                if (piece.userData.state.selected) {
                    setEmission(piece.material.emissive, universe.settings.pieces.emissive.selected[playerName]);
                } else {
                    setEmission(piece.material.emissive, universe.settings.pieces.emissive.intersected[playerName]);
                }
                universe.intersected.push(piece);
            },
            onPieceOut: function(universe, piece) {
                // console.log(`piece.material.emissive : `, piece.material.emissive);
                if (piece.userData.state.selected) {
                    const playerName = getPlayerTypeName(piece.userData.player.type);
                    setEmission(piece.material.emissive, universe.settings.pieces.emissive.selected[playerName]);
                } else {
                    setEmission(piece.material.emissive, universe.settings.pieces.emissive.default);
                }
            },
            onTileOver: function(universe, tile) {
                if(universe.game.info.selectedPieces.length > 0) {
                    setEmission(tile.material.emissive, universe.settings.tiles.emissive.intersected);
                }
            },
            onTileOut: function(universe, tile) {
                setEmission(tile.material.emissive, universe.settings.tiles.emissive.default);
            },
            onClickPiece: (universe, clickedPiece, event) => {
                const selectedPiece = universe.game.info.selectedPieces[0];
                const target = {...clickedPiece.position};
                if (selectedPiece) {
                    if (clickedPiece === selectedPiece) {
                        //unselect selected piece
                        selectedPiece.userData.state.selected = false;
                        setEmission(selectedPiece.material.emissive, universe.settings.pieces.emissive.default);
                        universe.game.info.selectedPieces = [];
                    } else {
                        //move piece to previously selected piece, take a piece
                        selectedPiece.userData.state.selected = false;
                        universe.group.remove(clickedPiece);
                        selectedPiece.position.x = target.x;
                        selectedPiece.position.y = target.y;
                        selectedPiece.position.z = target.z;
                        setEmission(selectedPiece.material.emissive, universe.settings.pieces.emissive.default);
                        universe.game.info.selectedPieces = [];
                    }
                } else {
                    clickedPiece.userData.state.selected = true;
                    const playerName = getPlayerTypeName(clickedPiece.userData.player.type);
                    universe.game.info.selectedPieces.push(clickedPiece);
                    setEmission(clickedPiece.material.emissive, universe.settings.pieces.emissive.selected[playerName]);
                }
            },
            movePiece: function(piece, tile) {
                piece.userData.state.selected = false;
                piece.userData.tile = tile;
                piece.position.x = tile.position.x;
                piece.position.z = tile.position.z;
                if(!tile.userData) {
                    tile.userData = {};
                }
                tile.userData.piece = piece;
            },
            onClickTile: (universe, clickedTile, event) => {
                const piece = universe.game.info.selectedPieces[0];
                if (piece) {
                    if (clickedTile.userData.piece) {
                        universe.group.remove(clickedTile.userData.piece);
                        clickedTile.userData.piece.userData.state.taken = true;
                        clickedTile.userData.piece = null;
                    }
                    universe.game.movePiece(piece, clickedTile);
                    setEmission(piece.material.emissive, universe.settings.pieces.emissive.default);
                    universe.game.info.selectedPieces = [];
                }
            },
            onSelectTile: (universe, clickedTile, event) => {
                let secondClick = false;
                let removeTileId = -1;
                universe.game.info.selectedTiles.forEach((tile, ix) => {
                    setEmission(tile.material.emissive, universe.settings.tiles.emissive.default);
                    if (tile === clickedTile) {
                        secondClick = true;
                        removeTileId = ix;
                    }
                });
                universe.game.info.selectedTiles = [];
                if (!secondClick) {
                    universe.game.info.selectedTiles.push(clickedTile);
                    setEmission(clickedTile.material.emissive, universe.settings.tiles.emissive.selected);
                }
            },
            addPieceEvents: () => {
            },
            makeModel: function (universe, x, z, player, geoFactory) {
                geoFactory.make(universe, player, (object) => {
                    let board = universe.game.board;
                    board.gapSize = board.gapRatio * board.pieceRadius * 2;

                    object.userData.player = player;
                    object.position.y = board.pieceHeight;
                    object.rotation.y = -Math.PI / geoFactory.rotation;

                    universe.game.addPieceEvents(object, universe);
                    const tile = universe.game.getTileAt(x, z);
                    universe.game.movePiece(object, tile);

                    // object.scale.setScalar(1);
                    object.castShadow = true;
                    object.receiveShadow = true;
                    universe.group.add(object);
                });
            },
            makePiece: function (universe, x, z, player, geoFactory) {
                geoFactory.make(universe, player, (object) => {
                    let board = universe.game.board;
                    board.gapSize = board.gapRatio * board.pieceRadius * 2;

                    object.userData.player = player;
                    object.position.y = board.pieceHeight / 2;
                    object.rotation.y = -Math.PI / geoFactory.rotation;

                    universe.game.addPieceEvents(object, universe);
                    const tile = universe.game.getTileAt(x, z);
                    universe.game.movePiece(object, tile);

                    object.scale.setScalar(1);
                    object.castShadow = true;
                    object.receiveShadow = true;
                    universe.group.add(object);
                });
            }
        },
        addGeometries: function (vrScene) {
            const n = vrScene.game.board.pieces;

            const addOfficers = (universe, player) => {
                const row = player.type === playerType.WHITE ? 0 : 7;
                for (let x = 0; x < n; x++) {
                    universe.game.makeModel(universe, x, row, player, geometries.getCastle);
                    // universe.game.makePiece(universe, x, row, player, geometries.getCylinder);
                }
            };

            const addPawns = (universe, player) => {
                const row = player.type === playerType.WHITE ? 1 : 6;
                for (let x = 0; x < n; x++) {
                    universe.game.makePiece(universe, x, row, player, geometries.getBox);
                }
            };

            addPawns(vrScene, vrScene.game.players.black);
            addOfficers(vrScene, vrScene.game.players.black);
            addPawns(vrScene, vrScene.game.players.white);
            addOfficers(vrScene, vrScene.game.players.white);
        },

        addTileEvents: function (vrScene, object) {
            object.on('click', vrScene.game.onClickTile.bind(vrScene, vrScene, object));
            object.on('mouseover', vrScene.game.onTileOver.bind(vrScene, vrScene, object));
            object.on('mouseout', vrScene.game.onTileOut.bind(vrScene, vrScene, object));
        },

        addFloor: function (vrScene) {
            const addTile = (x, z, colorN) => {
                const tileHeight = 0.1;
                const halfHeight = 0.05;
                let tile = new THREE.BoxBufferGeometry(0.35, tileHeight, 0.35);
                let tile1Mat = getMaterial(colorN, colorsGrey, 1);
                setEmission(tile1Mat.emissive, vrScene.settings.tiles.emissive.default);
                let object = new THREE.Mesh(tile, tile1Mat);
                object.userData.objectType = objectType.TILE;

                const halfBlock = vrScene.game.board.blockSize / 2;
                const halfBoard = vrScene.game.board.size / 2;
                object.position.x = x * vrScene.game.board.blockSize - halfBoard - halfBlock;
                object.position.y = -halfHeight;
                object.position.z = z * vrScene.game.board.blockSize - halfBoard - halfBlock;

                object.scale.setScalar(1);
                object.castShadow = false;
                object.receiveShadow = true;

                vrScene.addTileEvents(vrScene, object);
                vrScene.game.addTile(vrScene.game, object, x - 1, z - 1);
                vrScene.group.add(object);
            };
            const tileN = vrScene.game.board.pieces;
            for (let n = 1; n <= tileN; n++) {
                for (let k = 1; k <= tileN; k++) {
                    const colorN = (n % 2) !== (k % 2) ? 2 : 5;
                    addTile(n, k, colorN);
                }
            }
        },
        addLight: function (vrScene) {
            vrScene.scene.add(new THREE.HemisphereLight(0x808080, 0x606060));

            let light = new THREE.DirectionalLight(0xffffff);
            light.intensity = 0.75;
            light.position.set(0, 6, 0);
            light.castShadow = true;
            light.shadow.camera.top = 2;
            light.shadow.camera.bottom = -2;
            light.shadow.camera.right = 2;
            light.shadow.camera.left = -2;
            light.shadow.mapSize.set(4096, 4096);
            vrScene.scene.add(light);
        },
        addController: () => {
        },
        addControllers: () => {
        },
        setupScene: function (universe) {
            universe.container = document.createElement('div');
            document.body.appendChild(universe.container);
            universe.renderer = new THREE.WebGLRenderer({antialias: true});
            universe.renderer.setPixelRatio(window.devicePixelRatio);
            universe.renderer.setSize(window.innerWidth, window.innerHeight);
            universe.renderer.outputEncoding = THREE.sRGBEncoding;
            universe.renderer.shadowMap.enabled = true;
            universe.renderer.xr.enabled = true;
            universe.container.appendChild(universe.renderer.domElement);
            document.body.appendChild(VRButton.createButton(universe.renderer));

            universe.scene = new THREE.Scene();
            universe.scene.background = new THREE.Color(0xf0bedd);

            universe.camera = new THREE.PerspectiveCamera(50, window.innerWidth / window.innerHeight, 0.1, 10);
            universe.camera.position.set(0, 1.6, 3);

            universe.group = new THREE.Group();
            universe.scene.add(universe.group);
        },
        setupWorldControl: function (universe) {
            const interaction = new Interaction(universe.renderer, universe.scene, universe.camera);

            universe.controls = new OrbitControls(universe.camera, universe.container);
            universe.controls.target.set(0, 1.6, 0);
            universe.controls.update();
        },
        postSetup: function (universe) {
            window.addEventListener('resize', universe.onWindowResize.bind(universe), false);
        },
        loadPieces: function () {
            // loadModel(this.scene);
        },
        init: function () {
            this.setupScene(this);
            this.setupWorldControl(this);
            this.loadPieces(this);
            this.addFloor(this);
            this.addLight(this);
            this.addControllers(this);
            this.addGeometries(this);
            this.postSetup(this);
        },
        onWindowResize: function () {
            if (this.camera) {
                this.camera.aspect = window.innerWidth / window.innerHeight;
                this.camera.updateProjectionMatrix();
                this.renderer.setSize(window.innerWidth, window.innerHeight);
            }
        },
        getIntersections: () => {
        },
        intersectObjects: () => {
        },
        cleanIntersected: () => {
        },
        animate: function () {
            requestAnimationFrame(this.animate.bind(this));
            this.render.bind(this)();
        },
        render: function () {
            this.renderer.render(this.scene, this.camera);
        }
    }
}

export { getBaseScene, rank, playerType, geometries, makePlayer, setEmission, objectType, getPlayerTypeName }
