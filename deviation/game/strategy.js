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
    getBet: function(player) {
        const relativeAmount = player.getBalance();
        if (player.getTarget() === 0) {
            this.setTarget(player);
        }
        const offTarget = player.getTarget() - relativeAmount;
        const minBet = Math.round(relativeAmount * 0.0005);
        let bet = Math.ceil(offTarget / 2);
        if (player.getStats().targetAttempts > 5) {
            bet = Math.ceil(offTarget);
        }
        if (bet < minBet) {
            bet = minBet;
        }
        player.placeBet(bet);
        return bet;
    },
    turn: function(player) {
        const guess = this.guess();
        return {
            position: guess,
            bet: this.getBet(player)
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
