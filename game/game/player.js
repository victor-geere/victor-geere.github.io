function getPlayer(strategy) {
    const player = {
        balance: 0,
        strategy: strategy,
        bet: 0,
        stats: {
            losingStreak: 0,
            winningStreak: 0,
            maxBalance: 0,
            minBalance: undefined,
            maxDip: 0,
            balance: 0,
            startingBalance: 0,
            maxStreak: 0,
        },
        target: 0
    };
    player.guess = function() {
        return (Math.round(Math.random() * 10) % 2 === 1);
    };
    player.updateStats = function(win) {
        this.stats.balance = this.balance;
        if (win) {
            this.stats.losingStreak = 0;
            this.stats.winningStreak++;
        } else {
            this.stats.losingStreak++;
            this.stats.winningStreak = 0;
        }
        if (this.balance > this.stats.maxBalance) {
            this.stats.maxBalance = this.balance;
        }
        if (this.balance < this.stats.minBalance) {
            this.stats.minBalance = this.balance;
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
        this.balance -= bet;
        this.bet = bet;
    };

    player.clearBet = function() {
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
        this.target = amount;
    };

    player.getStats = function() {
        return this.stats;
    };

    return player;
}

export { getPlayer }
