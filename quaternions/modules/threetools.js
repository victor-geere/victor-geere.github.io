import { polarCos, polarSin } from "./mathtools.js";
import * as THREE from '../lib/three.module.js';
import {OrbitControls} from '../lib/OrbitControls.js';
import * as Colors from './colors.js';

function resize(renderer, camera, x, y) {
    renderer.setSize(x, y);
    //only for perspective camera!!!
    camera.aspect = aspectRatio(x, y);
    camera.updateProjectionMatrix();
}

let aspectRatio = function (width, height) {
    return width / height;
};


function getMaterial(palette, colorN, opacity = 0) {
    if (opacity) {
        return new THREE.LineBasicMaterial({
            color: palette[colorN],
            opacity: opacity,
            transparent: true
        })
    }
    return new THREE.LineBasicMaterial({
        color: palette[colorN]
    })
}

function addMesh(obj, curvePoints = [], resolution= 0) {
    try {
        if (obj.curvePoints.length > 1) {
            if (!resolution) {
                obj.geo = new THREE.BufferGeometry().setFromPoints(obj.curvePoints);
                obj.mesh = new THREE.Line(obj.geo, obj.properties.mat);
            } else {
                obj.curve = new THREE.CatmullRomCurve3(obj.curvePoints);
                obj.geoPoints = obj.curve.getPoints(resolution);
                obj.geo = new THREE.BufferGeometry().setFromPoints(obj.geoPoints);
                obj.mesh = new THREE.Line(obj.geo, obj.properties.mat);
            }
        }
    } catch (e) {
        console.error(e);
    }
}

function makeSimpleCurve(curvePoints, material, xOrigin = 0, yOrigin = 0, resolution= 0) {
    const obj = {
        properties: {
            origin: {x: xOrigin, y: yOrigin, z: 0},
            mat: material
        },
        curvePoints: curvePoints,
        curve: null,
        geoPoints: null,
        geo: null,
        mesh: null
    };
    addMesh(obj);
    return obj;
}

function makeCurve(pivot, a, b, r, ngon, rotation, material, curvePoints = [], resolution= 0) {
    const obj = {
        properties: {
            pivot: pivot,
            origin: {x: a, y: b, z: 0},
            radius: r,
            ngon: ngon,
            rotation: rotation,
            mat: material
        },
        curvePoints: curvePoints,
        curve: null,
        geoPoints: null,
        geo: null,
        mesh: null
    };
    addMesh(obj, curvePoints, resolution);
    return obj;
}

function makeCircle(pivot, a, b, r, ngon, rotation, material) {
    let curvePoints = getCirclePoints(pivot, a, b, r, ngon, rotation);
    return makeCurve(pivot, a, b, r, ngon, rotation, material, curvePoints);
}

function getCirclePoints(pivot, a, b, r, ngon = 8, rotated = 0) {
    let k = rotated;
    let plotPoints = [];

    while (k <= 360 + rotated) {
        plotPoints.push(new THREE.Vector3(polarCos(k, r, a), polarSin(k, r, b), 0));
        k = k + 360 / ngon;
    }
    return plotPoints;
}

function newSceneInfo() {
    return {
        objects: [],
        hasChanged: false,
        animationLoopId: null,
        renderer: null,
        camera: null,
        scene: null,
        group: null,
        scale: function (size) {
            this.group.scale.set(size, size, size);
        },
        addObjectToScene: function (obj) {
            this.scene.add(obj);
        },
        addObjectToGroup: function (obj3d) {
            this.group.add(obj3d);
        },
        addObject: function (obj) {
            this.objects.push(obj);
            this.addObjectToGroup(obj.mesh);
        },
        clear: function () {
            while (this.group.children.length > 0) {
                this.group.remove(this.group.children[this.group.children.length - 1]);
            }
            this.objects = [];
        },
        render: function () {
            this.renderer.render(this.scene, this.camera);
        },
        redo: function() {
            while (this.scene.children.length > 0) {
                this.scene.remove(this.scene.children[this.scene.children.length - 1]);
            }
        }
    };
}

function getPerspectiveCamera(x, y) {
    const camera = new THREE.PerspectiveCamera(32, aspectRatio(x, y), 1, 500);
    camera.position.set(0, 0, 50);
    return camera;
}

function getOrthoCamera(x, y) {
    const camera = new THREE.OrthographicCamera(-x / 2, x/2, y/2, -y/2, 0, 1500);
    camera.position.set(0, 0, 50);
    return camera;
}

function buildScene(parentHtmlElement, x, y, scale, backgroudColor, lightColor, camera) {
    if (!camera) {
        camera = getOrthoCamera(x, y);
        // camera = getPerspectiveCamera(x, y);
    }
    let info = newSceneInfo();
    info.renderer = new THREE.WebGLRenderer({
        antialias: true,
        alpha: true
    });
    parentHtmlElement.appendChild(info.renderer.domElement);

    info.camera = camera;

    resize(info.renderer, info.camera, x, y);

    info.scene = new THREE.Scene();
    info.scene.background = new THREE.Color(backgroudColor);

    const light = new THREE.DirectionalLight(lightColor, 1, Infinity);
    light.position.set(0, 0, 0);
    info.camera.add(light);
    info.addObjectToScene(info.camera);

    // controls
    let controls = new OrbitControls(info.camera, info.renderer.domElement);
    controls.minDistance = 10;
    controls.maxDistance = 100;
    controls.maxPolarAngle = Math.PI / 2;

    // populate the scene
    info.group = new THREE.Group();
    info.scale(scale);
    info.addObjectToScene(info.group);
    return info;
}

function drawAxis(parent, size, material) {
    let matx, maty, matz;
    if (!material) {
        matx = getMaterial(Colors.primary, 0, 0.25);
        maty = getMaterial(Colors.primary, 1, 0.25);
        matz = getMaterial(Colors.primary, 2, 0.25);
    } else if (Array.isArray(material)) {
        matx = material[0];
        maty = material[1];
        matz = material[2];
    } else if (typeof material === 'object') {
        matx = material;
        maty = material;
        matz = material;
    }
    let geoPoints = {
        x: [
            new THREE.Vector3(-size, 0, 0),
            new THREE.Vector3( size, 0, 0),
        ],
        y: [
            new THREE.Vector3(0, -size, 0),
            new THREE.Vector3(0,  size, 0),
        ],
        z: [
            new THREE.Vector3(0, 0, -size),
            new THREE.Vector3(0, 0,  size),
        ],
    };
    parent.add(new THREE.Line(new THREE.BufferGeometry().setFromPoints(geoPoints.x), matx));
    parent.add(new THREE.Line(new THREE.BufferGeometry().setFromPoints(geoPoints.y), maty));
    parent.add(new THREE.Line(new THREE.BufferGeometry().setFromPoints(geoPoints.z), matz));
}

function newVec(x, y, z) {
    return new THREE.Vector3(x, y, z);
}

export {
    getMaterial, drawAxis, getCirclePoints, makeCircle, makeCurve,
    buildScene, resize, newVec, getPerspectiveCamera, getOrthoCamera, makeSimpleCurve
}
