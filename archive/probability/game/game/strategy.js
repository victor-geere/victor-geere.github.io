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

        let factor = stats.betFactor;
        factor = Math.round(factor * 1000) / 1000;

        if (stats.won) {
            // bet = bet - factor;
            bet = bet - (bet * 0.025);
            if (balance > stats.startingBalance + 200) {
                stats.startingBet = balance / 600;
                bet = stats.startingBet;
                stats.startingBalance = balance;
            }
        } else {
            // bet = bet + factor;
            bet = bet + (bet * 0.025);
            /*
            if (balance < stats.startingBalance - 10000) {
                bet = stats.startingBet;
                stats.startingBalance = balance;
                stats.betFactor = Math.ceil(balance / (150 * 300));
            }
             */
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
        this.doLog('win', player);
        player.getStats().wins++;
        if (player.getStats().maxDrift < Math.abs(player.getStats().wins - player.getStats().losses)) {
            player.getStats().maxDrift = Math.abs(player.getStats().wins - player.getStats().losses);
        }
        player.addBalance(player.getBet() * 2);
        player.clearBet();
    },
    lose: function(player) {
        this.doLog('lose', player);
        player.getStats().losses++;
        if (player.getStats().maxDrift < Math.abs(player.getStats().wins - player.getStats().losses)) {
            player.getStats().maxDrift = Math.abs(player.getStats().wins - player.getStats().losses);
        }
        if (player.getBalance() <= 0) {
            player.setBalance(player.getStats().startingBalance);
            player.stats.busted++;
        }
        player.clearBet();
    }
};

export { strategy }
