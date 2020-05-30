var RED = 'red';
var BLUE = 'blue';
var GREEN = 'green';

var t = 0, dt = 0.02;                   // t (dt delta for demo)
// var mesh;

var Point = {
    make: (x, y) => ({x, y}),
    multiply: (p1, p2) => {
        var x = p1.x * p2.x + p1.y * p2.y;
        var y = p1.x * p2.y + p2.x * p1.y;
        return {x, y};
    },
    plus: (p1, p2) => {
        var y = p1.y + p2.y;
        var x = p1.x + p2.x;
        return {x, y};
    },
    pow: (p1, p2) => {
        var power = Math.pow((p1.x + p1.y), (p2.x + p2.y));
        var y = power - Math.floor(power);
        var x = power - y;
        return {x, y};
    },
    multiplyi: (p1, p2) => {
        // complex multiplication identity
        var x = p1.x * p2.x - p1.y * p2.y;
        var y = -(p1.x * p2.y + p2.x * p1.y);
        return {x, y};
    }
};

// build();
build2();
// build3();
render();

function build() {
    // build3({base: 3, power: 3}, {base: 6, power: 3}, {base: 3, power: 5});
    // a:2^8 b:4^4 = c:8^3
    // build3({base: 2, power: 8}, {base: 4, power: 4}, {base: 8, power: 3});
    // buildModGraph1();
    // buildCosModGraph();
    drawPolarCoordinates();
    var scale = {x: 1, y: 1, z: 1};
    makePolarGraph(1, scale);
    makePolarGraph(2, scale);
    makePolarGraph(3, scale);
    makePolarGraph(4, scale);
    makePolarGraph(5, scale);
    makePolarGraph(6, scale);
    addPoint(scale);
}

function addPoint(scale3d) {
    addXYZPoint(0, 0, 0, scale3d, brightMaterials.green);
    var p1 = Point.make(0, 0);
    var p1Obj = addXYZPoint(p1.x, p1.y, 0, scale3d, brightMaterials.red);
    var p2 = Point.make(200, 200);
    var p2Obj = addXYZPoint(p2.x, p2.y, 0, scale3d, brightMaterials.blue);

    var p3 = Point.multiplyi(p1, p2);
    console.log('p1 * p2:', (p1.x + p1.y) + (p2.x + p2.y));
    console.log('p3:', p3);
    var p3Obj = addXYZPoint(p3.x, p3.y, 0, scale3d, brightMaterials.purple);
    doLoopy(p1Obj, p2Obj, p3Obj, {x: 100, y: 100, z: 1})();
}

// linear interpolation function
function lerp(a, b, t) {
    return a + (b - a) * t
}

function doLoopy(p1Obj, p2Obj, p3Obj, scale) {
    var a = {x: p1Obj.position.x, y: p1Obj.position.y, z: p1Obj.position.z};
    var b = {x: p1Obj.position.x - 100, y: p1Obj.position.y, z: p1Obj.position.z};

    return function loopy() {

        var newX = lerp(a.x, b.x, ease(t));   // interpolate between a and b where
        var newY = lerp(a.y, b.y, ease(t));   // t is first passed through an easing
        var newZ = lerp(a.z, b.z, ease(t));
        p1Obj.position.set(newX, newY, newZ);

        var p3 = Point.multiplyi({x: p1Obj.position.x, y: p1Obj.position.y}, {x: p2Obj.position.x, y: p2Obj.position.y});
        p3Obj.position.set(p3.x / scale.x, p3.y / scale.y, 0);

        t += dt;
        if (t <= 0 || t >= 1) dt = -dt;
        render();
        requestAnimationFrame(loopy)
    }
}

// example easing function (quadInOut, see link above)
function ease(t) {
    return t < 0.5 ? 2 * t * t : -1 + (4 - 2 * t) * t
}

function mod1(x) {
    return x - Math.floor(x);
}

function identity(x) {
    return x;
}

function buildCosModGraph() {
    var yFunc = (x) => mod1(x);
    var zFunc = (x) => Math.cos(Math.PI * x);
    var coordinates = makeGraph(-100, 100, 0.1, yFunc, zFunc, {x: 10, y: 100, z: 100});
    addLine(coordinates, getColN(1));
}

