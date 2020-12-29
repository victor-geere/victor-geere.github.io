import { ConvexBufferGeometry } from '../lib/three/examples/jsm/geometries/ConvexGeometry.js'
import { Mesh, FrontSide, BackSide, DodecahedronGeometry, CylinderBufferGeometry,
    BoxGeometry, SphereBufferGeometry, EdgesGeometry, LineSegments } from '../lib/three/build/three.module.js';
import { getOutlineMaterial} from "./materials.js";

function __makeDoubleSided(obj) {
    let mats = [];
    if (!Array.isArray(obj.mat)) {
        mats = [obj.mat, obj.mat.clone()];
    } else {
        mats = obj.mat;
    }

    mats[0].side = BackSide; // back faces
    obj.meshBack = new Mesh(obj.geo, mats[0] );
    obj.meshBack.renderOrder = 0;

    mats[1].side = FrontSide; // front faces
    obj.meshFront = new Mesh(obj.geo, mats[1] );
    obj.meshFront.renderOrder = 1;
}

function __addOutline(obj) {
    const edges = new EdgesGeometry( obj.geo );
    obj.outline = new LineSegments( edges, getOutlineMaterial() );
}

function getDodecahedron(radius, material) {
    let obj = {
        vertices: new DodecahedronGeometry(radius).vertices,
        mat: material,
        geo: null,
        meshBack: null,
        meshFront: null,
        outline: null,
        children: []
    };

    obj.geo = new ConvexBufferGeometry(obj.vertices);
    __makeDoubleSided(obj);
    return obj;
}

function getBox(size, material) {
    let obj = {
        mat: material,
        geo: new BoxGeometry( size, size, size),
        meshBack: null,
        meshFront: null,
        outline: null,
        children: []
    };
    __makeDoubleSided(obj);
    return obj;
}

function getSphere(radius, material, widthSegments = 16, heightSegments = 16) {
    let obj = {
        mat: material,
        geo: new SphereBufferGeometry( radius, widthSegments, heightSegments ),
        meshBack: null,
        meshFront: null,
        outline: null,
        children: []
    };
    __makeDoubleSided(obj);
    __addOutline(obj);
    return obj;
}

function getCylinder(radiusTop, radiusBottom, radialSegments = 16, heightSegments = 1, height, material, outline, rotation) {
    let obj = {
        mat: material,
        geo: new CylinderBufferGeometry( radiusTop, radiusBottom, height, radialSegments, heightSegments, false, 0, 2 * Math.PI ),
        meshBack: null,
        meshFront: null,
        outline: null,
        children: []
    };
    __makeDoubleSided(obj);
    obj.meshBack.rotateX(rotation.x * Math.PI / 180);
    obj.meshFront.rotateX(rotation.x * Math.PI / 180);
    obj.meshBack.rotateY(rotation.y * Math.PI / 180);
    obj.meshFront.rotateY(rotation.y * Math.PI / 180);
    obj.meshBack.rotateZ(rotation.z * Math.PI / 180);
    obj.meshFront.rotateZ(rotation.z * Math.PI / 180);
    if (outline) {
        __addOutline(obj);
    }
    return obj;
}

export { getDodecahedron, getBox, getSphere, getCylinder }
