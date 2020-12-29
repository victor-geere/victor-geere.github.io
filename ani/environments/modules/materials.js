import { cartoon, rainbow } from './colors.js';
import * as THREE from "../lib/three/build/three.module.js";

let materialCache = {};


function getMaterialOptions() {
    return {
        color: 0x808080,
        transparent: true,
        opacity: 0.5
    }
}

function getCustomMaterial(palette, colorN, options) {
    return new THREE.MeshBasicMaterial({...options, color: palette[colorN]});
}

function getMaterial(palette, colorN, opacity = 0) {
    if (opacity) {
        return new THREE.MeshBasicMaterial({
            color: palette[colorN],
            opacity: opacity,
            transparent: true
        })
    }
    return new THREE.MeshBasicMaterial({
        color: palette[colorN]
    })
}

function getCartoonMaterial(colName) {
    console.log(`cartoon[${colName}] : `, cartoon[colName]);
    return new THREE.MeshLambertMaterial({
        color: cartoon[colName],
        opacity: 1,
        transparent: true
    })
}

function getStandardMaterial(options) {
    return new THREE.MeshStandardMaterial(options)
}

function getPhongLight(colorHex, emissiveColorHex, intensity, opacity = 0.1) {
    return new THREE.MeshPhongMaterial({
        color: colorHex,
        opacity,
        transparent: true,
        emissive: emissiveColorHex,
        emissiveIntensity: intensity
    })
}

function getGlassOptions() {
    const m = {
        map: null,
        color: 0x0000ff,
        metalness: 0,
        roughness: 0,
        opacity: 0.25,
        side: THREE.FrontSide,
        transparent: true,
        envMapIntensity: 10,
        premultipliedAlpha: true
    };
    return m;
}

function getGlassMaterial(options) {
    return new THREE.MeshPhysicalMaterial(options);
}

function getPhongMaterial(palette, colorN, opacity = 0) {
    if (opacity) {
        return new THREE.MeshPhongMaterial({
            color: palette[colorN],
            opacity: opacity,
            transparent: true
        })
    }
    return new THREE.MeshPhongMaterial({
        color: palette[colorN]
    })
}

function getLambertMaterial(palette, colorN, opacity = 0) {
    if (opacity) {
        return new THREE.MeshLambertMaterial({
            color: palette[colorN],
            opacity: opacity,
            transparent: true
        })
    }
    return new THREE.MeshLambertMaterial({
        color: palette[colorN]
    })
}

function getLineMaterial(palette, colorN, opacity = 0) {
    if (opacity) {
        return new THREE.LineBasicMaterial({
            color: palette[colorN],
            opacity: opacity,
            transparent: true
        })
    }
    return new THREE.LineBasicMaterial({
        color: palette[colorN]
    })
}

function getOutlineMaterial() {
    return new THREE.LineBasicMaterial( {
        color: 0x707080,
        opacity: 0.75,
        transparent: true
    } );
}

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

export { getPointsMaterial, getMaterial, getLineMaterial, getCustomMaterial, getMaterialOptions,
    getPhongMaterial, getLambertMaterial, getOutlineMaterial, getPhongLight, getCartoonMaterial,
    getStandardMaterial, getGlassMaterial, getGlassOptions }
