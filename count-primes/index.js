var numberN = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
var ix = 0;

var collection = {};
var primeCollection = {};

var uniquePrimes = [];

var primeCache = {};

function addToCollection(n) {
    if (!collection[n]) {
        collection[n] = 0;
    }
    collection[n] = collection[n] + 1;
}

function addToPrimeCollection(n, isPrime) {
    if (!primeCollection[n]) {
        primeCollection[n] = 0;
    }

    if (isPrime && !uniquePrimes.includes(n)) {
        uniquePrimes.push(n);
    }

    primeCollection[n] = primeCollection[n] + (isPrime ? 1 : 0);
}

function increment(n) {
    if (numberN[n] === 1) {
        numberN[n] = 0;
        if (n < numberN.length - 1) {
            increment(n + 1);
        }
    } else {
        numberN[n] = numberN[n] + 1;
    }
}

function calc() {
    var obj = {n: 0, binary: 0};
    for (var i = 0; i < numberN.length; i++) {
        obj.n = obj.n + (numberN[i]) * (i + 1)
        obj.binary = obj.binary + numberN[i] * Math.pow(2, i);
    }
    return obj;
}

function calcN() {
    var n = 0;
    for (var i = 0; i < numberN.length; i++) {
        n = n + (numberN[i]) * (i + 1)
    }
    return n;
}

function calcBinary() {
    var n = 0;
    for (var i = 0; i < numberN.length; i++) {
        n = n + numberN[i] * Math.pow(2, i);
    }
    return n;
}

function logNumber(ix, n, isPrime, primes) {
    // var pT = isPrime ? '*' : '';
    // console.log(`${ix} numberN : ${numberN} ${n} ${pT} primes: ${primes}`);
}

function makeTrace(series) {
    return {
        x: series.x,
        y: series.y,
        type: 'scatter'
    };
}

function parseCollection() {
    var series = { x : [], y : [] };
    var unique = Math.pow(numberN.length, 2)/2;
    for (var i = 0; i <= unique; i++) {
        series.x.push(i);
        series.y.push(collection[i]);
    }
    return series;
}

function parsePrimeCollection() {
    var series = { x : [], y : [] };
    var unique = Math.pow(numberN.length, 2)/2;

    var primes = 0;

    for (var i = 0; i <= unique; i++) {
        series.x.push(i);
        primes = primes + (primeCollection[i] > 0 ? 1 : 0);
        series.y.push(primes * 200);
    }
    return series;
}

function simpleSeries() {
    numberN.push(0);
    ix = 0;

    collection = {};
    primeCollection = {};

    uniquePrimes = [];

    var obj;

    for (var i = 0; i <= Math.pow(2, numberN.length) - 1; i++) {
        obj = calc();

        // addToCollection(n);
        addToPrimeCollection(obj.n, isPrime(obj.n));
        increment(0);
    }
    console.log(`digits ${numberN.length} binary ${Math.pow(2, numberN.length)}`);
    console.log(`${uniquePrimes.length} : ${numberN.length}`);
    return uniquePrimes.length / numberN.length;
}

function getSeries() {
    var series0 =  { x : [], y : [] };
    var series1 =  { x : [], y : [] };
    var series2 =  { x : [], y : [] };

    var series5 =  { x : [], y : [] };
    var series6 =  { x : [], y : [] };

    var primes = 0;
    var n = 0;
    var isP = false;
    var binary = 0;

    for (var i = 0; i <= Math.pow(2, numberN.length) - 1; i++) {
        n = calcN();
        isP = isPrime(n);
        primes += isP ? 1 : 0;
        binary = calcBinary();

        addToCollection(n);
        addToPrimeCollection(n, isP);

        // binary / n = (2 x log^2(2))/(log(x) log(2 x))

        logNumber(i, n, isP, primes);

        series0.x.push(i);
        series0.y.push(n);

        series1.x.push(i);
        series1.y.push(primes*5);

        series2.x.push(i);
        series2.y.push(binary);

        increment(0);
    }

    console.log('digits ', numberN.length);
    console.log(uniquePrimes.length / (Math.pow(numberN.length, 2)/2));
    console.log(`${uniquePrimes.length} : ${(Math.pow((numberN.length + 1), 2)/2)}`);
    console.log('binary : ', Math.pow(2, numberN.length));

    console.log(uniquePrimes);

    var px = 0;

    for (var m = 0; m < (Math.pow(numberN.length, 2)/2); m++) {
        series5.x.push(m);
        series5.y.push(m / Math.log(m)); //pi function

        px += isPrime(m) ? 1 : 0;
        series6.x.push(m);
        series6.y.push(px);
    }

    var series3 = parseCollection();
    var series4 = parsePrimeCollection();

    //manual count of primes vs pi function
    //return [makeTrace(series6), makeTrace(series5)];

    //count of primes vs count of sums (2+3+4+5+6...)
    //return [makeTrace(series3), makeTrace(series4)];

    //count of primes (scaled by 5) vs binary number (2^n)
    return [makeTrace(series1), makeTrace(series2)];
}

function printNumber() {
    var n = calcN();
    var isP = isPrime(n);
    var pN = isP ? '1' : '0';
    var pT = isP ? '*' : '';
    console.log(`${ix++} numberN : ${numberN} ${n} ${pT}`);
    // document.write(`${n},${pN}<br>`);
}

function start() {
    printNumber();
    for (var i = 0; i <= Math.pow(2, numberN.length); i++) {
        increment(0);
        printNumber();
    }
}

function isPrime(n) {
    if (primeCache[n] !== undefined) {
        return primeCache[n];
    }

    var x = Math.sqrt(n);
    if (n==0 || n==1) {
        return false;
    }
    for (var i = 2; i <= x; i++) {
        if (n % i == 0) {
            primeCache[n] = false;
            return false;
        }
    }
    primeCache[n] = true;
    return true;
}

//start();