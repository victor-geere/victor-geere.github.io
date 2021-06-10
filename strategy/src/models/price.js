import { roundTo, config } from './utils.js';

const prices = {
    eur: 15,
    gbp: 20,
    usd: 20
};

const Samples = {};

Samples.utils = {
    _seed: Date.now(),

    // Adapted from http://indiegamr.com/generate-repeatable-random-numbers-in-js/
    setSeed: function (seed) {
        this._seed = seed;
    },

    rand: function (min, max) {
        let seed = this._seed;
        min = min === undefined ? -1 : min;
        max = max === undefined ? 1 : max;
        this._seed = (seed * 9301 + 49297) % 233280;
        return min + (this._seed / 233280) * (max - min);
    },
};

function randomScalingFactor(ticker, log = false) {
    let x = Samples.utils.rand(config.random[ticker].min, config.random[ticker].max);
    if (x === 0) {
        x = 0.0001;
    }
    if (log) {
        const sign = x < 0 ? -1 : 1;
        x = Math.log(Math.abs(x)) * sign;
    }
    return x;
}

function getSpotPrice(ticker) {
    if (!ticker) {
        throw Error('no ticker specified in getSpotPrice(ticker)');
    }
    const usd = prices['usd'];
    const x = prices[ticker];
    return roundTo(x / usd, 6);
}

function makePrice(oldPrice, change) {
    const sm1 = config.smoothing;
    const sm0 = sm1 - 1;
    return ((oldPrice * sm0) + (oldPrice + change)) / sm1;
}

function setSpotPrice(ticker) {
    const change = randomScalingFactor(ticker);
    prices[ticker] = makePrice(prices[ticker], change);
    return getAbsPrice(ticker);
}

function getAbsPrice(ticker) {
    return prices[ticker];
}

function setAbsPrice(ticker, price) {
    prices[ticker] = price;
}

function testPrices() {
    for (let i = 0; i < 1000; i++) {
        const rand1 = randomScalingFactor('usd');
        const rand2 = randomScalingFactor('eur');
        const absUsd = setSpotPrice('usd', rand1);
        const absEur = setSpotPrice('eur', rand2);
        log(`${absEur} / ${absUsd} : ${getSpotPrice('eur')}`);
    }
}

export { testPrices, getSpotPrice, setSpotPrice, getAbsPrice, setAbsPrice }
