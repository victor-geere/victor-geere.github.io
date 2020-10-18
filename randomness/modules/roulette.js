let game = null;

function setGame() {
    game = {
        n: 0,
        width: 600,
        startingBalance: 100000,
        player1: null,
        player2: null,
        reaped: 0,
        maxTrain: 11,
        reapAt: 10,
        ticks: 0,
        risk: 0.01,
        maxBalance: 0,
        saving: 0.01,
        targetAim: 2,
        stopped: false,
        plot: [{ x: 0, y: 200000 }],
        lastResult: null,
        streak: 0,
        maxStreak: 0
    };
    game.player1 = getPlayer({balance: game.startingBalance});
    game.player2 = getPlayer({balance: game.startingBalance});
    game.reset = function () {
        this.player1.balance = this.startingBalance;
        this.player2.balance = this.startingBalance;
        this.reaped = 0;
        this.ticks = 0;
        this.maxBalance = 0;
        this.player1.reset();
        this.player2.reset();
    };
    game.totalBalance = function () {
        return this.player1.balance + this.player2.balance;
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
    game.checkTrain = function() {
        if (this.player1.train.length >= this.maxTrain) {
            console.log(this.player1.train);
            this.split(this.totalBalance());
        } else if (this.player2.train.length >= this.maxTrain) {
            console.log(this.player2.train);
            this.split(this.totalBalance());
        }
        game.pushPlot();
    };
    game.consolidate = function () {
        /*
        if (this.reaped > this.startingBalance) {
            this.split(this.totalBalance() + (this.reaped / 2));
            this.startingBalance = this.totalBalance() / 2;
            this.reaped = this.reaped / 2;
        }
        if (this.totalBalance() < (this.startingBalance * 1.6)) {
            if (this.reaped >= (this.startingBalance * 2.8)) {
                this.player1.balance += (this.startingBalance * 0.2);
                this.player2.balance += (this.startingBalance * 0.2);
                this.reaped -= (this.startingBalance * 0.4);
            } else {
                this.startingBalance = Math.round(this.totalBalance() / 2);
            }
        }
        const perc = (1 + (this.reapAt / 100));
        const threshold = 2 * this.startingBalance * perc;
        if (this.totalBalance() > threshold) {
            const surplus = this.totalBalance() - this.startingBalance * 2;
            this.reaped += surplus;
            const total = this.totalBalance() - surplus;
            this.split(total);
        }

         */
        if (this.player1.balance < 50000) {
            this.player1.balance = 100000;
            console.log(`reset`);
        }
        if (this.player2.balance < 50000) {
            this.player2.balance = 100000;
            console.log(`reset`);
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
    MaxStreak : ${game.maxStreak} 
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

function getPlayer(options) {
    const player = {
        gameN: 0,
        maxbalance: 0,
        minbalance: 100000,
        balance: 100000,
        target: 100,
        tran: 50,
        trade: 0,
        train: [],
        plot: [],
        ...options
    };
    player.setTarget = function () {
        this.target = game.startingBalance * game.risk;
    };
    player.setTran = function () {
        if (this.train.length === 0 || this.trade > 0) {
            this.tran = this.target;
        } else {
            this.tran = Math.ceil((this.target - this.trade) / game.targetAim);
            this.tran = this.tran < 5 ? 10 : this.tran;
        }
        // if (this.balance < this.tran / 2) {
        //     this.tran = 0;
        // }
        if (this.tran > this.balance) {
            this.tran = this.balance;
        }
    };
    player.reset = function () {
        this.setTarget();
        this.trade = 0;
        this.train = [];
        this.setTran();
    };
    player.win = function () {
        game.reaped += this.tran * game.saving;
        this.balance += this.tran * (1 - game.saving);
        if (this.balance > this.maxbalance) {
            this.maxbalance = this.balance;
        }
        this.trade += this.tran * (1 - game.saving);
        if (this.trade >= this.target) {
            this.reset();
        } else {
            this.setTran();
        }
        this.pushPlot();
        this.train = [];
        // this.train.push({bal: this.balance, tran: this.tran, trade: this.trade});
    };
    player.lose = function () {
        this.balance -= this.tran;
        this.trade -= this.tran;
        this.setTran();
        if (this.balance < this.minbalance) {
            this.minbalance = this.balance;
        }
        this.pushPlot();
        this.train.push({bal: this.balance, tran: this.tran, trade: this.trade});
    };
    player.isLiquid = function () {
        return this.balance > this.tran;
    };
    player.checkSanity = function () {
        let sane = true;
        if (this.balance < 0) {
            console.log(`balance : ${this.balance}`);
            sane = false;
        }
        return sane;
    };
    player.pushPlot = function () {
        this.gameN++;
        this.plot.push({
            x: this.gameN,
            y: this.balance
        });
        if (this.plot.length > game.width) {
            this.plot.splice(0, 1);
        }
    };
    player.plot.push({x: 0, y: 100000});
    return player;
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
        if ((game.totalBalance() + game.reaped) > game.maxBalance) {
            game.maxBalance = game.totalBalance() + game.reaped;
        }
        game.checkTrain();
        setText();
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
