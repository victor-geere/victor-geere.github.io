function oki(n) {
    return Math.pow((Math.sin(n) / 4),2);
}


/*
y = (sin(px) / 2)^2;

asin(2 * sqrt(y)) = x
-------------------
    pi
*/

function doki(n) {
    console.log('n', n);
    var sqrt2 = Math.sqrt(n);
    console.log('sqrt2', sqrt2);
    var asin = Math.asin(sqrt2);
    console.log('asin', asin);
    var y = asin / Math.PI * 2;
    console.log('y', y);
    return y;
}

function okes() {
    var data = {
        x : [],
        y : []
    };
    for (var i = 0; i <= 1; i = i + 0.1) {
        data.x.push(i);
        data.y.push(oki(i * Math.PI) + i);
    }
    return data;
}

function dokes(input) {
    var data = {
        x : [],
        y : []
    };
    for (var i = 0; i < input.y.length; i++) {
        data.x.push(doki(input.y[i]));
        data.y.push(input.x[i]);
    }
    console.log('data', data);
    return data;
}