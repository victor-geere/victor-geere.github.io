const strategy = {
    log: [],
    doLog: function(outcome, player) {
        const event = {
            bet: player.getBet(),
            outcome,
            offset: Math.ceil(player.getTarget() - player.getBalance()),
            balance: player.getBalance(),
            target: player.getTarget(),
            stats: player.getStats()
        };
        this.log.push(event);
        if (this.log.length > 200) {
            this.log.splice(0, 1);
        }
    },
    getLog: function() {
        return this.log;
    },
    setTarget: function(player) {
        // slow down risk as growth approaches 2x
        // let gain = (player.getBalance() - player.stats.startingBalance) / player.stats.startingBalance;
        // let growth = (1 - gain) / 10;
        // let risk = 1 + growth;
        let risk = 1.025;
        player.setTarget(player.getBalance() * risk);
    },
    guess: function() {
        return (Math.round(Math.random() * 10) % 2 === 1);
    },
    turn: function(player) {
        const balance = player.getBalance();
        const stats = player.getStats();
        const minBet = 1;
        const maxBet = balance;
        let bet = stats.lastBet;

        if (stats.won) {
            bet = bet -1;
        } else {
            bet = bet + 1;
        }

        if (bet < minBet) {
            bet = minBet;
        } else if (bet > maxBet) {
            bet = maxBet;
        }

        player.placeBet(bet);
        const guess = this.guess();
        return {
            position: guess,
            bet: bet
        }
    },
    win: function(player) {
        const relativeAmount = player.getBalance();
        this.doLog('win', player);
        player.addBalance(player.getBet() * 2);
        if (player.getTarget() < relativeAmount) {
            this.setTarget(player);
        }
        player.clearBet();
    },
    lose: function(player) {
        this.doLog('lose', player);
        if (player.getBalance() < player.getStats().startingBalance * 0.3) {
            player.setBalance(player.getStats().startingBalance * 1.1);
            player.stats.busted++;
        }
        player.clearBet();
    }
};

export { strategy }
