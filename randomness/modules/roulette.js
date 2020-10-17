const game = setGame();

function setGame() {
    const gm = {
        n: 0,
        width: 600,
        startingBalance: 100000,
        player1 : getPlayer(),
        player2 : getPlayer(),
        reaped : 0,
        maxTrain: 2,
        reapAt: 10,
        ticks: 0,
        risk: 0.01,
        maxBalance: 0,
        saving: 0
    };
    gm.reset = function() {
        this.player1.balance = this.startingBalance;
        this.player2.balance = this.startingBalance;
        this.reaped = 0;
        this.ticks = 0;
        this.maxBalance = 0;
        this.player1.reset();
        this.player2.reset();
        prime();
    };
    gm.totalBalance = function() {
        return this.player1.balance + this.player2.balance;
    };
    return gm;
}

const formulas = [];
function setText(text) {
    if (formulas.length > 1) {
        formulas.splice(0, 1);
    }
    formulas.push(text);
    document.getElementById('floatingText').innerHTML = text;
}

function get(id) {
    return document.getElementById(id);
}

function getSuccess() {
    return Math.random() > 0.5;
}

function getPlayer() {
    const player = {
        maxbalance : 0,
        minbalance : 100000,
        balance : 100000,
        target : 100,
        tran : 50,
        trade : 0,
        train : [],
        plot : [],
        targetAim: 0
    };
    player.setTarget = function() {
        this.target = game.startingBalance * game.risk;
    };
    player.setTran = function() {
        if (this.train.length === 0) {
            this.tran = this.target;
        } else {
            this.tran = Math.ceil((this.target - this.trade) / this.targetAim);
            this.tran = this.tran < 5 ? 10 : this.tran;
        }
    };
    player.reset = function() {
      this.setTarget();
      this.trade = 0;
      this.setTran();
      this.train = [];
      // this.plot = [];
    };
    player.win = function() {
        this.train.push({ bal: this.balance, tran: this.tran, trade: this.trade});
        game.reaped += this.tran * game.saving;
        this.balance += this.tran * (1 - game.saving);
        if (this.balance > this.maxbalance) {
            this.maxbalance = this.balance;
        }
        this.trade += this.tran * (1 - game.saving);
        if (this.trade >= this.target) {
            // console.log(this.train);
            this.reset();
        } else {
            this.setTran();
        }
    };
    player.lose = function() {
        this.train.push({ bal: this.balance, tran: this.tran, trade: this.trade});
        this.balance -= this.tran;
        this.trade -= this.tran;
        this.setTran();
        if (this.balance < this.minbalance) {
            this.minbalance = this.balance;
        }
    };
    player.isLiquid = function() {
        return this.balance > this.tran;
    };
    player.checkSanity = function() {
        let sane = true;
        if (this.balance < 0) {
            console.log(`balance : ${this.balance}`);
            sane = false;
        }
        return sane;
    };
    return player;
}

let x = 1;
function consolidate() {
    const balance = game.totalBalance();
    const perc = (1 + (game.reapAt / 100));
    const threshold = 2 * game.startingBalance * perc;
    /*
    if (x++ % 1000 === 0) {
        x = 1;
        console.log({
            threshold: threshold,
            balance: balance,
            reapAt: game.reapAt,
            perc: perc
        });
    }
    */
    if (balance > threshold) {
        const surplus = balance - game.startingBalance * 2;
        // console.log(`reaped ${surplus}`);
        game.reaped += surplus;
        const total = game.player1.balance + game.player2.balance - surplus;
        game.player1.balance = total / 2;
        game.player2.balance = total / 2;
        game.player1.reset();
        game.player2.reset();
    }
    if (game.player1.train.length > game.maxTrain || game.player2.train.length > game.maxTrain) {
        const total = game.player1.balance + game.player2.balance;
        game.player1.balance = total / 2;
        game.player2.balance = total / 2;
        game.player1.reset();
        game.player2.reset();
    }
}

function setTrain(train) {
    game.maxTrain = train;
}

function setRisk(risk) {
    game.risk = risk;
}

function play() {
    game.ticks++;
    game.n++;
    if (getSuccess()) {
        game.player1.win();
        game.player2.lose();
    } else {
        game.player2.win();
        game.player1.lose();
    }
    if (game.totalBalance() > game.maxBalance) {
        game.maxBalance = game.totalBalance();
    }
    consolidate(game.player1, game.player2);
    game.player1.plot.push({
        x: game.n,
        y: game.player1.balance
    });
    game.player2.plot.push({
        x: game.n,
        y: game.player2.balance
    });
    if (game.player1.plot.length > game.width) {
        game.player1.plot.splice(0,1);
    }
    if (game.player2.plot.length > game.width) {
        game.player2.plot.splice(0,1);
    }
    setText(`${Math.round(game.player1.balance + game.player2.balance)} <br> ${game.reaped}`);
    // console.log(`player1.balance : ${player1.balance} ${player1.tran} ${player1.trade}`);
    return {
        player1 : game.player1.plot,
        player2 : game.player2.plot
    };
}

function prime() {
    while (game.player1.isLiquid() && game.player2.isLiquid() && game.n < game.width) {
        play();
    }
}

function loop(targetAim = 2, risk = 0.01) {
    game.player1.targetAim = targetAim;
    game.player2.targetAim = targetAim;
    prime();
    return {
        player1 : game.player1.plot,
        player2 : game.player2.plot
    };
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

function start(targetAim = 2, risk = 0.01) {
    return loop(targetAim, risk);
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

export { start, play, setRisk, setTrain, resetGame, setReap, getGame, setSaving }
