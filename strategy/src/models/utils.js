const config = {
    prod: true,
    graphAnimation: {
        delay: 900,
        easing: 'linear'
    },
    delay: 900,
    smoothing: 12,
    leverage: 15,
    feeRate: 0.01,
    startingBalance: 100000,
    random: {
        eur: {
            min: -0.7,
            max: 0.7
        },
        gbp: {
            min: -0.3,
            max: 0.3
        },
        usd: {
            min: -0.5,
            max: 0.5
        }
    }
};

function get(id) {
    return document.getElementById(id);
}

function log(title, msg= '') {
    if (!config.prod) {
        if (!msg) {
            console.log(title);
        } else {
            console.log(`${title}`, msg);
        }
    }
}

function roundTo(n, radix) {
    const factor = Math.pow(10, radix);
    const number = Math.round(n * factor) / factor;
    return number.toLocaleString(undefined, {minimumFractionDigits: radix, maximumFractionDigits: radix});
}

export { log, get, roundTo, config }
