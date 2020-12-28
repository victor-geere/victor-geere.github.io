function getBin(dec) {
    return parseInt(dec, 10).toString(2);
}

function round(r) {
    return Math.round(r * 1000) / 1000;
}

function trunc(r, radix = 3) {
    const s = Math.pow(10, radix);
    return Math.floor(r * s) / s;
}

function ratio(a, b) {
    return ((a * b) > 0) ? (a / b) : 0;
}

function isMulti(n) {
    return (((n - 4) / 6) % 1 === 0);
}

function grain(a) {
    return isMulti(a) ? round((a - 4) / 6) : 0;
}

function pad(l1, l2) {
    let p = '';
    while (l2 > l1 && p.length < l2 - l1) {
        p = p + ' ';
    }
    return p;
}

function padn(n, l) {
    let p = '' + n;
    while (p.length < l) {
        p = ' ' + p;
    }
    return p;
}

function append(txt) {
    const tx = document.getElementById('text');
    tx.innerHTML += txt;
}

function print(s, padN = 10) {
    append(padn(s, padN));
}

function printLn(s) {
    print(s);
    append('\n');
}

function printColor(s) {
    if (isMulti(s)) {
        append('<span class="red">' + padn(s, 10) + '</span>');
    } else if (s % 3 === 0) {
        append('<span class="black">' + padn(s, 10) + '</span>');
    } else if (s % 3 === 1) {
        append('<span class="cyan">' + padn(s, 10) + '</span>');
    } else {
        append('<span class="blue">' + padn(s, 10) + '</span>');
    }
}

function getRealGeneration(n, chronologically = true) {
    let recipe = '';
    let t = n;
    let done = false;
    let gen = 0;
    let recipeArray = [];
    while (!done && gen < 80) {
        let ln = Math.log2(t);
        let oLine = 0;
        while (t % 2 === 0) {
            t = t / 2;
            oLine ++;
        }
        if (ln % 1 === 0) {
            done = true;
            if (chronologically) {
                recipe = recipe + `${oLine}`;
                recipeArray.push(oLine);
            } else {
                recipe = `${oLine}` + recipe;
                recipeArray.unshift(oLine);
            }
            oLine = 0;
        } else {
            if (chronologically) {
                recipe = recipe + `${oLine}-`;
                recipeArray.push(oLine);
            } else {
                recipe = `-${oLine}` + recipe;
                recipeArray.unshift(oLine);
            }
            oLine = 0;
            t = t * 3 + 1;
            gen++;
        }
    }
    return done ? { n, gen, recipe, recipeAr: recipeArray } : { n, gen, recipe: '', recipeAr: [] };
}

function sortElementsByRecipe(arrayOfObjects) {
    arrayOfObjects.sort((v1, v2) => {
        if (v1.recipe.length < v2.recipe.length) {
            return -1;
        } else if (v1.recipe.length > v2.recipe.length) {
            return 1;
        } else if(v1.recipe < v2.recipe) {
            return -1;
        } else if(v1.recipe > v2.recipe) {
            return 1;
        } else {
            return 0;
        }
    });
}

