function polarCos(degrees, radius, offset) {
    return math.cos(math.pi * degrees / 180) * radius + offset;
}

function polarSin(degrees, radius, offset) {
    return math.sin(math.pi * degrees / 180) * radius + offset;
}

function square(n) {
    return n * n;
}

function getDistance(vector1, vector2) {
    return Math.sqrt(square(vector1.x - vector2.x) + square(vector1.y - vector2.y));
}

function addVectors(vector1, vector2) {
    return new THREE.Vector3(vector1.x + vector2.x, vector1.y + vector2.y, vector1.z + vector2.z);
}

function subVectors(vector1, vector2) {
    return new THREE.Vector3(vector1.x - vector2.x, vector1.y - vector2.y, vector1.z - vector2.z);
}

export { polarCos, polarSin, square, getDistance, addVectors, subVectors }
