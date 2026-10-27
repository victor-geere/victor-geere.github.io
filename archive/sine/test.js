var test = {
    precision: Math.pow(10,-10),

    getFraction() {
        if (getFraction(45, 5) === fractionAngles[5]) {
            console.log(`getFraction works expected ${getFraction(45, 5)} and got ${fractionAngles[5]}`);
            return true;
        } else {
            console.error(`ERROR : getFraction expected ${getFraction(45, 5)} but got ${fractionAngles[5]}`);
            return false;
        }
    },

    stuff() {
        var h = 5;
        var o = 2.5;
        var a = getSide(h, o);
        console.log('h', h); // 5.5901699437494745
        console.log('cos', a/h);
        console.log('sin', o/h);
        console.log('Math.sin', Math.sin(rad2deg(30)));
        console.log('calc o', Math.sin(rad2deg(30)) * h);
        console.log('Math.asin o/h', deg2rad(Math.asin(o/h)));
        console.log('Math.sin asin', Math.sin(Math.asin(o/h)));
        return true;
    },

    addOpposite: function() {
        // add the opposite angles of a 45 degree and 22.5 degree angle
        var result = addOpposite(triangles45[0], triangles45[1]);
        if (Math.abs(result - Math.sin(rad2deg(triangles45[0] + triangles45[1]))) > test.precision) {
            console.error(`ERROR : addOpposite: expected ${Math.sin(rad2deg(45 + 22.5))} but found ${result}`);
            return false;
        } else {
            console.log(`addOpposite: expected ${Math.sin(rad2deg(45 + 22.5))} and found ${result}`);
            return true;
        }
    },

    /**
     * Test encoding and decoding
     *
     * @param n
     */
    encodingDecoding: function (n)
    {
        var result = false;
        var encoded = encodeAngle(n);
        var decoded = decodeAngle(encoded);
        if (n === decoded) {
            console.log('encodingDecoding : test', {num: n, encoded, decoded});
            result  = true;
        } else {
            console.error('ERROR : encodingDecoding : test', {num: n, encoded, decoded});
            return false;
        }
        return result;
    },

    make45dTriangle: function () {
        var result = false;
        var t45 = make45dTriangle();
        if(Math.abs(t45.opposite - Math.sin(rad2deg(45))) < precision) {
            console.log('make45dTriangle : t45.opposite', t45.opposite);
            result = true;
        } else {
            console.error(`ERROR : make45dTriangle : t45.opposite : ${t45.opposite} expected : ${Math.sin(rad2deg(45))} difference : ${t45.opposite - Math.sin(rad2deg(45))}`);
            result = false;
        }
        return result;
    },

    make30dTriangle: function () {
        var result = false;
        var t30 = make30dTriangle();
        if(Math.abs(t30.opposite - Math.sin(rad2deg(30))) < precision) {
            console.log('make30dTriangle : t30.opposite', t30.opposite);
            result = true;
        } else {
            console.error(`ERROR : make30dTriangle : t30.opposite : ${t30.opposite} expected : ${Math.sin(rad2deg(30))} difference : ${t30.opposite - Math.sin(rad2deg(30))}`);
            result = false;
        }
        if (Math.abs(t30.adjacent - Math.cos(rad2deg(30))) > precision) {
            console.error(`ERROR : make30dTriangle : t30.adjacent : ${t30.adjacent} expected : ${Math.cos(rad2deg(30))} difference : ${t30.adjacent - Math.cos(rad2deg(30))}`);
            result = false;
        }
        return result;
    },

    makeHalfTriangle: function () {
        var result = false;
        var t45 = make45dTriangle();
        var t225 = makeHalfTriangle(t45);
        if(Math.abs(t225.opposite - Math.sin(rad2deg(22.5))) < precision) {
            console.log('makeHalfTriangle : t225.opposite', t225.opposite);
            result = true;
        } else {
            console.error(`ERROR : makeHalfTriangle : t225.opposite : ${t225.opposite} expected : ${Math.sin(rad2deg(225))} difference : ${t225.opposite - Math.sin(rad2deg(225))}`);
            result = false;
        }
        return result;
    },

    triangleCoords: function() {
        var t60 = makeTriangle(30, 0.5);
        var expected = [{x: 0, y: 0}, {x: Math.sqrt(3)/2, y: 0}, {x: Math.sqrt(3)/2, y: 0.5}];
        if (
            t60.coordinates[0].x === expected[0].x &&
            t60.coordinates[0].y === expected[0].y &&
            t60.coordinates[1].x === expected[1].x &&
            t60.coordinates[1].y === expected[1].y &&
            t60.coordinates[2].x === expected[2].x &&
            t60.coordinates[2].y === expected[2].y
        ) {
            console.log(`triangleCoords : expected : ${expected} and found ${t60.coordinates}`);
            return true;
        } else {
            console.error(`ERROR : triangleCoords : expected : ${expected} found ${t60.coordinates}`);
            return false;
        }
    },

    midPoint: function () {
        var mid = midPoint({x: 5, y: 7}, {x: 1, y: 3});
        if (mid.x === 3 && mid.y === 5) {
            console.log('midPoint of {x: 5, y: 7}, {x: 1, y: 3} = ', mid);
            return true;
        } else {
            console.log(`midPoint : expected {x:3, y:5} but found : `, mid);
            return false;
        }
    },

    sin : function() {
        var result = false;
        var s = 0;
        for (i = 1; i < 90; i = i + 0.1) {
            s = sin(i);
            if (Math.abs(Math.sin(rad2deg(i)) - s) > test.precision) {
                console.error(`ERROR : sin(${i}) expected ${Math.sin(rad2deg(i))} but found ${s} diff : ${Math.sin(rad2deg(i)) - s}`);
                return false;
            } else {
                result = true;
                // console.log(`sin(${i}) expected ${Math.sin(rad2deg(i))} and found ${s} diff : ${Math.sin(rad2deg(i)) - s}`);
            }
        }
        return result;
    },

    fractionalBase : function() {
        var original = 1234;
        var x = fractionalBase(original, 45, 2);
        var expected = decodeAngle(x);
        console.log('fractionalBase 1234, 45, 2', x);
        console.log('decoded x', decodeAngle(x));
        return (expected === original);
    },

    asin: function() {
        var radpi = 0;
        var sinradpi = 0;
        var theta = 0;
        var data = [];

        var result = false;

        for (var i = 0; i <= 1; i = i + 0.01) {
            radpi = deg2rad(i * Math.PI);
            if (radpi <= 90) {
                sinradpi = sin(radpi);
                theta = asin(sinradpi);

                data.push({
                    x: i,
                    radOfxPi: radpi,
                    sinRadOfxPi: sinradpi,
                    arcsin: theta,
                    mathArcSin: deg2rad(Math.asin(sinradpi))
                });

                if (Math.abs(radpi - theta) > test.precision) {
                    console.log(`arcsine of ${sinradpi} = ${theta} but expected ${radpi}`);
                    return false;
                } else {
                    result = true;
                }
            }
        }
        console.log('arcsin debug data', data);
        return result;
    },

    addTriangle: function() {
        var t1 = make45dTriangle();
        var t2 = make30dTriangle();
        var t3 = addTriangle(t1, t2);

        if (Math.abs(t3.opposite - sin(75)) < test.precision) {
            console.log(`addTriangle expected ${sin(75)} and got ${t3.opposite}`, );
            return true;
        } else {
            console.log(`ERROR : addTriangle expected ${sin(75)} but got ${t3.opposite}`, );
            return false;
        }
    },

    addSine: function(a, b) {
        var actual = addSine(a, b);
        var expected = Math.sin(Math.asin(a) + Math.asin(b));
        if (actual === expected) {
            console.log('addSine worked');
            return true;
        } else {
            console.log(`expected ${expected} but got ${actual}`);
            return false;
        }
    },

    getSimpleSine: function(n) {
        var startDate = new Date();
        for (var i = 0; i < n; i++) {
            getSimpleSine(Math.random());
        }
        var endDate = new Date();
        console.log('simple sine duration: ', endDate - startDate);
        return true;
    },

    getMathSine: function(n) {
        var startDate = new Date();
        for (var i = 0; i < n; i++) {
            mathSine(Math.random());
        }
        var endDate = new Date();
        console.log('normal sine duration: ', endDate - startDate);
        return true;
    },

};

function runTests() {
    var result = true;
    result = result && test.sin();
    result = result && test.encodingDecoding(45);
    result = result && test.encodingDecoding(22.5);
    result = result && test.encodingDecoding(90);
    result = result && test.encodingDecoding(900);
    result = result && test.encodingDecoding(32);
    result = result && test.encodingDecoding(2376453.565342);
    result = result && test.make45dTriangle();
    result = result && test.make30dTriangle();
    result = result && test.makeHalfTriangle();
    result = result && test.triangleCoords();
    result = result && test.midPoint();
    result = result && test.addOpposite();
    result = result && test.stuff();
    result = result && test.getFraction();
    result = result && test.fractionalBase();
    result = result && test.asin();
    result = result && test.addTriangle();
    result = result && test.addSine(0.523, 0.3123);
    result = result && test.getSimpleSine(10);
    result = result && test.getMathSine(10);
    if (!result) {
        alert('Tests failed, view console.');
    }
}