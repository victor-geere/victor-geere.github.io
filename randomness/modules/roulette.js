const player1 = getPlayer();
const player2 = getPlayer();

const game = {
    n: 0,
    width: 600
};

function get(id) {
    return document.getElementById(id);
}

function setText(id, text) {
    const element = get(id);
    if (!element) {
        console.log(`no element : ${id}`);
    } else {
        element.innerText = text;
    }
}

function getSuccess() {
    return Math.random() > 0.5;
}

function getPlayer(risk = 0.01) {
    const player = {
        maxbalance : 0,
        minbalance : 100000,
        balance : 100000,
        risk : risk,
        target : 100,
        tran : 50,
        trade : 0,
        train : [],
        plot : []
    };
    player.setTarget = function() {
        this.target = this.balance * this.risk;
        // console.log(`this.target : ${this.target}`);
    };
    player.reset = function() {
      this.trade = 0;
      this.tran = 50;
      this.train = [];
    };
    player.win = function(targetAim = 2) {
        this.train.push({ bal: this.balance, tran: this.tran, trade: this.trade});
        this.balance += this.tran;
        if (this.balance > this.maxbalance) {
            this.maxbalance = this.balance;
        }
        this.trade += this.tran;

        if (this.trade >= this.target) {
            // console.log(this.train);
            this.reset();
            this.setTarget();
        } else {
            this.tran = Math.ceil((this.target - this.trade) / targetAim);
            this.tran = this.tran < 5 ? 10 : this.tran;
        }
    };
    player.lose = function(targetAim = 2) {
        this.train.push({ bal: this.balance, tran: this.tran, trade: this.trade});
        this.balance -= this.tran;
        this.trade -= this.tran;
        this.tran = Math.ceil((this.target - this.trade) / targetAim);
        this.tran = this.tran < 5 ? 10 : this.tran;
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

function consolidate(p1, p2) {
    if (p1.train.length > 6 || p2.train.length > 6) {
        const total = p1.balance + p2.balance;
        p1.balance = total / 2;
        p2.balance = total / 2;
        p1.reset();
        p2.reset();
    }
}

function setRisk(risk) {
    player1.risk = risk;
    player2.risk = risk;
}

function play(targetAim = 2, risk = 0.01) {
    game.n++;
    if (getSuccess()) {
        player1.win(targetAim);
        player2.lose(targetAim);
    } else {
        player2.win(targetAim);
        player1.lose(targetAim);
    }
    consolidate(player1, player2);
    player1.plot.push({
        x: game.n,
        y: player1.balance
    });
    player2.plot.push({
        x: game.n,
        y: player2.balance
    });
    if (player1.plot.length > game.width) {
        player1.plot.splice(0,1);
    }
    if (player2.plot.length > game.width) {
        player2.plot.splice(0,1);
    }
    // console.log(`player1.balance : ${player1.balance} ${player1.tran} ${player1.trade}`);
    return {
        player1 : player1.plot,
        player2 : player2.plot
    };
}

function loop(targetAim = 2, risk = 0.01) {
    while (player1.isLiquid() && player2.isLiquid() && game.n < game.width) {
        play(targetAim, risk);
    }
    // console.log(player1);
    // console.log(player2);
    // console.log(`balance : ${player1.balance + player2.balance - 200000}`);
    return {
        player1 : player1.plot,
        player2 : player2.plot
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

function start(targetAim = 2, risk = 0.01) {
    return loop(targetAim, risk);
}

export { start, play, setRisk }
