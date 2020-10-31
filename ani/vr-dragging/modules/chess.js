import {rainbow, colorsGrey} from './colors.js';
import * as THREE from '../lib/three/build/three.module.js';
import {OrbitControls} from '../lib/three/examples/jsm/controls/OrbitControls.js';
import {VRButton} from '../lib/three/examples/jsm/webxr/VRButton.js';
import {XRControllerModelFactory} from '../lib/three/examples/jsm/webxr/XRControllerModelFactory.js';
import {Interaction} from '../lib/three.interaction/three.interaction.module.js';

function getVRScene() {
    return {
        ...getBaseScene(),

        vrSupported: true,

        game: {
            uiEvents: {
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
            }
        },

        addControllers: function (vrScene) {
            // vrScene.ctrl.controller1.addEventListener( 'select', () => {} );
            // vrScene.ctrl.controller1.addEventListener( 'selectstart', () => {} );
            // vrScene.ctrl.controller1.addEventListener( 'selectend', () => {} );
            // vrScene.ctrl.controller1.addEventListener( 'squeeze', () => {} );
            // vrScene.ctrl.controller1.addEventListener( 'squeezestart', () => {} );
            // vrScene.ctrl.controller1.addEventListener( 'squeezeend', () => {} );
            // vrScene.ctrl.controller1.addEventListener( 'end', () => {} );

            vrScene.ctrl.controller1 = vrScene.renderer.xr.getController(0);
            vrScene.ctrl.controller1.addEventListener('squeezestart', vrScene.game.uiEvents.onSelectStart.bind(vrScene));
            vrScene.ctrl.controller1.addEventListener('squeezeend', vrScene.game.uiEvents.onSelectEnd.bind(vrScene));
            vrScene.scene.add(vrScene.ctrl.controller1);

            vrScene.ctrl.controller2 = vrScene.renderer.xr.getController(1);
            vrScene.ctrl.controller2.addEventListener('squeezestart', vrScene.game.uiEvents.onSelectStart.bind(vrScene));
            vrScene.ctrl.controller2.addEventListener('squeezeend', vrScene.game.uiEvents.onSelectEnd.bind(vrScene));
            vrScene.scene.add(vrScene.ctrl.controller2);

            let controllerModelFactory = new XRControllerModelFactory();

            vrScene.ctrl.controllerGrip1 = vrScene.renderer.xr.getControllerGrip(0);
            vrScene.ctrl.controllerGrip1.add(controllerModelFactory.createControllerModel(vrScene.ctrl.controllerGrip1));
            vrScene.scene.add(vrScene.ctrl.controllerGrip1);

            vrScene.ctrl.controllerGrip2 = vrScene.renderer.xr.getControllerGrip(1);
            vrScene.ctrl.controllerGrip2.add(controllerModelFactory.createControllerModel(vrScene.ctrl.controllerGrip2));
            vrScene.scene.add(vrScene.ctrl.controllerGrip2);

            let lineGeometry = new THREE.BufferGeometry().setFromPoints([new THREE.Vector3(0, 0, 0), new THREE.Vector3(0, 0, -1)]);
            let line = new THREE.Line(lineGeometry);
            line.name = 'line';
            line.scale.z = 5;

            vrScene.ctrl.controller1.add(line.clone());
            vrScene.ctrl.controller2.add(line.clone());
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
                this.intersectObjects(this.ctrl.controller1);
                this.intersectObjects(this.ctrl.controller2);
            }
            this.renderer.render(this.scene, this.camera);
        }
    }
}

