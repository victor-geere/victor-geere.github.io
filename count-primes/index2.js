var numberN = [0,0,0,0,0,0];
var ix = 0;

function increment(n) {
    if (numberN[n] == n + 1) {
        numberN[n] = 0;
        if (n < numberN.length + 1) {
            increment(n + 1);
        }
    } else {
        numberN[n] = numberN[n] + 1;
    }
}

function calcN() {
    var n = 0;
    for (var i = 0; i < numberN.length; i++) {
        n = n + (numberN[i] + 0) * (i + 1)
    }
    return n;
}

function printNumber() {
    var n = calcN();
    var isP = isPrime(n);
    var pN = isP ? '1' : '0';
    var pT = isP ? '*' : '';
    console.log(`${ix++} numberN : ${numberN} ${n} ${pT}`);
    document.write(`${n},${pN}<br>`);
}

function start() {
    for (var i = 0; i < 2*3*4*5*6*7 -1; i++) {
        increment(0);
        printNumber();
    }
}

function isPrime(n) {
    var x = Math.sqrt(n);
    for (var i = 2; i <= x; i++) {
        if (n % i === 0) {
            return false;
        }
    }
    return true;
}

start();