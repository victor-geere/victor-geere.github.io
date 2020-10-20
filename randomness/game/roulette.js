import { getPlayer } from "./player.js";

let game = null;

let gameOptions = {
    n: 0,
    width: 600,
    startingBalance: 100000,
    player1: null,
    player2: null,
    reaped: 0,
    maxTrain: 30,
    reapAt: 10,
    ticks: 0,
    risk: 0.01,
    maxBalance: 0,
    saving: 0.0,
    targetAim: 2,
    stopped: false,
    plot: [{ x: 0, y: 200000 }],
    lastResult: null,
    streak: 0,
    maxStreak: 0,
    maxPoint: 0,
    maxDip: 0,
    backLog: 0
};

function setGame() {
    game = { ...gameOptions };
    game.player1 = getPlayer({balance: game.startingBalance}, game);
    game.player2 = getPlayer({balance: game.startingBalance}, game);
    game.reset = function () {
        Object.keys(gameOptions).forEach((optionKey) => {
            this[optionKey] = gameOptions[optionKey];
        });
        this.plot = [{ x: 0, y: 200000 }];
        this.player1 = getPlayer({balance: game.startingBalance}, this);
        this.player2 = getPlayer({balance: game.startingBalance}, this);
    };
    game.totalBalance = function () {
        return this.player1.balance + this.player2.balance;
    };
    game.equity = function () {
        return this.player1.balance + this.player2.balance + this.reaped;
    };
    game.split = function (amount) {
        this.player1.balance = amount / 2;
        this.player2.balance = amount / 2;
        this.player1.reset();
        this.player2.reset();
    };
    game.pushPlot = function() {
        this.plot.push({ x: this.n, y: (this.totalBalance() + this.reaped) });
        if (this.plot.length > this.width) {
            this.plot.splice(0, 1);
        }
    };
    game.setup = function() {
        const maxDiff = this.totalBalance() / 500;
        this.backLog = this.backLog < 0 ? 0 : this.backLog;
        let maxPlayer, minPlayer;
        let difference = 0;
        let playerDifference = 0;
        if (this.player1.train.length >= this.maxTrain) {
            console.log(this.player1.train);
            this.split(this.totalBalance());
        } else if (this.player2.train.length >= this.maxTrain) {
            console.log(this.player2.train);
            this.split(this.totalBalance());
        }
        if (this.player1.balance === this.player2.balance) {
            this.player2.setTarget();
            this.player1.setTarget();
            this.player1.setTran();
            this.player2.setTran();
            this.player1.tran += maxDiff;
        } else {
            if (this.player1.balance > this.player2.balance) {
                maxPlayer = this.player1;
                minPlayer = this.player2;
            } else {
                minPlayer = this.player1;
                maxPlayer = this.player2;
            }
            playerDifference = Math.abs(this.player1.balance - this.player2.balance);
            if (playerDifference > maxDiff) {
                const totBal = this.totalBalance();
                this.player1.balance = totBal / 2 + maxDiff;
                this.player2.balance = totBal / 2;
            }
            difference = 2.5 * Math.abs(this.player1.balance - this.player2.balance) - (this.backLog / 5);
            const diffSplit = Math.round(difference / 2) * (this.totalBalance() / (this.startingBalance * 2));
            maxPlayer.tran = diffSplit;
            minPlayer.tran = diffSplit * 2;
            // maxPlayer.tran += this.backLog / 4;
            // minPlayer.tran += this.backLog / 12;
            maxPlayer.tran = maxPlayer.tran * Math.pow(1.1, maxPlayer.winningStreak);
            minPlayer.tran = minPlayer.tran * Math.pow(1.1, minPlayer.winningStreak);
        }
        const diff = Math.abs(this.player1.tran - this.player2.tran);
        if (this.player1.tran > this.player2.tran) {
            this.player1.tran = diff;
            this.player2.tran = 0;
        } else {
            this.player2.tran = diff;
            this.player1.tran = 0;
        }
        const max = this.totalBalance() / 50;
        if (this.player1.tran > max) {
            this.player1.tran = max;
        }
        if (this.player2.tran > max) {
            this.player2.tran = max;
        }
        /*
        if (this.player1.tran > this.player1.balance) {
            this.player1.tran = this.player1.balance / 2;
        }
        if (this.player2.tran > this.player2.balance) {
            this.player2.tran = this.player2.balance / 2;
        }

         */
        game.pushPlot();
    };
    game.consolidate = function () {
        if (this.player1.balance < 10000) {
            console.log(`reset at ${game.ticks}`, game.player1.train);
            game.reset();
        }
        if (this.player2.balance < 10000) {
            console.log(`reset at ${game.ticks}`, game.player2.train);
            game.reset();
        }
        if (this.player1.balance < (this.player2.balance / 4) || this.player2.balance < (this.player1.balance / 4)) {
            const amount = this.totalBalance();
            this.player1.balance = amount / 2;
            this.player2.balance = amount / 2;
        }
    }
}

function setText() {
    const text = `
    # : ${game.n} <br>
    StartingBalance : ${Math.round(game.startingBalance * 2)} <br>
    Balance : ${Math.round(game.totalBalance())} <br>
    Banked  : ${Math.round(game.reaped)} <br>
    Max     : ${Math.round(game.maxBalance)} <br>
    MaxStreak : ${game.maxStreak} <br>
    Max Point : ${game.maxPoint} <br>
    Max Draw Down : ${game.maxDip} <br>
    Back Log : ${Math.round(game.backLog)}
    `;
    get('floatingText').innerHTML = text;
}

function get(id) {
    return document.getElementById(id);
}

function getSuccess() {
    const result = Math.random() > 0.5; // (0.5 * (1 + 1/37));
    if (result === game.lastResult) {
        game.streak++;
        if (game.streak > game.maxStreak) {
            game.maxStreak = game.streak;
        }
    } else {
        game.streak = 0;
        game.lastResult = result;
    }
    return result;
}

function setTrain(train) {
    game.maxTrain = train;
}

function setRisk(risk) {
    game.risk = risk;
}

function play() {
    if (!game.stopped) {
        game.ticks++;
        game.n++;
        const result = getSuccess();
        game.consolidate();
        if (result) {
            game.player1.win();
            game.player2.lose();
        } else {
            game.player2.win();
            game.player1.lose();
        }
        if (game.equity() > game.maxBalance) {
            game.maxBalance = game.equity();
            game.maxPoint = game.ticks;
        }
        if (game.equity() - game.maxBalance < game.maxDip) {
            game.maxDip = game.equity() - game.maxBalance;
        }
        setText();
        game.setup();
    }
}

function testSuccess() {
    let a = 0;
    let b = 0;
    for (let i = 0; i < 1000000; i++) {
        if (getSuccess()) {
            a++;
        } else {
            b++;
        }
    }
    return `a : ${a} b : ${b}`;
}

function setReap(reapAt) {
    game.reapAt = reapAt;
}

function start() {
    setGame();
    play();
    return game;
}

function resetGame() {
    game.reset();
}

function getGame() {
    return game;
}

function setSaving(saving) {
    game.saving = saving;
}

function setTarget(target) {
    game.targetAim = target;
}

export {start, play, setRisk, setTrain, resetGame, setReap, getGame, setSaving, setTarget}
