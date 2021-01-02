function getPlayer(strategy) {
    const player = {
        balance: 10000,
        strategy: strategy,
        bet: 0,
        stats: {
            n: 0,
            rate: 0,
            losingStreak: 0,
            winningStreak: 0,
            maxBalance: 0,
            minBalance: undefined,
            maxDip: 0,
            maxDipPerc: 0,
            balance: 0,
            startingBalance: 10000,
            maxStreak: 0,
            maxStreakAt: 0,
            targetAttempts: 0,
            maxTargetAttempts: 0,
            boomed: 0,
            busted: 0,
            won: false,                      // the last outcome of the game was successful
            lastBet: 0
        },
        target: 0
    };
    player.guess = function() {
        return (Math.round(Math.random() * 10) % 2 === 1);
    };
    player.play = function(win) {
        if (win) {
            this.strategy.win(this);
        } else {
            this.strategy.lose(this);
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
