import { polarCos, polarSin } from "./mathtools.js";
import * as THREE from './lib/three.module.js';
import {OrbitControls} from './lib/OrbitControls.js';

function resize(renderer, camera, x, y) {
    renderer.setSize(x, y);
    camera.aspect = aspectRatio(x, y);
    camera.updateProjectionMatrix();
}

let aspectRatio = function (width, height) {
    return width / height;
};


function getMaterial(palette, colorN) {
    return new THREE.LineBasicMaterial({
        color: palette[colorN]
    })
}

function makeCircle(pivot, a, b, r, ngon, rotation, material) {
    let curvePoints = getCirclePoints(pivot, a, b, r, ngon, rotation);

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
        curve: new THREE.CatmullRomCurve3(curvePoints),
    };
    if (curvePoints.length > 1) {
        obj.geoPoints = obj.curve.getPoints(ngon * Math.ceil(r));
        obj.geo = new THREE.BufferGeometry().setFromPoints(obj.geoPoints);
    }
    obj.mesh = new THREE.Line(obj.geo, obj.properties.mat);
    return obj;
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
        }
    };
}

function buildScene(parentHtmlElement, x, y, scale, backgroudColor, lightColor) {
    let info = newSceneInfo();
    info.renderer = new THREE.WebGLRenderer({
        antialias: true,
        alpha: true
    });
    parentHtmlElement.appendChild(info.renderer.domElement);

    info.camera = new THREE.PerspectiveCamera(32, aspectRatio(x, y), 1, 1000);
    info.camera.position.set(0, 0, 50);

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
    parent.add(new THREE.Line(new THREE.BufferGeometry().setFromPoints(geoPoints.x), material));
    parent.add(new THREE.Line(new THREE.BufferGeometry().setFromPoints(geoPoints.y), material));
    parent.add(new THREE.Line(new THREE.BufferGeometry().setFromPoints(geoPoints.z), material));
}


export { getMaterial, drawAxis, getCirclePoints, makeCircle, buildScene, resize }