function buildModGraph1() {
    // var coordinates = makeGraph(-100, 100, 0.1, Math.cos, Math.sin, {x: 10, y:100, z:100});
    //var coordinates = makeModGraph(-100, 100, 0.1, (x) => x, {x: 10, y:10, z:10});
    var radius = 100;
    var fnc = (x) => {
        return Math.sqrt(Math.pow(radius, 2) - Math.pow(x, 2))
    };
    var coordinates = makeModGraph(-radius, radius, 1, fnc, {x: 5, y: 5, z: 50});
    //var coordinates = makeGraph(-radius, radius, 1, fnc, x=>x, {x: 10,y: 10,z:10});
    addLine(coordinates, getColN(1));
}

function makeGraph(xMin, xMax, xIncrement, yFunction, zFunction, scale3D) {
    var coordinates = [];
    for (var x = xMin; x <= xMax; x = x + xIncrement) {
        var y = yFunction(x);
        var z = zFunction(x);
        if (typeof (y) === "number" && typeof (z) === "number") {
            var coord = {x: x * scale3D.x, y: y * scale3D.y, z: z * scale3D.z};
            console.log(JSON.stringify(coord));
            coordinates.push(coord);
        }
    }
    return coordinates;
}

function makeModGraph(xMin, xMax, xIncrement, yFunction, scale3D) {
    var coordinates = [];
    for (var x = xMin; x <= xMax + xIncrement; x = x + xIncrement) {
        var y = yFunction(x);
        var yFract = y - Math.floor(y);
        var yWhole = y - yFract;
        var debug = {yFunc: y, yFract, yWhole, x: x * scale3D.x, y: yWhole * scale3D.y, z: yFract * scale3D.z};
        console.log(debug);
        var coord = {x: x * scale3D.x, y: yWhole * scale3D.y, z: yFract * scale3D.z};
        coordinates.push(coord);
    }
    return coordinates;
}

function drawPolarCoordinates() {
    var coordinates = [];
    coordinates.push({x: -1000, y: 0, z: 0});
    coordinates.push({x: 1000, y: 0, z: 0});
    addLine(coordinates, getColN(2));

    coordinates = [];
    coordinates.push({x: 0, y: -1000, z: 0});
    coordinates.push({x: 0, y: 1000, z: 0});
    addLine(coordinates, getColN(2));
}

function makePolarGraph(radius, scale3d) {
    var z = 0;
    var coordinates = [];
    var firstCoord;
    for (var t = 0; t <= 2 * Math.PI; t = t + 0.1) {
        var y = Math.sin(t) * radius;
        var x = Math.cos(t) * radius;
        var debug = {x, y, z};
        var coord = {x: x * scale3d.x, y: y * scale3d.y, z: z * scale3d.z};
        firstCoord = firstCoord || coord;
        coordinates.push(coord);
    }
    coordinates.push(firstCoord);
    addLine(coordinates, getColN(6));
}

function build3(cube1, cube2, cube3) {
    var yOffset = 20;
    var base = cube1.base;
    var power = cube1.power;
    var blocks = expandCube(base, Math.pow(base, power) / Math.pow(base, 3), -10, yOffset);
    console.log(`${base}^${power} = ${blocks} = ${Math.pow(base, power)}`);

    base = cube2.base;
    power = cube2.power;
    blocks = expandCube(base, Math.pow(base, power) / Math.pow(base, 3), -10, yOffset - cube1.base - 1);
    console.log(`${base}^${power} = ${blocks} = ${Math.pow(base, power)}`);

    base = cube3.base;
    power = cube3.power;
    blocks = expandCube(base, Math.pow(base, power) / Math.pow(base, 3), -10, yOffset - cube1.base - cube2.base - 2);
    console.log(`${base}^${power} = ${blocks} = ${Math.pow(base, power)}`);
}

