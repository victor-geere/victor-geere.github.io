function makeGame() {
    const game = {
        n: 0,
        ticks: 0,
        risk: 0,
        plot: [],
        width: 600,
        points: [{ x: 0, y:0 }, { x: 1, y:1 }],
    };
    game.setOptions = function() {
    };
    game.getStats = function() {
    };
    game.clearPoints = function() {
        game.points = [];
    };
    game.play = function (n) {
        const a = 2;
        const b = -1;
        const c = 1;
        const x = n - 2;
        const d = a * Math.pow(x, 3) + b * x + c;
        const y = Math.sqrt(d);
        // console.log(`y : ${y}, x: ${x}`);
        this.n = x;
        this.pushPlot(y);
    };
    game.pushPlot = function (y) {
        this.points.push({ x: this.n, y: y });
        if (this.points.length > this.width) {
            this.points.splice(0, 1);
        }
        this.n++;
        this.ticks++;
    };
    game.start = function() {
    };

    game.start();

    game.score = function() {
    };
    return game;
}

export { makeGame }
