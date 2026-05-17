var wholeSet50 = [];
var wholeSet20 = [];
var resultset = [0,0,0,0,0];

function makeNumbers() {
    wholeSet50 = [];
    wholeSet20 = [];
    for (var i = 0; i < 50; i++) {
        if(i < 20) {
            wholeSet20.push(i+1);
        }
        wholeSet50.push(i+1);
    }
}

function getNum(max) {
    return Math.ceil(Math.random() * max);
}

function getNumbers() {
    var set = [];
    for (var i = 0; i < 5; i++) {
        var found = false;
        while(!found) {
            var n = getNum(50);
            if (!set.includes(n)) {
                found = true;
                set.push(n);
            }
        }
    }
    set.push(getNum(20));
    return set;
}

function evaluateResults(selection, result) {
    var subset = [selection[0], selection[1], selection[2], selection[3], selection[4]];
    var subRes = [result[0], result[1], result[2], result[3], result[4]];
    var n = 0;
    for(var i = 0; i < 5; i++) {
        if (subRes.includes(subset[i])) {
            n++;
        }
    }
    if (result[5] < 21 && n > 0) {
        resultset[n-1] = resultset[n-1] + 1;
        // console.log('resultset' + n, result);
    }
}

function run() {
    makeNumbers();
    console.log('wholeSet50', wholeSet50);
    console.log('wholeSet20', wholeSet20);
    var selection = [4, 20, 23, 32, 50, 1]; // getNumbers();
    console.log('selection', selection);
    for(var i = 0; i < (50*49*48*10); i++) {
        var result = getNumbers();
        evaluateResults(selection, result);
    }
    console.log('resultset', resultset);
}

function testGetNum() {
    var n = 0;
    var testSet = [0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0];
    for(var i = 0; i < 1000; i++) {
        n = getNum(20);
        testSet[n] = testSet[n] + 1;
    }
    console.log('testSet', testSet);
}

testGetNum();
run();