function getWebScene() {
    return {
        ...getBaseScene(),
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
            controller1: null,
            controller2: null,
            controllerGrip1: null,
            controllerGrip2: null,
        },
        controls: null,
        group: null,
        raycaster: new THREE.Raycaster(),
        intersected: [],
        tempMatrix: new THREE.Matrix4(),
        board: {
            pieceHeight: 0.32,
            pieceRadius: 0.16,
            size: 4,
            pieces: 10,
            gapRatio: 0.25,
            blockSize: 0.4
        },
        getMaterial: function (colorN, palette = rainbow, metal = 0) {
            return new THREE.MeshStandardMaterial({
                color: palette[colorN],
                roughness: metal > 0 ? 0.8 : 0.7,
                metalness: metal
            });
        },
        addGeometries: function (vrScene) {
            const n = vrScene.board.pieces;

            const addPiece = (object) => {
                object.scale.setScalar(1);
                object.castShadow = true;
                object.receiveShadow = true;
                vrScene.group.add(object);
            };

            for (let x = 0; x < n; x++) {
                addPiece(vrScene.game.makePiece(vrScene, x, 0, 0));
                addPiece(vrScene.game.makePiece(vrScene, x, 1, 10));
                addPiece(vrScene.game.makePiece(vrScene, x, 8, 30));
                addPiece(vrScene.game.makePiece(vrScene, x, 9, 40));
            }
        },

        game: {
            uiEvents: {
                onSelectStart: () => {},
                onSelectEnd: () => {},
            },
            makePiece: function(universe, x, z, colorOffset) {
                let radius = universe.board.pieceRadius;
                let height = universe.board.pieceHeight;
                let radius2x = radius * 2;
                let gap = universe.board.gapRatio;
                universe.board.gapSize = gap * radius2x;
                let spacing = 1 + gap;
                let boardSize = universe.board.size;
                let halfBoard = boardSize / 2;

                // let geometry = new THREE.CylinderBufferGeometry(radius*0.75, radius*1.25, height, 64);
                let geometry = new THREE.CylinderBufferGeometry(radius, radius, height, 8);
                const matNum = x * 2 + colorOffset;
                let material = universe.getMaterial(matNum);
                let object = new THREE.Mesh(geometry, material);

                object.cursor = 'pointer';
                object.on('click', (obj) => {
                });

                object.position.x = x * universe.board.blockSize + universe.board.blockSize / 2 - halfBoard;
                object.position.y = height / 2;
                object.position.z = z * universe.board.blockSize + universe.board.blockSize / 2 - halfBoard;

                object.rotation.y = -Math.PI / 8;
                return object;
            }
        },
        addFloor: function (vrScene) {
            let geometry = new THREE.PlaneBufferGeometry(4, 4);
            let material = new THREE.MeshStandardMaterial({
                color: 0xeeeeee,
                roughness: 1.0,
                metalness: 0.0
            });
            let floor = new THREE.Mesh(geometry, material);
            floor.rotation.x = -Math.PI / 2;
            floor.receiveShadow = true;
            vrScene.scene.add(floor);

            const addTile = (x, z, colorN) => {
                let tile = new THREE.BoxBufferGeometry(0.4, 0.1, 0.4);
                let tile1Mat = vrScene.getMaterial(colorN, colorsGrey, 1);
                let object = new THREE.Mesh(tile, tile1Mat);

                const halfBlock = vrScene.board.blockSize / 2;
                const halfBoard = vrScene.board.size / 2;
                object.position.x = x * vrScene.board.blockSize - halfBoard - halfBlock;
                object.position.y = -0.04;
                object.position.z = z * vrScene.board.blockSize - halfBoard - halfBlock;

                object.scale.setScalar(1);
                object.castShadow = false;
                object.receiveShadow = true;
                vrScene.scene.add(object);
            };
            const tileN = vrScene.board.pieces;
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
            light.position.set(0, 6, 0);
            light.castShadow = true;
            light.shadow.camera.top = 2;
            light.shadow.camera.bottom = -2;
            light.shadow.camera.right = 2;
            light.shadow.camera.left = -2;
            light.shadow.mapSize.set(4096, 4096);
            vrScene.scene.add(light);
        },
        addControllers: () => {},
        setupScene: function(universe) {
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
        setupWorldControl: function(universe) {
            const interaction = new Interaction(universe.renderer, universe.scene, universe.camera);

            universe.controls = new OrbitControls(universe.camera, universe.container);
            universe.controls.target.set(0, 1.6, 0);
            universe.controls.update();
        },
        postSetup: function(universe) {
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
        getIntersections: () => {},
        intersectObjects: () => {},
        cleanIntersected: () => {},
        animate: function() {
            requestAnimationFrame(this.animate.bind(this));
            this.render().bind(this);
        },
        render: function() {
            this.renderer.render(this.scene, this.camera);
        }
    }
}

export { getVRScene, getWebScene }
