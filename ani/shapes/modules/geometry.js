import { ConvexBufferGeometry } from '../node_modules/three/examples/jsm/geometries/ConvexGeometry.js'
import { Mesh, FrontSide, BackSide, DodecahedronGeometry,
    BoxGeometry, SphereBufferGeometry, EdgesGeometry, LineSegments } from '../lib/three.module.js';
import { getOutlineMaterial} from "./materials.js";

function __makeDoubleSided(obj) {
    obj.meshBack = new Mesh(obj.geo, obj.mat );
    obj.meshBack.material.side = BackSide; // back faces
    obj.meshBack.renderOrder = 0;

    obj.meshFront = new Mesh(obj.geo, obj.mat.clone() );
    obj.meshFront.material.side = FrontSide; // front faces
    obj.meshFront.renderOrder = 1;
}

function getDodecahedron(radius, material) {
    let obj = {
        vertices: new DodecahedronGeometry(radius).vertices,
        mat: material,
        geo: null,
        meshBack: null,
        meshFront: null
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
        meshFront: null
    };
    __makeDoubleSided(obj);
    return obj;
}

function __addOutline(obj) {
    const edges = new EdgesGeometry( obj.geo );
    const line = new LineSegments( edges, getOutlineMaterial() );
    obj.outline = line;
}

function getSphere(radius, material, widthSegments = 16, heightSegments = 16) {
    let obj = {
        mat: material,
        geo: new SphereBufferGeometry( radius, widthSegments, heightSegments ),
        meshBack: null,
        meshFront: null,
        outline: null
    };
    __makeDoubleSided(obj);
    __addOutline(obj);
    return obj;
}

export { getDodecahedron, getBox, getSphere }
