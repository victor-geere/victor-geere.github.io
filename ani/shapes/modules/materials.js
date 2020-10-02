import { rainbow } from "./colors.js";

let materialCache = {};

function getPointsMaterial(colorN, size=0.125) {
    let color = rainbow[colorN];
    const key = `mat_${colorN}`;
    if (materialCache[key]) {
        return materialCache[key];
    }
    const loader = new THREE.TextureLoader();
    const texture = loader.load('textures/sprites/disc.png');
    const mat = new THREE.PointsMaterial({
        color: color,
        map: texture,
        size: size,
        alphaTest: 0.5
    });
    materialCache[key] = mat;
    return mat;
}

export { getPointsMaterial }
