import {GLTFLoader} from "../../lib/three/examples/jsm/loaders/GLTFLoader.js";
import * as THREE from "../../lib/three/build/three.module.js";
import {objectType, playerType} from "./basescene.js";
import {getMetalMaterial} from "../materials.js";

const getUserData = function(type, objectType, rotation) {
    const colNum = type === playerType.WHITE ? 12 : 40;
    const mat = getMetalMaterial(colNum);
    return {
        objectType, // objectType.PIECE or objectType.TILE
        rotation, // radians
        player: {
            type, // playerType.WHITE or playerType.BLACK
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

const geometries = {
    getMesh: {
        rotation: 1,
        make: function (universe, player, options, callback) {
            const loader = new GLTFLoader();
            loader.load('assets/pieces.glb',
                function (gltf) {
                    const mesh = gltf.scene.children[0].children[options.meshNumber];
                    mesh.material = player.material.clone();
                    mesh.userData = getUserData(player.type, objectType.PIECE, 8);
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
        make: function (universe, player, options, callback) {
            let radius = universe.game.board.pieceRadius;
            let height = universe.game.board.pieceHeight;
            let geometry = new THREE.CylinderBufferGeometry(radius, radius, height, 8);
            const mesh = new THREE.Mesh(geometry, player.material.clone());
            mesh.userData = getUserData(player.type, objectType.PIECE, 8);
            callback(mesh);
        }
    },
    getBox: {
        rotation: 1,
        make: function (universe, player, options, callback) {
            let radius = universe.game.board.pieceRadius;
            let height = universe.game.board.pieceHeight;
            let geometry = new THREE.BoxBufferGeometry(radius * 1.5, height, radius * 1.5, 8);
            const mesh = new THREE.Mesh(geometry, player.material.clone());
            mesh.userData = getUserData(player.type, objectType.PIECE, 1);
            callback(mesh);
        }
    }
};

export { geometries }
