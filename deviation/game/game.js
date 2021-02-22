import { getPlayer } from "./player.js";

function makeGame(strategy) {
    const game = {
        strategy: null,
        maxBalance: 0,
        minBalance: 0,
        n: 0,
        ticks: 0,
        risk: 0,
        plot: [],
        width: 600,
        points: [{ x: 0, y:0 }, { x: 1, y:1 }],
        players: [],
        lastMaxDeviation: 0
    };
    game.totalBalance = function () {
        let balance = 0;
        this.players.forEach((player) => {
            balance += player.balance;
        });
        return 0;
    };
    game.getStats = function() {
        return this.players[0].getStats();
    };
    let maxMove = 0;
    game.calcMovingWins = function(stats) {
        let wins = 0;
        let losses = 0;
        stats.recentHistory.forEach ((win) => {
            if (win) {
                wins++;
            } else {
                losses++;
            }
        });
        // return (losses > 0) ? Math.round((wins * 1000) / losses) / 1000 : 0;
        const thisMove = Math.abs(wins - losses);
        if (thisMove > maxMove) {
            maxMove = thisMove;
        }
        return maxMove;
    };
    game.calcRecentSuccess = function(stats) {
        return (stats.totals.won - stats.totals.lost) * 300;
        // return stats.maxDeviation * 100;
    };
    game.play = function () {
        const result = Math.round(Math.random() * 10) % 2 === 1;
        const turn = this.players[0].turn();
        const win = turn.position === result;
        this.players[0].play(win);
        const recSuc = this.calcRecentSuccess(this.players[0].getStats());
        if (recSuc !== this.lastMaxDeviation) {
            this.lastMaxDeviation = recSuc;
        }
        this.pushPlot(recSuc);
    };
    game.pushPlot = function (y = 0) {
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
