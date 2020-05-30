var container;
var camera, scene, renderer, controls;
var plane;
var mouse, raycaster, isShiftDown = false;
var BOX_SIZE = 50;
var POINT_SIZE = 10;
var pointGeometry = new THREE.SphereBufferGeometry(5, 16, 16);
var cubeGeometry = new THREE.BoxGeometry(BOX_SIZE, BOX_SIZE, BOX_SIZE);

var CAMERA_X = -2000;
var CAMERA_Y = -2000;
var CAMERA_Z = 4000;

var colors = [
    0xff8080,
    0x80ff80,
    0x8080ff,
    0xffff80,
    0x80ffff,
    0xff80ff,
];

var brightColors = {
    red: 0xff0000,
    blue:0x00ff00,
    green: 0x0000ff
};

var brightMaterials = {
    red: getMat(0xff0000),
    green: getMat(0x00ff00),
    blue: getMat(0x0000ff),
    purple: getMat(0xff00ff),
};

var materials = [
    getMat(0xff8080),
    getMat(0x80ff80),
    getMat(0x8080ff),
    getMat(0xffff80),
    getMat(0x80ffff),
    getMat(0xff80ff),
];

var cubeMaterial = materials[0];

var objects = [];

init();
render();

function getMat(color) {
    return new THREE.MeshLambertMaterial({color: color});
}

function init() {
    container = document.createElement('div');
    document.body.appendChild(container);
    var info = document.createElement('div');
    info.style.position = 'absolute';
    info.style.top = '10px';
    info.style.width = '100%';
    info.style.textAlign = 'center';
    info.innerHTML = '<strong>right-mouse-button drag</strong>: rotate, <strong>click</strong>: add voxel, <strong>shift + click</strong>: remove voxel';
    container.appendChild(info);

    var menu = document.createElement('div');
    menu.style.position = 'absolute';
    menu.style.right = '10px';
    menu.style.margin = '10px';
    menu.innerHTML = '<button class="btn btn-primary" onclick="save()"><span class="glyphicon glyphicon-download"></span> Download STL</button>';
    container.appendChild(menu);

    camera = new THREE.PerspectiveCamera(40, window.innerWidth / window.innerHeight, 1, 10000);
    camera.position.set(CAMERA_X, CAMERA_Y, CAMERA_Z);
    camera.up.set(0, 0, 1);
    camera.lookAt(new THREE.Vector3());

    scene = new THREE.Scene();
    // Grid
    var size = 1000, step = 50;
    var geometry = new THREE.Geometry();
    for (var i = -size; i <= size; i += step) {
        geometry.vertices.push(new THREE.Vector3(-size, 0, i));
        geometry.vertices.push(new THREE.Vector3(size, 0, i));
        geometry.vertices.push(new THREE.Vector3(i, 0, -size));
        geometry.vertices.push(new THREE.Vector3(i, 0, size));
    }
    var material = new THREE.LineBasicMaterial({color: 0xb0b0b0, opacity: 0.2});
    var line = new THREE.LineSegments(geometry, material);
    line.rotation.set(Math.PI / 2, 0, 0);
    scene.add(line);
    //
    raycaster = new THREE.Raycaster();
    mouse = new THREE.Vector2();

    var geometry = new THREE.PlaneBufferGeometry(2000, 2000);
    geometry.rotateX(-Math.PI / 2);
    plane = new THREE.Mesh(geometry, new THREE.MeshBasicMaterial({visible: false}));
    plane.rotation.set(Math.PI / 2, 0, 0);
    scene.add(plane);
    objects.push(plane);

    var material = new THREE.MeshBasicMaterial({color: 0xff0000, wireframe: true});

    // Lights
    var ambientLight = new THREE.AmbientLight(0x606060);
    scene.add(ambientLight);

    var directionalLight = new THREE.DirectionalLight(0x808080);
    directionalLight.position.x = 1;
    directionalLight.position.y = 1;
    directionalLight.position.z = 1;
    directionalLight.position.normalize();
    scene.add(directionalLight);

    var directionalLight = new THREE.DirectionalLight(0xffffff);
    directionalLight.position.x = -1;
    directionalLight.position.y = -1;
    directionalLight.position.z = 1;
    directionalLight.position.normalize();
    scene.add(directionalLight);

    renderer = new THREE.WebGLRenderer({antialias: true});
    renderer.setClearColor(0xf0f0f0);
    renderer.setPixelRatio(window.devicePixelRatio);
    renderer.setSize(window.innerWidth, window.innerHeight);

    controls = new THREE.SelectionControls(camera, renderer.domElement);

    container.appendChild(renderer.domElement);
    controls.addEventListener('change', render);

    controls.addEventListener('change', render);
    controls.addEventListener('select-start', onDocumentMouseLeftDown);


    //document.addEventListener( 'mousedown', onDocumentMouseDown, false );
    document.addEventListener('keydown', onDocumentKeyDown, false);
    document.addEventListener('keyup', onDocumentKeyUp, false);

    window.addEventListener('resize', onWindowResize, false);
}

function onWindowResize() {
    camera.aspect = window.innerWidth / window.innerHeight;
    camera.updateProjectionMatrix();
    renderer.setSize(window.innerWidth, window.innerHeight);
    render();
}

function addXYZPoint(x, y, z, scale3d, material) {
    var point = new THREE.Mesh(pointGeometry, material);
    point.position.x = x * scale3d.x;
    point.position.y = y * scale3d.y;
    point.position.z = z * scale3d.z;
    point.overdraw = true;
    scene.add(point);

    objects.push(point);

    return point;
}

