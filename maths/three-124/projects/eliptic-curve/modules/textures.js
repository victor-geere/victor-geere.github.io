import * as THREE from '../../../lib/three/build/three.module.js';
import { SVGLoader } from '../../../lib/three/examples/jsm/loaders/SVGLoader.js';

function loadSvg(svgUrl, sceneInfo, fill = { color: null }) {
// instantiate a loader
    const loader = new SVGLoader();

    loader.load( svgUrl, function ( data ) {

        let paths = data.paths;

        let group = new THREE.Group();
        group.scale.multiplyScalar( 0.01 );
        group.position.x = -2.5;
        group.position.y = 2.55;
        group.scale.y *= - 1;

        for ( let i = 0; i < paths.length; i ++ ) {

            let path = paths[ i ];

            let fillColor = fill.color || path.userData.style.fill;
            if ( fillColor !== undefined && fillColor !== 'none' ) {
                let material = new THREE.MeshBasicMaterial( {
                    color: new THREE.Color().setStyle( fillColor ),
                    opacity: path.userData.style.fillOpacity,
                    transparent: path.userData.style.fillOpacity < 1,
                    side: THREE.DoubleSide,
                    depthWrite: false,
                    wireframe: false
                } );

                let shapes = path.toShapes( true );

                for ( let j = 0; j < shapes.length; j ++ ) {
                    let shape = shapes[ j ];
                    let geometry = new THREE.ShapeBufferGeometry( shape );
                    let mesh = new THREE.Mesh( geometry, material );
                    group.add( mesh );
                }
            }

            let strokeColor = path.userData.style.stroke;
            if ( strokeColor !== undefined && strokeColor !== 'none' ) {
                let material = new THREE.MeshBasicMaterial( {
                    color: new THREE.Color().setStyle( strokeColor ),
                    opacity: path.userData.style.strokeOpacity,
                    transparent: path.userData.style.strokeOpacity < 1,
                    side: THREE.DoubleSide,
                    depthWrite: false,
                    wireframe: false
                } );

                for ( let j = 0, jl = path.subPaths.length; j < jl; j ++ ) {
                    let subPath = path.subPaths[ j ];
                    let geometry = SVGLoader.pointsToStroke( subPath.getPoints(), path.userData.style );
                    if ( geometry ) {
                        let mesh = new THREE.Mesh( geometry, material );
                        group.add( mesh );
                    }
                }
            }
        }

        sceneInfo.group.add( group );

    } );

}

export { loadSvg }
