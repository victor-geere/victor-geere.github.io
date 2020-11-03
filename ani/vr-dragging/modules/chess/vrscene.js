import {XRControllerModelFactory} from "../../lib/three/examples/jsm/webxr/XRControllerModelFactory.js";
import * as THREE from "../../lib/three/build/three.module.js";
import { getPlayerTypeName,getBaseScene, rank, playerType, geometries, makePlayer, setEmission, objectType } from './basescene.js'

function getVRScene() {
    const baseScene = getBaseScene();
    baseScene.game = {
        ...baseScene.game,
        onSelect: function (universe, event) {
            let controller = event.target;
            let intersections = this.getIntersections(controller);

            if (intersections.length > 0) {
                let intersection = intersections[0];
                let object = intersection.object;
                if (object.userData.objectType === objectType.PIECE) {
                    universe.game.onClickPiece(universe, object, event);
                } else {
                    universe.game.onClickTile(universe, object, event);
                }
            }
        },

        onSqeezeStart: function (universe, event) {
            let controller = event.target;
            let intersections = this.getIntersections(controller);

            if (intersections.length > 0) {
                let intersection = intersections[0];
                let object = intersection.object;
                if (object.userData.objectType === objectType.PIECE) {
                    setEmission(object.material.emissive, universe.settings.pieces.emissive.selected);
                    controller.attach(object);
                    controller.userData.selected = object;
                }
            }
        },

        onSqeezeEnd: function (universe, event) {
            let controller = event.target;

            if (controller.userData.selected !== undefined) {
                let object = controller.userData.selected;
                setEmission(object.material.emissive, universe.settings.pieces.emissive.default);
                this.group.attach(object);
                object.rotation.x = 0;
                object.rotation.y = -Math.PI / object.userData.rotation;
                object.rotation.z = 0;

                const board = this.game.board;

                object.position.y = board.pieceHeight / 2;
                const halfBlock = board.blockSize / 2;
                object.position.x = Math.round((object.position.x - halfBlock) / board.blockSize) * board.blockSize + halfBlock;
                object.position.z = Math.round((object.position.z - halfBlock) / board.blockSize) * board.blockSize + halfBlock;
                controller.userData.selected = undefined;
            }
        }
    };

    return {
        ...baseScene,

        vrSupported: true,

        addTileEvents: (vrScene, object) => {
        },

        addController: function (vrScene, ctrlN, factory, line) {
            // vrScene.ctrl.controller[0].addEventListener( 'select', () => {} );
            // vrScene.ctrl.controller[0].addEventListener( 'selectstart', () => {} );
            // vrScene.ctrl.controller[0].addEventListener( 'selectend', () => {} );
            // vrScene.ctrl.controller[0].addEventListener( 'squeeze', () => {} );
            // vrScene.ctrl.controller[0].addEventListener( 'squeezestart', () => {} );
            // vrScene.ctrl.controller[0].addEventListener( 'squeezeend', () => {} );
            // vrScene.ctrl.controller[0].addEventListener( 'end', () => {} );

            vrScene.ctrl.controller[ctrlN] = vrScene.renderer.xr.getController(ctrlN);
            vrScene.ctrl.controller[ctrlN].addEventListener('selectstart', vrScene.game.onSelectStart.bind(vrScene, vrScene));
            vrScene.ctrl.controller[ctrlN].addEventListener('select', vrScene.game.onSelect.bind(vrScene, vrScene));
            vrScene.ctrl.controller[ctrlN].addEventListener('selectend', vrScene.game.onSelectEnd.bind(vrScene, vrScene));

            vrScene.ctrl.controller[ctrlN].addEventListener('squeezestart', vrScene.game.onSqeezeStart.bind(vrScene, vrScene));
            vrScene.ctrl.controller[ctrlN].addEventListener('squeezeend', vrScene.game.onSqeezeEnd.bind(vrScene, vrScene));
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
                if (object.userData.objectType === objectType.PIECE) {
                    this.game.onPieceOver(this, object);
                } else {
                    this.game.onTileOver(this, object);
                }

                line.scale.z = intersection.distance;
            } else {
                line.scale.z = 5;
            }
        },

        cleanIntersected: function () {
            while (this.intersected.length) {
                let object = this.intersected.pop();
                if (object.userData.objectType === objectType.PIECE) {
                    this.game.onPieceOut(this, object);
                } else {
                    this.game.onTileOut(this, object);
                }
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

export { getVRScene }
