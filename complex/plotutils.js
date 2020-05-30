function repeatXFx(limit, increment, fnx) {
    var data = {
        x : [],
        y : [],
        // mode: 'markers',
        type: 'scatter'
    };
    var k = 0;
    //var sqrtLimit = math.sqrt(limit)*2;
    for (var n = 1; n <= limit; n = n + increment) {
        var fx = fnx(n, k++, limit);
        data.x.push(n);
        data.y.push(fx);
    }
    return [data];
}

function repeatReIm(limit, increment, fnx, fny) {
    var data = {
        x : [],
        y : []
    };
    var k = 0;
    for (var n = 0; n <= limit; n = n + increment) {
        var fx = fnx(n, k, limit);
        data.x.push(fx.re);
        data.y.push(fx.im);
        k++;
    }
    return [data];
}

function repeatReImN(maxX, limit, increment, fnx, fny) {
    var data = {
        x : [],
        y : []
    };
    var k = 0;
    for (var n = 0; n <= maxX; n = n + increment) {
        var fx = fnx(n, k, limit);
        data.x.push(fx.re);
        data.y.push(fx.im);
        k++;
    }
    return [data];
}

/**
 *
 * @param rangemode: 'tozero'
 * @param mode: 'lines', 'markers', 'lines+markers'
 * @param showline: true
 * @param zeroline: true
 * @returns {{yaxis: {zeroline: boolean, showline: boolean, rangemode: string}}}
 */
function getLayout(rangemode='tozero', mode='markers', showline=true, zeroline=true) {
    return {
        yaxis: {
            rangemode: rangemode,
            mode: mode,
            showline: showline,
            zeroline: zeroline
        }
    };
}

function animate(limit, increment, repeater, fx, layout) {
    Plotly.animate('div1', {
        data: repeater(limit, increment, fx),
        traces: [0],
        layout: layout
    }, {
        transition: {
            duration: 500,
            easing: 'linear'
            // easing: 'cubic-in-out'
        },
        frame: {
            duration: 500
        }
    })
}

function animateData(data, layout) {
    Plotly.animate('div1', {
        data: data,
        traces: [0],
        layout: layout
    }, {
        transition: {
            duration: 500,
            easing: 'linear'
            // easing: 'cubic-in-out'
        },
        frame: {
            duration: 500
        }
    })
}

function unitCircle2SineX(n, k, param) {
    var x = math.evaluate(`((e^(${n}i*pi) - e^(-${n}i*pi))/2i)^2`);
    var x1 = math.complex(n, x.re);
    return x1;
    // return math.multiply(math.evaluate(`e^(-i * pi * 0.5)`), x1);
    // return math.evaluate(`pi * ${n} + e^(${n}/pi * i)`);
}

function unitCircle2SineY(n, k, param) {
    var x = math.evaluate(`-((e^(${param}i*pi/${n}) - e^(-${param}i*pi/${n}))/2i)^2`);
    return math.complex(n, x.re);
    // return math.evaluate(`pi * ${n} + e^(${n}/pi * i)`);
}

function fxLine(n, k, param) {
    var x1 = math.evaluate(`((e^(${n}i*pi) - e^(-${n}i*pi))/2i)^2`).re;
    var x2 = math.evaluate(`((e^(${param}i*pi/${n}) - e^(-${param}i*pi/${n}))/2i)^2`).re;
    return math.complex(n, x1 + x2);
    return x3;
}

function fxLine2(n, k, p) {
    var x1 = math.evaluate(`(-e^(-(2i * pi * ${p})/${n}) - e^((2i * pi * ${p})/${n}) - e^(-2i * pi * ${n}) - e^(2i * pi * ${n}) + 4)^0.001`);
    // console.log(`${x1.re} + ${x1.im}i`);
    return math.complex(n, x1.re);
}
