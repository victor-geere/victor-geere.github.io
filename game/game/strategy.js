const strategy = {
    setTarget: function(player) {
        player.setTarget(player.getBalance() * 1.01);
    },
    guess: function() {
        return (Math.round(Math.random() * 10) % 2 === 1);
    },
    turn: function(player) {
        if (player.getTarget() === 0) {
            this.setTarget(player);
        }
        let bet = Math.round((player.getTarget() - player.getBalance()) / 2);
        if (bet < 10) {
            bet = 10;
        }
        player.placeBet(bet);
        const guess = this.guess();
        return {
            position: guess,
            bet: bet
        }
    },
    win: function(player) {
        player.addBalance(player.getBet() * 2);
        if (player.getTarget() < player.getBalance()) {
            this.setTarget(player);
        }
        player.clearBet();
    },
    lose: function(player) {
        // player.subtractBalance(Math.random() * 1000);
        player.clearBet();
    }
};

export { strategy }
