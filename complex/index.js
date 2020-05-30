function repeat(limit, increment, fn) {
    var data = {
        x : [],
        y : []
    };
    var n = 0;
    for (var i = 0; i <= limit; i = i + increment) {
        data.x.push(i);
        data.y.push(fn(i, n++));
    }
    console.log('data', data);
    return data;
}

function getSines() {
    var data = {
        x : [],
        y : []
    };
    for (var i = 0; i <= 2; i = i + 0.01) {
        data.x.push(i);
        data.y.push(sin(deg2rad(i * Math.PI)));
        // console.log('deg2rad(i * Math.PI)', deg2rad(i * Math.PI));
        // data.y.push(Math.sin(rad2deg(i)));
    }
    console.log('data', data);
    return data;
}

/**
 * Add up selected angles from [90, 45, 22.5, 11.25, ...] so that the sum approaches Theta * 180
 * Merge the corresponding triangles in the unit circle of the angles above, thus melding the opposite edges (sines).
 * The melded opposite edges is the sine of Theta
 *
 * @param x The angle to calculate sine for
 * @param n
 * @returns {number}
 */
function getSimpleSine(x, n) {
    // meld two sine values by sin(a) * cos(b) + sin(b) * cos(a)
    var addSine = (a, b) => a/1 * Math.sqrt(1 - b * b) + b/1 * Math.sqrt(1 - a * a);
    // pythagoras calculate the distance between two coordinates as the hypotenuse of the distances between x's and y's respectively
    var distance = (c1, c2) => Math.sqrt(Math.pow(Math.abs(c1.x - c2.x),2) + Math.pow(Math.abs(c1.y - c2.y), 2));

    var thisAngle = 90; // we start with the first element in [90, 45, 22.5, 11.25, ...] and halve it with each iteration
    var thisSine = 1; // the sine of 90 = 1, which we'll use in this iteration
    var targetAngle = 180 * x; // the angle we're going to calculate sine for
    var summedAngle = 0; // all the applicable angles in [90, 45, 22.5, 11.25...], those that have been added up towards the targetAngle
    var sineX = 0; // the sine of x will go in here
    var precisionFactor = 100; // don't get weird

    // while the sum of the angles is less than the target angle and limited by the precision factor
    while(summedAngle < targetAngle && precisionFactor-- > 0) {
        // if adding the currently considered fraction of 90 (CCF90) won't go above the target angle
        if (summedAngle + thisAngle <= targetAngle) {
            summedAngle += thisAngle; // add the CCF90 to the summed angle towards the target
            sineX = addSine(sineX, thisSine); // meld the sine of the CCF90 into the answer
        }
        thisAngle = thisAngle / 2; // prepare half the angle for the next iteration
        thisSine = distance({x: Math.sqrt(1 - thisSine * thisSine), y: thisSine}, {x: 1, y: 0})/2; // prepare half the sine for the next iteration
    }
    var error = (Math.round((sineX - Math.sin(x * Math.PI)) * Math.pow(10, 10)) / Math.pow(10, 10));
    if (error > 0.0000000001) {
        console.log(`error margin: ${error}, angle = ${targetAngle}, sine: ${sineX}, Math.sin: ${Math.sin(x * Math.PI)}`);
    }
    return sineX; // the answer within the precision factor
}

/**
 *
 * @returns {{x: Array, y: Array}}
 */
function simpleSine() {
    // calculate sine for each multiple of 0.01 up to 1
    return repeat(0.5, 0.005, getSimpleSine);
}

function mathSine(x) {
    return Math.sin(x);
}

/*
* inputSum add x < deg
* */

function getXSines() {
    var data = {
        x : [],
        y : []
    };
    for (var i = 0; i <= 5; i = i + 0.01) {
        data.x.push(i);
        data.y.push(xsin(i));
    }
    console.log('data', data);
    return data;
}

function getXASines() {
    var data = {
        x : [],
        y : []
    };
    for (var i = 0; i <= 5; i = i + 0.01) {
        data.x.push(i);
        data.y.push(xasin(xsin(i)));
    }
    console.log('data', data);
    return data;
}

function getProdSines() {
    var data = {
        x : [],
        y : []
    };
    for (var i = 0; i <= 5; i = i + 0.01) {
        data.x.push(i);
        data.y.push(prodSin(6, i));
    }
    console.log('data', data);
    return data;
}