function addVoxel(point, normal) {
    var voxel = new THREE.Mesh(cubeGeometry, cubeMaterial);
    point.z = Math.round(point.z);
    normal.z = Math.round(normal.z);
    voxel.position.copy(point).add(normal);

    voxel.position.divideScalar(BOX_SIZE).floor().multiplyScalar(BOX_SIZE).addScalar(BOX_SIZE / 2);
    scene.add(voxel);

    var edges = new THREE.EdgesHelper(voxel, 0x002200);
    edges.name = "voxel-helper-" + voxel.id;
    scene.add(edges);

    objects.push(voxel);
}

function addIntVoxel(x, y, z, color) {
    addXYZVoxel(x * 50, y * 50, z * 50, color);
}

function addLine(coordinates, color) {
    var geometry = new THREE.Geometry();
    coordinates.forEach((item, index) => {
        geometry.vertices.push(new THREE.Vector3( item.x, item.y, item.z) );
    });

    var material = new THREE.LineBasicMaterial( {
        color: colors[color],
        linewidth: 10
    } );

    var line = new THREE.Line( geometry, material );
    scene.add(line);
}

function addXYZVoxel(x, y, z, color) {
    var voxel = new THREE.Mesh(cubeGeometry, materials[color]);
    voxel.position.x = Math.floor(x / 50) * 50 + 25;
    voxel.position.y = Math.floor(y / 50) * 50 + 25;
    voxel.position.z = Math.floor(z / 50) * 50 + 25;
    voxel.overdraw = true;
    scene.add(voxel);

    var edges = new THREE.EdgesHelper(voxel, 0x002200);
    edges.name = "voxel-helper-" + voxel.id;
    scene.add(edges);

    objects.push(voxel);
}


function removeObject(object) {
    var edges = scene.getObjectByName("voxel-helper-" + object.id);
    scene.remove(object);
    objects.splice(objects.indexOf(object), 1);
    scene.remove(edges);

}

function mergeVoxels(voxels) {

    var firstPosition = [voxels[0].position.x, voxels[0].position.y, voxels[0].position.z];
    var mergedModel = CSG.cube({
        center: firstPosition,
        radius: BOX_SIZE / 2
    });

    for (var i = 1; i < voxels.length; i++) {
        var pos = [voxels[i].position.x, voxels[i].position.y, voxels[i].position.z];
        var voxel = CSG.cube({
            center: pos,
            radius: BOX_SIZE / 2
        });
        mergedModel = mergedModel.union(voxel);
    }

    var polygons = mergedModel.toPolygons();
    console.log(polygons);

    //Map on simpler structure
    var vertices = [];
    var faces = [];

    var indexOffset = 0;
    polygons.forEach(function (ply) {
        for (var i = 0; i < ply.vertices.length; i++) {
            vertices.push(new THREE.Vector3(ply.vertices[i].pos.x, ply.vertices[i].pos.y, ply.vertices[i].pos.z));
        }

        faces.push(new THREE.Face3(indexOffset, indexOffset + 1, indexOffset + 2));
        faces.push(new THREE.Face3(indexOffset, indexOffset + 2, indexOffset + 3));
        indexOffset += ply.vertices.length;
    });

    return {faces: faces, vertices: vertices};

}

function onDocumentMouseLeftDown(event) {
    var content = event.content;
    //event.preventDefault();
    mouse.x = (content.clientX / renderer.domElement.clientWidth) * 2 - 1;
    mouse.y = -(content.clientY / renderer.domElement.clientHeight) * 2 + 1;
    raycaster.setFromCamera(mouse, camera);
    var intersects = raycaster.intersectObjects(objects);
    if (intersects.length > 0) {
        var intersect = intersects[0];
        if (isShiftDown) {
            if (intersect.object != plane) {
                removeObject(intersect.object);
            }
        } else {
            addVoxel(intersect.point, intersect.face.normal);
        }
        render();
    }
}

function onDocumentKeyDown(event) {
    switch (event.keyCode) {
        case 16:
            isShiftDown = true;
            break;
    }
}

function onDocumentKeyUp(event) {
    switch (event.keyCode) {
        case 16:
            isShiftDown = false;
            break;
    }
}

function generateStlString(faces, vertices) {
    var modelName = "voxels";
    var stl = new Array();
    stl.push("solid " + modelName);


    faces.forEach(function (face) {

        stl.push("facet normal 0 0 0");
        stl.push("outer loop");
        var v1 = vertices[face.a];
        var v2 = vertices[face.b];
        var v3 = vertices[face.c];

        stl.push("vertex " + v1.x + " " + v1.y + " " + v1.z);
        stl.push("vertex " + v2.x + " " + v2.y + " " + v2.z);
        stl.push("vertex " + v3.x + " " + v3.y + " " + v3.z);
        stl.push("endloop");
        stl.push("endfacet");
    });


    stl.push('endsolid ' + modelName);

    var str = stl.join("\n");
    return str;
}

function save() {
    if (objects.length > 1) {
        var geom = mergeVoxels(objects.slice(1));
        console.log(geom);

        var str = generateStlString(geom.faces, geom.vertices);

        var blob = new Blob([str]);
        saveAs(blob, "voxels.stl");
        //Merge all cubes and download
        //var myStlString = stlFromMeshList( objects.slice(1), {download:true} )
    }
    //window.open( renderer.domElement.toDataURL('image/png'), 'mywindow' );
    return false;
}

function render() {
    controls.update();
    renderer.render(scene, camera);
}
