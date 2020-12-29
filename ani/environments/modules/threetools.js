import { polarCos, polarSin } from "./mathtools.js";
import * as THREE from '../lib/three/build/three.module.js';
import { OrbitControls } from '../lib/OrbitControls.js';
import * as Colors from './colors.js';
import { getMaterial}  from './materials.js';
import { EffectComposer } from '../lib/three/examples/jsm/postprocessing/EffectComposer.js';
import { RenderPass } from '../lib/three/examples/jsm/postprocessing/RenderPass.js';
import { UnrealBloomPass } from '../lib/three/examples/jsm/postprocessing/UnrealBloomPass.js';

function resize(sceneInfo, x, y) {
    sceneInfo.renderer.setSize(x, y);
    if (sceneInfo.composer) {
        sceneInfo.composer.setSize(x, y);
    }
    //only for perspective camera!!!
    sceneInfo.camera.aspect = aspectRatio(x, y);
    sceneInfo.camera.updateProjectionMatrix();
}

let aspectRatio = function (width, height) {
    return width / height;
};

function addMesh(obj, resolution= 0) {
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

function makeDotTrail(curvePoints, material, xOrigin = 0, yOrigin = 0, resolution= 0) {
    console.log(curvePoints);
    const loader = new THREE.TextureLoader();
    const texture = loader.load( 'textures/sprites/disc.png' );
    const pointsMaterial = new THREE.PointsMaterial( {
        color: 0x0080ff,
        map: texture,
        size: 1,
        alphaTest: 0.5
    });

    const pointsGeometry = new THREE.BufferGeometry().setFromPoints( curvePoints );
    const points = new THREE.Points( pointsGeometry, pointsMaterial );

    return {
        properties: {
            origin: {x: xOrigin, y: yOrigin, z: 0},
            mat: pointsMaterial
        },
        curvePoints: curvePoints,
        curve: null,
        geoPoints: null,
        geo: pointsGeometry,
        mesh: points
    };
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
    obj.updatePoints = function(points) {
        this.geo.setFromPoints( points );
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
    addMesh(obj, resolution);
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
        animation: {
            doLoop: false,
            busy: false,
            nth: 0
        },
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
        addDoubleGeoToGroup: function (obj) {
            obj.mesh = new THREE.Group();
            this.objects.push(obj);
            obj.mesh.add(obj.meshBack);
            obj.mesh.add(obj.meshFront);
            if (obj.outline) {
                obj.mesh.add(obj.outline);
            }
            this.group.add(obj.mesh);
        },
        addObject: function (obj) {
            this.objects.push(obj);
            this.addObjectToGroup(obj.mesh);
        },
        removeFirstObject: function() {
            if (this.objects.length > 1) {
                let obj = this.objects[0];
                this.group.remove(obj.mesh);
                this.objects.splice(0, 1);
            }
        },
        clear: function () {
            while (this.group.children.length > 0) {
                this.group.remove(this.group.children[this.group.children.length - 1]);
            }
            this.objects = [];
        },
        render: function () {
            if (this.composer) {
                this.composer.render();
            } else {
                this.renderer.render(this.scene, this.camera);
            }
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
    camera.position.set(0, 0, 20);
    return camera;
}

function getOrthoCamera(x, y) {
    const camera = new THREE.OrthographicCamera(-x / 2, x/2, y/2, -y/2, 0, 1500);
    camera.position.set(0, 0, 50);
    return camera;
}

function getSceneOptions() {
    return {
        types: {
            camera: {
                ORTHO: 1,
                PERSPECTIVE: 0
            }
        },
        cameraType: 0,
        parentHtmlElement: document.body,
        cameraCoordinates: {
            x: 0,
            y: 0,
            z: 0
        },
        scale: 1,
        backgroundColor: 0x303035,
        light: {
            color: 0xffffff,
            position: { x: -10, y: 10, z: 10 },
            target: { x: 10, y: -10, z: -10 },
            intensity: 1,
            addBloom: false
        },
        controls: {
            enabled: true,
            minDistance: 0,
            maxDistance: 0,
            maxPolarAngle: 0
        }
    };
}

function buildDefaultScene(sceneOptions) {
    let cameraType = sceneOptions.cameraType;
    let camera;
    if (cameraType === sceneOptions.types.camera.ORTHO) {
        camera = getOrthoCamera(window.innerWidth / 25, window.innerHeight / 25);
    } else {
        camera = getPerspectiveCamera(window.innerWidth, window.innerHeight);
    }
    return buildScene(
        sceneOptions.parentHtmlElement,
        window.innerWidth,
        window.innerHeight,
        1,
        sceneOptions.backgroundColor,
        sceneOptions.lightColor,
        camera,
        sceneOptions
    );
}

function buildScene(parentHtmlElement, x, y, scale, backgroundColor, lightColor, camera, sceneOptions) {
    if (!camera) {
        // camera = getOrthoCamera(x, y);
        camera = getPerspectiveCamera(x, y);
    }
    let info = newSceneInfo();
    info.renderer = new THREE.WebGLRenderer({
        antialias: true,
        alpha: true
    });
    parentHtmlElement.appendChild(info.renderer.domElement);

    info.camera = camera;

    resize(info, x, y);

    info.scene = new THREE.Scene();
    info.scene.background = new THREE.Color(backgroundColor);

    const targetObject = new THREE.Object3D();
    targetObject.position.set(sceneOptions.light.target.x, sceneOptions.light.target.y, sceneOptions.light.target.z);
    info.scene.add(targetObject);
    const light = new THREE.DirectionalLight(sceneOptions.light.color, sceneOptions.light.intensity, Infinity);
    light.position.set(sceneOptions.light.position.x, sceneOptions.light.position.y, sceneOptions.light.position.z);
    light.target = targetObject;
    info.camera.add(light);
    info.addObjectToScene(info.camera);

    // controls
    if (sceneOptions.controls.enabled) {
        let controls = new OrbitControls(info.camera, info.renderer.domElement);
        controls.minDistance = 10;
        controls.maxDistance = 100;
        controls.maxPolarAngle = Math.PI / 2;
    }

    // populate the scene
    info.group = new THREE.Group();
    info.scale(scale);
    info.addObjectToScene(info.group);

    if (sceneOptions.light.addBloom) {
        const composer = getComposer(info);
        info.composer = composer;
    }

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

/**
 *
 * @param x
 * @param y
 * @param z
 * @param order e.g. 'XYZ','YZX','XZY',
 * @returns {THREE.Euler}
 */
function getEuler(x, y, z, order) {
    return new THREE.Euler(x, y, z, order);
}

function getComposer(sceneInfo) {
    const renderScene = new RenderPass( sceneInfo.scene, sceneInfo.camera );

    const strength = 1.5;
    const radius = 0.5;

    const bloomPass = new UnrealBloomPass( new THREE.Vector2( window.innerWidth, window.innerHeight ), strength, 1, 0 );
    bloomPass.strength = strength;
    bloomPass.radius = radius;

    const composer = new EffectComposer( sceneInfo.renderer );
    composer.addPass( renderScene );
    composer.addPass( bloomPass );

    sceneInfo.renderer.toneMappingExposure = Math.pow( 0.5, 4.0 );

    return composer;
}

export {
    drawAxis, getCirclePoints, makeCircle, makeCurve,
    buildScene, resize, newVec, getPerspectiveCamera, getOrthoCamera, makeSimpleCurve,
    makeDotTrail, buildDefaultScene, getSceneOptions, getEuler, getComposer
}
