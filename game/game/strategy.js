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
        // player.setTarget(player.getBalance() * 1.01);
        player.setTarget(player.getBalance() * 1.01);
    },
    guess: function() {
        return (Math.round(Math.random() * 10) % 2 === 1);
    },
    turn: function(player) {
        const relativeAmount = player.getBalance();
        if (player.getTarget() === 0) {
            this.setTarget(player);
        }
        const offTarget = player.getTarget() - relativeAmount;
        const minBet = Math.round(relativeAmount * 0.0005);
        let bet = Math.ceil(offTarget / 2);
        if (player.getStats().targetAttempts > 10) {
            bet = Math.ceil(offTarget);
        }
        if (bet < minBet) {
            bet = minBet;
        }
        // if (bet > (player.getBalance() / 2)) {
        //     this.setTarget(player);
        //     return this.turn(player);
        // }
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
        if (player.getBalance() < player.getStats().startingBalance) {
            player.setBalance(player.getStats().startingBalance);
        }
        player.clearBet();
    }
};

export { strategy }
