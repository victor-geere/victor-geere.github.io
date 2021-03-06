function getPlayer(strategy) {
    const startingBalance = 500000;
    const player = {
        balance: startingBalance,
        strategy: strategy,
        bet: 0,
        stats: {
            n: 0,
            maxDeviation: 0,
            rate: 0,
            losingStreak: 0,
            winningStreak: 0,
            maxBalance: 0,
            minBalance: undefined,
            maxDip: 0,
            maxDipPerc: 0,
            balance: 0,
            startingBalance: startingBalance,
            maxStreak: 0,
            maxStreakAt: 0,
            targetAttempts: 0,
            maxTargetAttempts: 0,
            boomed: 0,
            busted: 0,
            won: false,                      // the last outcome of the game was successful
            lastBet: 100,
            wins: 0,
            losses: 0,
            maxDrift: 0,
            startingBet: 100,
            betFactor: 1
        },
        target: 0
    };
    player.guess = function() {
        return (Math.round(Math.random() * 10) % 2 === 1);
    };
    player.updateStats = function(win) {
        this.stats.n++;
        this.stats.maxDeviation = math.round(math.sqrt(this.stats.n) * 1000) / 1000;
        this.stats.won = win;
        const rounding = 1000;
        this.stats.rate = Math.round(((this.balance - this.stats.startingBalance) * 100 * rounding / this.stats.startingBalance) / this.stats.n) / rounding;
        this.stats.balance = this.balance;
        if (win) {
            this.stats.losingStreak = 0;
            this.stats.winningStreak++;
        } else {
            this.stats.losingStreak++;
            this.stats.winningStreak = 0;
        }
        this.stats.maxBalance = (this.balance > this.stats.maxBalance) ? this.balance : this.stats.maxBalance;
        this.stats.minBalance = (this.balance < this.stats.minBalance || this.stats.minBalance === undefined) ? this.balance : this.stats.minBalance;
        if (this.stats.losingStreak > this.stats.maxStreak) {
            this.stats.maxStreak = this.stats.losingStreak;
            this.stats.maxStreakAt = this.stats.n;
        }
        if (this.stats.winningStreak > this.stats.maxStreak) {
            this.stats.maxStreak = this.stats.winningStreak;
            this.stats.maxStreakAt = this.stats.n;
        }
        if (this.stats.maxBalance - this.stats.balance > this.stats.maxDip) {
            this.stats.maxDip = (this.stats.maxBalance - this.stats.balance);
        }
        const dipPercentage = Math.round(((this.stats.maxBalance - this.stats.balance) / this.stats.maxBalance) * 1000) / 10;
        if (dipPercentage > this.stats.maxDipPerc) {
            this.stats.maxDipPerc = dipPercentage;
        }
        if (dipPercentage > 100) {
            console.log(this.strategy.getLog());
        }
    };
    player.play = function(win) {
        if (win) {
            this.strategy.win(this);
            this.updateStats(true);
        } else {
            this.strategy.lose(this);
            this.updateStats(false);
        }
    };

    player.addBalance = function(amount) {
        this.balance += amount;
    };

    player.subtractBalance = function(amount) {
        this.balance -= amount;
    };

    player.getBalance = function() {
        return this.balance;
    };

    player.setBalance = function(balance) {
        this.balance = balance;
    };

    player.placeBet = function(bet) {
        this.stats.targetAttempts++;
        this.balance -= bet;
        this.bet = bet;
    };

    player.clearBet = function() {
        this.stats.lastBet = this.bet;
        this.bet = 0;
    };

    player.getBet = function() {
        return this.bet;
    };

    player.turn = function() {
        return this.strategy.turn(this);
    };

    player.getTarget = function() {
        return this.target;
    };

    player.setTarget = function(amount) {
        if (this.stats.targetAttempts > this.stats.maxTargetAttempts) {
            this.stats.maxTargetAttempts = this.stats.targetAttempts;
            this.stats.targetAttempts = 0;
        }
        this.target = amount;
    };

    player.getStats = function() {
        return this.stats;
    };

    return player;
}

export { getPlayer }
