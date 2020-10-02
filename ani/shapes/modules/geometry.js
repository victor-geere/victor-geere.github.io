import { ConvexBufferGeometry } from '../node_modules/three/examples/jsm/geometries/ConvexGeometry.js'
import { Mesh, FrontSide, BackSide, DodecahedronGeometry } from '../lib/three.module.js';

function getDodecahedron(radius, material) {
    let obj = {
        vertices: new DodecahedronGeometry(radius).vertices,
        mat: material,
        geo: null,
        meshBack: null,
        meshFront: null
    };

    obj.geo = new ConvexBufferGeometry(obj.vertices);

    obj.meshBack = new Mesh(obj.geo, obj.mat );
    obj.meshBack.material.side = BackSide; // back faces
    obj.meshBack.renderOrder = 0;

    obj.meshFront = new Mesh(obj.geo, obj.mat.clone() );
    obj.meshFront.material.side = FrontSide; // front faces
    obj.meshFront.renderOrder = 1;

    return obj;
}

export { getDodecahedron }
