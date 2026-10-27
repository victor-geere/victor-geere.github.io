var hasBeenInit = false;

var fractionAngles = [];
var fractionSides = [];

var triangles45 = [];
var triangles30 = [];

var precision = 80;

var base = 45;

/**
 * Convert a number n into base start/devisor^digit
 *
 * @param n
 * @param start
 * @param divisor
 * @returns {Array}
 */
function fractionalBase(n, start, divisor) {
    var numArray = [];
    var res = n;
    var digit = 0;
    var denominator = start;
    for (var i = 0; i < precision; i++) {
        digit = Math.floor(res / denominator);
        numArray.push(digit);
        res = (res > digit * denominator) ? res - digit * denominator : 0;
        denominator = denominator / divisor;
    }
    return numArray;
}

/**
 * Convert a number into a new base
 *
 * @param n
 * @param base
 * @returns {Array}
 */
function toBase(n, base) {
    var numArray = [];
    var res = n;
    var digit = 0;
    var denominator = 1;
    var pow = 0;
    while (Math.pow(2, pow) < n) {
        pow++;
    }
    for (var i = pow; i >= 0; i--) {
        denominator = Math.pow(base, i);
        digit = Math.floor(res / denominator);
        res = res - digit * denominator;
        numArray.push(digit);
    }
    return numArray;
}

/**
 * Calculate sin (the length of the opposite side of the triangle in the unit circle, in the +;+ quadrant)
 * by merging all the fractional triangles together.
 *
 * @param theta
 * @returns {*}
 */
function makeSin(theta) {
    var encoded = encodeAngle(theta);
    var triangle = 0;
    for (var i = 0; i < encoded.length; i++) {
        if (encoded[i]) {
            triangle = !triangle ? triangle = triangles45[i] : makeTriangle(triangle.theta + fractionAngles[i], addOpposite(triangle, triangles45[i]));
        }
    }
    return triangle.opposite;
}

function sqrt(x) {
    return Math.sqrt(x);
}

function sq(x) {
    return Math.pow(x, 2);
}

function quad(x) {
    return Math.pow(x, 4);
}

function addOpposite(t1, t2) {
    // return t2.opposite + (t2.adjacent * t1.opposite) - (t2.opposite - t2.opposite * t1.adjacent);
    // simplified
    // return t2.opposite + t2.adjacent * t1.opposite - t2.opposite * (1 - t1.adjacent);

    var a = t1.opposite;
    var b = t2.opposite;
    // using a and b as shortened version
    //return b + sqrt(1 - sq(b)) * a - b * (1 - sqrt(1 - sq(a)));

    // assuming a and b are positive, simplified
    // return b * sqrt(1 - sq(a)) + a * sqrt(1 - sq(b));

    return mergeTriangles(t1, t2).opposite;
}

/**
 * Add two sines e.g. addSine(a,b) = sin(a) * cos(b) + sin(b) * cos(a)
 * so that addSine(sin(a), sin(b)) = sin(Math.asin(a) + Math.asin(b))
 * or similarly, take two sine values, add their thetas and calculate the sine of the resulting summed theta
 * on the unit circle.
 *
 * @param a
 * @param b
 * @returns {number}
 */
function addSine(a, b) {
    return a/1 * Math.sqrt(1 - b * b) + b/1 * Math.sqrt(1 - a * a);
}

/**
 * Merge two adjacent triangles in the unit circle
 *
 * @param t1
 * @param t2
 * @returns {{theta: *, opposite: *, adjacent: number, hypotenuse: number, coordinates: Array}}
 */
function mergeTriangles(t1, t2) {
    var o1 = t1.opposite;
    var o2 = t2.opposite;

    var a1 = t1.adjacent;
    var a2 = t2.adjacent;

    var o3 = o1 * a2 + o2 * a1;
    var t3 = t1.theta + t2.theta;

    return makeTriangle(t3, o3);
}

/**
 * Subtract t2 from t1
 *
 * @param t1
 * @param t2
 * @returns t1 - t2
 */
function subtractTriangle(t1, t2) {
    var t3o = t1.o * t2.a - t2.o * t1.a;
    var t3theta = t1.theta - t2.theta;

    return makeTriangle(t3theta, t3o);
}

/**
 * Substract difference from sum
 *
 * @param x the original sum
 * @param c the value to be subtracted
 */
function substractOpposite(x, c) {
    //return x * sqrt(-(c - 1) * (c + 1)) - sqrt(sq(c) - sq(c) * sq(x));
    // simplify assuming x and c are positive
    return x * sqrt(1 - sq(c)) - c * sqrt(1 - sq(x));

    // solve for c
    // c = -sqrt(-2 x^2 y^2 - 2 sqrt(x^2 (x^2 - 1) (y^4 - y^2)) + x^2 + y^2)
    // c = +sqrt(-2 x^2 y^2 - 2 sqrt(x^2 (x^2 - 1) (y^4 - y^2)) + x^2 + y^2)
}

/**
 * Merge two adjacent triangles on the unit circle
 *
 * @param t1
 * @param t2
 * @returns {{theta: *, opposite: *, adjacent: number, hypotenuse: number, coordinates: Array}}
 */
function addTriangle(t1, t2) {
    return mergeTriangles(t1, t2);
}

