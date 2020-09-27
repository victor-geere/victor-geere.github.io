import {Vector3} from './lib/three.module.js';

function polarCos(degrees, radius, offset) {
    return math.cos(math.pi * degrees / 180) * radius + offset;
}

function roundTo(real, radix) {
    let factor = Math.pow(10, radix);
    return Math.round(real * factor) / factor;
}

function polarSin(degrees, radius, offset) {
    return math.sin(math.pi * degrees / 180) * radius + offset;
}

function square(n) {
    return n * n;
}

function scaleVectors(vectorArray, xRatio, yRatio, zRatio) {
    vectorArray.forEach((vector) => {
        vector.x = vector.x * xRatio;
        vector.y = vector.y * yRatio;
        vector.z = vector.z * zRatio;
    });
}

function getDistance(vector1, vector2) {
    return Math.sqrt(square(vector1.x - vector2.x) + square(vector1.y - vector2.y));
}

function addVectors(vector1, vector2) {
    return new Vector3(vector1.x + vector2.x, vector1.y + vector2.y, vector1.z + vector2.z);
}

function subVectors(vector1, vector2) {
    return new Vector3(vector1.x - vector2.x, vector1.y - vector2.y, vector1.z - vector2.z);
}

function subVectorsXY(vector1, vector2) {
    return new Vector3(vector1.x - vector2.x, vector1.y - vector2.y, vector1.z);
}

function moveVectors(vectorArray, x, y, z) {
    vectorArray.forEach((vector) => {
        vector.x = vector.x + x;
        vector.y = vector.y + y;
        vector.z = vector.z + z;
    });
}

export { polarCos, polarSin, square, getDistance, addVectors, subVectors, moveVectors, subVectorsXY, roundTo, scaleVectors }