function build2() {
    var yOffset = -20;
    var n = 1;
    var aBlocks = buildCube(n, new THREE.Vector3(-20, yOffset, 0), 0);

    console.log(`A blocks: ${aBlocks}`);

    var shellBlocks = 0;
    var shellThickness = 0;
    for (var n2 = 0; n2 < 5; n2++) {
        shellThickness++;
        yOffset = yOffset + n2 + n + 1;
        shellBlocks += buildShell(n2 + n, new THREE.Vector3(-20, yOffset, 0), n2 * 2);
        var bBlocks = aBlocks + shellBlocks;
        var bBlocksLog = {
            shellBlocks: shellBlocks,
            bBlocks: bBlocks,
            bBlocks_log2: logx(bBlocks, 2),
            bBlocks_log3: logx(bBlocks, 3),
            bBlocks_log5: logx(bBlocks, 5),
            bBlocks_log6: logx(bBlocks, 6),
            bBlocks_log7: logx(bBlocks, 7),
            bBlocks_log13: logx(bBlocks, 13),
            cBlocks: aBlocks + bBlocks,
            cBlocks_log2: logx(aBlocks + bBlocks, 2),
            cBlocks_log3: logx(aBlocks + bBlocks, 3),
            cBlocks_log5: logx(aBlocks + bBlocks, 5),
            cBlocks_log6: logx(aBlocks + bBlocks, 6),
            cBlocks_log7: logx(aBlocks + bBlocks, 7),
            cBlocks_log13: logx(aBlocks + bBlocks, 13)
        };
        console.log('B blocks: ', bBlocksLog);
    }

    var bBlocks = aBlocks + buildCube(n + shellThickness, new THREE.Vector3(-20, yOffset + shellThickness + n + 1, 0), 1);

    expandCube(3, 8, -20, 20);
}

function logx(n, power) {
    var x = n;
    var log = 0;

    while (x >= power) {
        x = x / power;

        log++;
    }

    if (x !== 1) {
        log = null;
    }
    return log;
}

function expandCube(a, n, xOffset, yOffset) {
    var blocks = 0;
    for (var i = 0; i < n; i++) {
        // blocks += buildCube(a, new THREE.Vector3(xOffset + i*(a + 1), yOffset - a, 0), i === 0 ? 0 : 1) ;
        blocks += buildCube(a, new THREE.Vector3(xOffset, yOffset - a, i * (a + 1)), i === 0 ? 0 : 1);
    }
//    blocks += buildCube(a, new THREE.Vector3(xOffset + (n - 1)*(a + 1), yOffset - a, 0), 4) ;
    return blocks;
}

function buildCube(n, offset, colorIndex) {
    var blocks = 0;
    for (var x = 0; x < n; x++) {
        for (var y = 0; y < n; y++) {
            for (var z = 0; z < n; z++) {
                if (z === 0 || x === 0 || y === 0 || x === n - 1 || y === n - 1 || z === n - 1) {
                    addIntVoxel(x + offset.x, y + offset.y, z + offset.z, colorIndex);
                }
                blocks++;
            }
        }
    }
    return blocks;
}

function getColN(n) {
    while (n >= materials.length) {
        n = n - materials.length;
    }
    return n;
}

function buildShell(n, offset, colorOffset) {
    var blocks = 0;

    var y = n;
    for (var x = 0; x < n; x++) {
        for (var z = 0; z <= n; z++) {
            addIntVoxel(offset.x + x, offset.y + y, offset.z + z, getColN(colorOffset + 1));
            blocks++;
        }
    }

    var x = n;
    for (var y = 0; y <= n; y++) {
        for (var z = 0; z < n; z++) {
            addIntVoxel(offset.x + x, offset.y + y, offset.z + z, getColN(colorOffset + 2));
            blocks++;
        }
    }

    var z = n;
    for (var y = 0; y < n; y++) {
        for (var x = 0; x <= n; x++) {
            addIntVoxel(offset.x + x, offset.y + y, offset.z + z, getColN(colorOffset + 3));
            blocks++;
        }
    }

    addIntVoxel(offset.x + n, offset.y + n, offset.z + n, getColN(colorOffset + 4));
    blocks++;

    return blocks;
}