import { Vector3 } from '../lib/three/build/three.module.js';

function getEta(k, a, b, baseFactor = 1, numerator = 1) {
    const kx = k * baseFactor;
    const text = `${numerator}/(${kx}^(${a} + ${b}i))`;
    return math.evaluate(text);
}

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

function addVectorArray(vectorA1, vectorA2) {
    const vectorA3 = [];
    vectorA1.forEach((vector1, index) => {
        if (vectorA2[index]) {
            vectorA3.push(new Vector3(
                vector1.x + vectorA2[index].x,
                vector1.y + vectorA2[index].y,
                vector1.z + vectorA2[index].z,
            ));
        }
    });
    return vectorA3;
}

function subtractVectorArray(vectorA1, vectorA2, onlyXY = true) {
    const vectorA3 = [];
    vectorA1.forEach((vector1, index) => {
        if (vectorA2[index]) {
            let z = onlyXY ? vector1.z : vector1.z - vectorA2[index].z;
            vectorA3.push(new Vector3(
                vector1.x - vectorA2[index].x,
                vector1.y - vectorA2[index].y,
                z,
            ));
        }
    });
    return vectorA3;
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

export { polarCos, polarSin, square, getDistance, addVectors, subVectors,
    moveVectors, subVectorsXY, roundTo, scaleVectors, addVectorArray, subtractVectorArray,
    getEta }
