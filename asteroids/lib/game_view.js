const Game = require("./game")

function GameView(game, ctx) {
    this.game = game;
    this.ctx = ctx;
}

GameView.MOVES = {
    w: [0, -0.01],
    a: [-0.01, 0],
    s: [0, .01],
    d: [.01, 0],
};

GameView.prototype.bindKeyHandlers = function() {
    const ship = this.game.ship[0];

    Object.keys(GameView.MOVES).forEach( (k) => {
        const move = GameView.MOVES[k];
        key(k, function() { ship.power(move); });
    });

    key("space", function() { ship.fireBullet(); });
}

GameView.prototype.start = function() {
    const game = this.game;
    const ctx = this.ctx;
    const gv = this;

    setInterval(function() {
        let vel = Math.random() * 10
        gv.bindKeyHandlers();
        game.step(vel);
        game.draw(ctx);
    }, 1000/60);
}

module.exports = GameView;