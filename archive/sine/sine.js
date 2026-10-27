/**
 * Calculates sin for any quadrant of the unit circle based on the result in the +;+ quadrant.
 * i.e. accept 360 degree input, not just 90 degree
 *
 * @param theta
 * @returns {*}
 */
function sin(theta) {
    init();
    theta = theta % 360;
    var s = 0;
    if ((theta > 90 && theta <= 180) || (theta > 270 && theta <= 360)) {
        s = makeSin(180 - theta % 180);
    } else {
        s = makeSin(theta % 180);
    }
    if (theta > 180) {
        s = -s;
    }
    return s;
}

/**
 * Calculate the inverse of sin
 *
 * @param sinInput
 */
function asin(sinInput) {
    init();
    var triangle = null;
    var y = sinInput;
    var encodedTest = [];

    var theta = 0;
    for (var i = 0; i < triangles45.length; i++) {
        triangle = triangles45[i];
        if (y == triangle.opposite) {
            encodedTest.push(1);
            y = 0;
            theta = theta + triangle.theta;
        } else if (substractOpposite(y, triangle.opposite) >= 0) {
            y = substractOpposite(y, triangle.opposite);
            encodedTest.push(1);
            theta = theta + triangle.theta;
        } else {
            encodedTest.push(0);
        }
    }
    return theta;
}

function xsin(theta) {
    var stretched = theta / 2;
    var whole = Math.floor(stretched);
    var res = stretched - whole;
    var result = makeSin(deg2rad(res * Math.PI) % 90);
    return Math.floor(theta) + result;
}

/**
 * p is the product for which sin(pi * p / x) should be calculated
 *
 * @param p
 * @returns {*}
 */
function prodSin(p, theta) {
    var stretched = theta / 2;
    var whole = Math.floor(stretched);
    var res = stretched - whole;
    var result = makeSin(deg2rad((p * Math.PI) / res));
    return Math.floor(theta) + result;
}

function xasin(opposite) {
    var whole = Math.floor(opposite);
    var res = opposite - whole;
    var theta = asin(res) / 90;
    return whole + theta;
}

