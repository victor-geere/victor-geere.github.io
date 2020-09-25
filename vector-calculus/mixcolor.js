let hex = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f'];
let colorPalette = {};

const colorsC = [];

function makeColor(r, g, b) {
    let r1 = Math.floor(r / 16);
    let r2 = r % 16;
    let g1 = Math.floor(g / 16);
    let g2 = g % 16;
    let b1 = Math.floor(b / 16);
    let b2 = b % 16;

    let color = `#${hex[r1]}${hex[r2]}${hex[g1]}${hex[g2]}${hex[b1]}${hex[b2]}`;
    return color;
}

function saveColor(r, g, b) {
    let color = makeColor(r, g, b);
    let p = Math.floor((r + b) / 2);
    let obj = {
        color,
        r, g, b,
        p
    };
    if (!colorPalette[`b${b}`]) {
        colorPalette[`b${b}`] = [];
    }
    colorPalette[`b${b}`].push(obj);
}

function pad(s) {
    s = '000' + s;
    return s.substr(-3);
}

function mixColor() {
    let n = 0;
    let r = 0;
    let bjump = 4;
    let gjump = 4;
    let rjump = 4;
    while (r < 257) {
        let g = 0;
        while (g < 257) {
            let b = 0;
            while (b < 257) {
                let brightness = Math.floor((r+g+b) / 3);
                let y = Math.floor((r+g) / 2);
                let p = Math.floor((r+b) / 2);
                let t = Math.floor((g+b) / 2);
                if (r + g + b >= (24*8) && p === (180) && g >= 64 && g <= 200 && r-g === 52) {
                    colorsC.push(makeColor(r,g,b));
                    saveColor(r,g,b);
                }
                b = b + bjump;
            }
            g = g + gjump;
        }
        r = r + rjump;
    }
    return colorsC;
}

export { mixColor }
