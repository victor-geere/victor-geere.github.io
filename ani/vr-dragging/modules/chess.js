import {rainbow, colorsGrey, fields} from './colors.js';
import * as THREE from '../lib/three/build/three.module.js';
import {OrbitControls} from '../lib/three/examples/jsm/controls/OrbitControls.js';
import {VRButton} from '../lib/three/examples/jsm/webxr/VRButton.js';
import {XRControllerModelFactory} from '../lib/three/examples/jsm/webxr/XRControllerModelFactory.js';
import {Interaction} from '../lib/three.interaction/three.interaction.module.js';

function getVRScene() {
    const baseScene = getBaseScene();
    baseScene.game = {
        ...baseScene.game,
        onSelectStart: function (event) {
            let controller = event.target;
            let intersections = this.getIntersections(controller);

            if (intersections.length > 0) {
                let intersection = intersections[0];
                let object = intersection.object;
                object.material.emissive.b = 1;
                controller.attach(object);
                controller.userData.selected = object;
            }
        },

        onSelectEnd: function (event) {
            let controller = event.target;

            if (controller.userData.selected !== undefined) {
                let object = controller.userData.selected;
                object.material.emissive.b = 0;
                this.group.attach(object);
                object.rotation.x = 0;
                object.rotation.y = -Math.PI / 8;
                object.rotation.z = 0;

                object.position.y = this.board.pieceHeight / 2;
                const halfBlock = this.board.blockSize / 2;
                object.position.x = Math.round((object.position.x - halfBlock) / this.board.blockSize) * this.board.blockSize + halfBlock;
                object.position.z = Math.round((object.position.z - halfBlock) / this.board.blockSize) * this.board.blockSize + halfBlock;
                controller.userData.selected = undefined;
            }
        }
    };

    return {
        ...baseScene,

        vrSupported: true,

        addController: function (vrScene, ctrlN, factory, line) {
            // vrScene.ctrl.controller[0].addEventListener( 'select', () => {} );
            // vrScene.ctrl.controller[0].addEventListener( 'selectstart', () => {} );
            // vrScene.ctrl.controller[0].addEventListener( 'selectend', () => {} );
            // vrScene.ctrl.controller[0].addEventListener( 'squeeze', () => {} );
            // vrScene.ctrl.controller[0].addEventListener( 'squeezestart', () => {} );
            // vrScene.ctrl.controller[0].addEventListener( 'squeezeend', () => {} );
            // vrScene.ctrl.controller[0].addEventListener( 'end', () => {} );

            vrScene.ctrl.controller[ctrlN] = vrScene.renderer.xr.getController(ctrlN);
            vrScene.ctrl.controller[ctrlN].addEventListener('squeezestart', vrScene.game.onSelectStart.bind(vrScene.game));
            vrScene.ctrl.controller[ctrlN].addEventListener('squeezeend', vrScene.game.onSelectEnd.bind(vrScene.game));
            vrScene.scene.add(vrScene.ctrl.controller[ctrlN]);

            vrScene.ctrl.controllerGrip[ctrlN] = vrScene.renderer.xr.getControllerGrip(ctrlN);
            vrScene.ctrl.controllerGrip[ctrlN].add(factory.createControllerModel(vrScene.ctrl.controllerGrip[ctrlN]));
            vrScene.scene.add(vrScene.ctrl.controllerGrip[ctrlN]);

            vrScene.ctrl.controller[ctrlN].add(line.clone());
        },

        addControllers: function (vrScene) {
            let controllerModelFactory = new XRControllerModelFactory();

            let lineGeometry = new THREE.BufferGeometry().setFromPoints([new THREE.Vector3(0, 0, 0), new THREE.Vector3(0, 0, -1)]);
            let line = new THREE.Line(lineGeometry);
            line.name = 'line';
            line.scale.z = 5;

            vrScene.addController(vrScene, 0, controllerModelFactory, line.clone());
            vrScene.addController(vrScene, 1, controllerModelFactory, line.clone());
        },

        getIntersections: function (controller) {
            this.tempMatrix.identity().extractRotation(controller.matrixWorld);

            this.raycaster.ray.origin.setFromMatrixPosition(controller.matrixWorld);
            this.raycaster.ray.direction.set(0, 0, -1).applyMatrix4(this.tempMatrix);

            return this.raycaster.intersectObjects(this.group.children);
        },

        intersectObjects: function (controller) {
            // Do not highlight when already selected
            if (controller.userData.selected !== undefined) return;

            let line = controller.getObjectByName('line');
            let intersections = this.getIntersections(controller);

            if (intersections.length > 0) {
                let intersection = intersections[0];
                let object = intersection.object;
                object.material.emissive.r = 1;
                this.intersected.push(object);

                line.scale.z = intersection.distance;
            } else {
                line.scale.z = 5;
            }
        },

        cleanIntersected: function () {
            while (this.intersected.length) {
                let object = this.intersected.pop();
                object.material.emissive.r = 0;
            }
        },

        animate: function () {
            this.renderer.setAnimationLoop(this.render.bind(this));
        },

        render: function () {
            this.cleanIntersected();
            if (this.vrSupported) {
                this.intersectObjects(this.ctrl.controller[0]);
                this.intersectObjects(this.ctrl.controller[1]);
            }
            this.renderer.render(this.scene, this.camera);
        }
    }
}

