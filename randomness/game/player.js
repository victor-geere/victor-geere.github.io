function getPlayer(options, game) {
    const player = {
        game: game,
        gameN: 0,
        maxbalance: 0,
        minbalance: 100000,
        balance: 100000,
        target: 100,
        tran: 50,
        trade: 0,
        train: [],
        plot: [],
        winningStreak: 0,
        losingStreak: 0,
        maxStreak: 0,
        maxLosingStreak: 0,
        ...options
    };
    player.setTarget = function () {
        this.target = Math.round(((this.game.totalBalance() + this.game.startingBalance) / 2) * this.game.risk);
    };
    player.setTran = function () {
        if (this.train.length === 0 || this.trade > 0) {
            this.tran = this.target;
        } else {
            this.tran = Math.ceil((this.target - this.trade) / this.game.targetAim);
            this.tran = this.tran < 5 ? 10 : this.tran;
        }
        if (this.tran > (this.balance - 9000) / 2) {
            this.tran = (this.balance - 9000) / 2;
        }
    };
    player.setMaxTran = function() {
        this.tran = this.target * Math.pow(1.2, this.winningStreak);
        if (this.tran > (this.balance - 9000) / 2) {
            this.tran = (this.balance - 9000) / 2;
        }
    };
    player.reset = function () {
        this.trade = 0;
        this.train = [];
    };
    player.win = function () {
        this.winningStreak++;
        this.losingStreak = 0;
        if (this.winningStreak > this.maxStreak) {
            this.maxStreak = this.winningStreak;
        }
        this.game.reaped += this.tran * this.game.saving;
        this.balance += this.tran * (1 - this.game.saving);
        if (this.balance > this.maxbalance) {
            this.maxbalance = this.balance;
        }
        this.trade += this.tran * (1 - this.game.saving);
        this.game.backLog -= this.tran;
        if (this.game.backLog < 0) {
            this.game.backLog = 0;
        }
        if (this.trade >= this.target) {
            this.reset();
        }
        this.pushPlot();
    };
    player.lose = function () {
        this.winningStreak = 0;
        this.losingStreak++;
        if (this.losingStreak > this.maxLosingStreak) {
            this.maxLosingStreak = this.losingStreak;
        }
        this.balance -= this.tran;
        this.trade -= this.tran;
        this.game.backLog += this.tran;
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
        if (this.plot.length > this.game.width) {
            this.plot.splice(0, 1);
        }
    };
    player.plot.push({x: 0, y: 100000});
    return player;
}

export { getPlayer }