function rad2deg(radians) {
    return radians * Math.PI / 180;
}

function deg2rad(degrees) {
    return degrees * 180 / Math.PI;
}

/**
 * Find the mid point between two coordinates
 *
 * @param c1 an array of [x1, y1]
 * @param c2 an array of [x2, y2]
 */
function midPoint(c1, c2) {
    return {x: (c1.x + c2.x)/2, y: (c1.y + c2.y)/2};
}

function distance(c1, c2) {
    return getHypo(Math.abs(c1.x - c2.x), Math.abs(c1.y - c2.y));
}

/**
 *
 * @param fullTriangle
 * @returns {*}
 */
function makeHalfTriangle(fullTriangle) {
    return makeTriangle(fullTriangle.theta/2, distance(fullTriangle.coordinates[2], {x: 1, y: 0})/2);
}

/**
 * Make a 45d triangle
 *
 * @returns {{theta: *, opposite: *, adjacent: number, hypotenuse: number, coordinates: Array}}
 */
function make45dTriangle() {
    // the opposite edge of a 45d triangle = sqrt(1/2)
    return makeTriangle(45, Math.sqrt(1/2));
}

/**
 * Make a 30d triangle
 *
 * @returns {{theta: *, opposite: *, adjacent: number, hypotenuse: number, coordinates: Array}}
 */
function make30dTriangle() {
    return makeTriangle(30, 0.5);
}

/**
 * Make a triangle.
 * The coordinates returned is the
 * [
 *  {x:0, y:0},
 *  {coordinates of right angle i.e. cos(x), 0},
 *  {coordinates of point on circumference i.e. cos(x), sin(x)}
 * ]
 *
 * @param theta
 * @param opposite
 * @returns {{theta: *, opposite: *, adjacent: number, hypotenuse: number, coordinates: array}}
 */
function makeTriangle(theta, opposite) {
    if (theta === 90) {
        return {
            theta: 90,
            opposite: 1,
            adjacent: 0,
            hypotenuse: 1,
            coordinates: [{x: 0, y: 0}, {x: 0, y: 0}, {x: 0, y: 1}]
        }
    }
    if (theta === 0) {
        return {
            theta: 0,
            opposite: 0,
            adjacent: 1,
            hypotenuse: 1,
            coordinates: [{x: 0, y: 0}, {x: 1, y: 0}, {x: 1, y: 0}]
        }
    }
    var hypotenuse = 1;
    var adjacent = getSide(hypotenuse, opposite);
    return {
        theta,
        opposite,
        adjacent,
        hypotenuse,
        coordinates: [{x: 0, y: 0}, {x: adjacent, y: 0}, {x: adjacent, y: opposite}]
    };
}

/**
 * Pythagoras calcs hypotenuse
 *
 * @param o
 * @param a
 * @returns {number}
 */
function getHypo(o, a) {
    return Math.sqrt(Math.pow(o, 2) + Math.pow(a, 2));
}

/**
 * Pythagoras calcs right angle
 *
 * @param h
 * @param o
 * @returns {number}
 */
function getSide(h, o) {
    return Math.sqrt(Math.pow(h, 2) - Math.pow(o, 2));
}

/**
 * Returns numerator / 2 ^ n
 *
 * @param numerator
 * @param n
 * @returns {number}
 */
function getFraction(numerator, n) {
    return numerator / Math.pow(2, n);
}

/**
 * Make an array of fractions of 90 i.e. 45, 22.5, 11.25, 5.625
 *
 * @returns {Array}
 */
function make45dFractions() {
    var triangle = make45dTriangle();
    triangles45.push(triangle);
    var n = base;
    for (var i = 0; i < precision; i++) {
        fractionAngles.push(n);
        triangle = makeHalfTriangle(triangle);
        triangles45.push(triangle);
        n = n/2;
    }
    return triangles45;
}

/**
 *
 * @returns {Array}
 */
function make30dFractions() {
    triangles30.push(makeTriangle(90, 1));
    var triangle = make30dTriangle();
    triangles30.push(triangle);
    var n = base;
    for (var i = 0; i < precision; i++) {
        fractionSides.push(n);
        triangle = makeHalfTriangle(triangle);
        triangles30.push(triangle);
        n = n/2;
    }
    return triangles30;
}

/**
 * Turns a number into an array of fractions of 45.
 * [1, 0, 1, 0...] would be returned if the input is 1*45/2^0 + 0*45/2^1 + 1*45/2^2 + 0*45/2^3 ...
 *
 * @param n
 * @returns {Array}
 */
function encodeAngle(n) {
    var numArray = [];
    var res = n;
    var digit = 0;
    for (var i = 0; i < precision; i++) {
        digit = Math.floor(res / fractionAngles[i]);
        numArray.push(digit);
        res = (res > digit * fractionAngles[i]) ? res - digit * fractionAngles[i] : 0;
    }
    return numArray;
}

/**
 * Turns an array of fractions into a number
 *
 * @param numArray
 * @returns {number}
 */
function decodeAngle(numArray) {
    var x = 0;
    for (var i = 0; i < numArray.length; i++) {
        x = x + numArray[i] * fractionAngles[i];
    }
    return x;
}

function init() {
    if (!hasBeenInit) {
        make45dFractions();
        make30dFractions();
        hasBeenInit = true;
    }
}