function getWebScene() {
    const baseScene = getBaseScene();
    baseScene.game = {
        ...baseScene.game,
        onSelectStart: () => {
        },
        onSelectEnd: () => {
        },
        addPieceEvents: (piece, universe) => {
            piece.cursor = 'pointer';
            piece.on('click', universe.game.onClickPiece.bind(universe.game, universe, piece));
        },
        onClickPiece: (universe, clickedPiece, event) => {
            let secondClick = false;
            let removePieceId = -1;
            universe.game.info.selectedPieces.forEach((piece, ix) => {
                piece.material.emissive.b = 0;
                if (piece === clickedPiece) {
                    secondClick = true;
                    removePieceId = ix;
                }
            });
            universe.game.info.selectedPieces = [];
            if (!secondClick) {
                universe.game.info.selectedPieces.push(clickedPiece);
                clickedPiece.material.emissive.b = 5;
            }
        },
        onClickTile: (universe, clickedTile, event) => {
            let secondClick = false;
            let removeTileId = -1;
            universe.game.info.selectedTiles.forEach((tile, ix) => {
                tile.material.emissive.r = 0.1;
                tile.material.emissive.g = 0.1;
                tile.material.emissive.b = 0.1;
                if (tile === clickedTile) {
                    secondClick = true;
                    removeTileId = ix;
                }
            });
            universe.game.info.selectedTiles = [];
            if (!secondClick) {
                universe.game.info.selectedTiles.push(clickedTile);
                clickedTile.material.emissive.r = 0.3;
                clickedTile.material.emissive.g = 0.3;
                clickedTile.material.emissive.b = 0.3;
            }
        },
    };
    return {
        ...baseScene,
        vrSupported: false,
    }
}

function getBaseScene() {
    return {
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
            info: {
                selectedPieces: [],
                selectedTiles: [],
            },
            board: {
                pieceHeight: 0.32,
                pieceRadius: 0.16,
                pieces: 8,
                size: 4 * (8 / 10),
                gapRatio: 0.25,
                blockSize: 0.4
            },
            onSelectStart: () => {
            },
            onSelectEnd: () => {
            },
            onClickPiece: () => {},
            onClickTile: () => {},
            addPieceEvents: () => {},
            makePiece: function (universe, x, z, colorOffset) {
                let radius = universe.game.board.pieceRadius;
                let height = universe.game.board.pieceHeight;
                let radius2x = radius * 2;
                let gap = universe.game.board.gapRatio;
                universe.game.board.gapSize = gap * radius2x;
                let spacing = 1 + gap;
                let boardSize = universe.game.board.size;
                let halfBoard = boardSize / 2;

                let geometry = new THREE.CylinderBufferGeometry(radius, radius, height, 8);
                const matNum = x + colorOffset;
                let material = universe.getMaterial(matNum);
                let object = new THREE.Mesh(geometry, material);

                object.position.x = x * universe.game.board.blockSize + universe.game.board.blockSize / 2 - halfBoard;
                object.position.y = height / 2;
                object.position.z = z * universe.game.board.blockSize + universe.game.board.blockSize / 2 - halfBoard;

                object.rotation.y = -Math.PI / 8;
                this.addPieceEvents(object, universe);
                return object;
            }
        },
        getMaterial: function (colorN, palette = rainbow, metal = 0) {
            return new THREE.MeshStandardMaterial({
                color: palette[colorN],
                roughness: metal > 0 ? 0.8 : 0.7,
                metalness: metal
            });
        },
        addGeometries: function (vrScene) {
            const n = vrScene.game.board.pieces;

            const addPiece = (object) => {
                object.scale.setScalar(1);
                object.castShadow = true;
                object.receiveShadow = true;
                vrScene.group.add(object);
            };

            for (let x = 0; x < n; x++) {
                addPiece(vrScene.game.makePiece(vrScene, x, 0, 5));
                addPiece(vrScene.game.makePiece(vrScene, x, 1, 15));
                addPiece(vrScene.game.makePiece(vrScene, x, 6, 35));
                addPiece(vrScene.game.makePiece(vrScene, x, 7, 45));
            }
        },

        addFloor: function (vrScene) {
            const addTile = (x, z, colorN) => {
                let tile = new THREE.BoxBufferGeometry(0.35, 1.1, 0.35);
                let tile1Mat = vrScene.getMaterial(colorN, colorsGrey, 1);
                tile1Mat.emissive.r = 0.1;
                tile1Mat.emissive.g = 0.1;
                tile1Mat.emissive.b = 0.1;
                let object = new THREE.Mesh(tile, tile1Mat);

                const halfBlock = vrScene.game.board.blockSize / 2;
                const halfBoard = vrScene.game.board.size / 2;
                object.position.x = x * vrScene.game.board.blockSize - halfBoard - halfBlock;
                object.position.y = -0.55;
                object.position.z = z * vrScene.game.board.blockSize - halfBoard - halfBlock;

                object.scale.setScalar(1);
                object.castShadow = false;
                object.receiveShadow = true;

                object.on('click', this.game.onClickTile.bind(this, vrScene, object));

                vrScene.scene.add(object);
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
            universe.scene.background = new THREE.Color(0x809090);

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
        init: function () {
            this.setupScene(this);
            this.setupWorldControl(this);
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

export {getVRScene, getWebScene}
