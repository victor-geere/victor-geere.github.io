import { getPlayer } from "./player.js";

function makeGame(strategy) {
    const game = {
        strategy,
        maxBalance: 0,
        minBalance: 0,
        n: 0,
        ticks: 0,
        risk: 0,
        plot: [],
        width: 600,
        points: [{ x: 0, y: strategy.startingBalance * 0.9 }, { x: 1, y:strategy.startingBalance }],
        players: []
    };
    game.totalBalance = function () {
        let balance = 0;
        this.players.forEach((player) => {
            balance += player.balance;
        });
        return balance;
    };
    game.getStats = function() {
        return this.players[0].getStats();
    };
    game.play = function () {
        const result = Math.round(Math.random() * 10) % 2 === 1;
        const turn = this.players[0].turn();
        const win = turn.position === result;
        this.players[0].play(win);
        this.pushPlot(this.players[0].getBalance());
    };
    game.pushPlot = function (y = this.totalBalance()) {
        this.points.push({ x: this.n, y: y });
        if (this.points.length > this.width) {
            this.points.splice(0, 1);
        }
        this.n++;
        this.ticks++;
    };
    game.setOptions = function(options) {
        // this.risk = options.risk;
    };
    game.resetGame = function() {

    };
    game.testGame = function() {
        let win = 0;
        let lose = 0;
        for(let n = 0; n < 1000000; n++) {
            if (Math.round(Math.random() * 10) % 2 === 1) {
                win++;
            } else {
                lose++;
            }
        }
        console.log(`win : ${win}`);
        console.log(`lose : ${lose}`);
    };
    game.start = function(strategy) {
        this.testGame();
        this.strategy = strategy;
        this.players = [ getPlayer(this.strategy) ];
    };

    game.start(strategy);

    game.score = function() {
        console.log(this.players[0].strategy.getLog());
    };
    return game;
}

export { makeGame }
