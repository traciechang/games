const Asteroid = require("./asteroid")
const Util = require("./util")
const Ship = require("./ship")

function Game() {
    this.asteroids = [];
    this.addAsteroids();
    this.ship = [new Ship({ pos: this.randomPositions(), game: this })];
    this.bullets = [];
}

Game.BG_COLOR = "black";//"#000000";
Game.DIM_X = 1000;
Game.DIM_Y = 600;
Game.NUM_ASTEROIDS = 10;

Game.prototype.addAsteroids = function() {
    for (let n = 0; n < Game.NUM_ASTEROIDS; n++) {
        let rp = this.randomPositions();
        this.asteroids.push(new Asteroid({ pos: rp, game: this }));
    }
}

Game.prototype.allObjects = function() {
    return this.asteroids.concat(this.ship, this.bullets);
}

Game.prototype.checkCollisions = function() {
    for (let i = 0; i < this.allObjects().length; i++) {
        for (let j = 0; j < this.allObjects().length; j++) {
            if (i === j) {
                continue;
            } else {
                if (this.allObjects()[i].isCollideWith(this.allObjects()[j])) {
                    this.allObjects()[i].collideWith(this.allObjects()[j]);
                    return;
                }
            }
        }
    }
}

Game.prototype.draw = function(ctx) {
    ctx.clearRect(0, 0, Game.DIM_X, Game.DIM_Y);
    ctx.fillStyle = Game.BG_COLOR;
    ctx.fillRect(0, 0, Game.DIM_X, Game.DIM_Y);
    // this.asteroids.forEach( (ast) => { ast.draw(ctx); });
    this.allObjects().forEach ( (obj) => { obj.draw(ctx); });
};

Game.prototype.isOutOfBounds = function(pos) {
    return (pos[0] < 0) || (pos[1] < 0) || (pos[0] > Game.DIM_X) || (pos[1] > Game.DIM_Y);
}

Game.prototype.moveObjects = function(delta) {
    this.allObjects().forEach ( (obj) => { obj.move(delta); })
}

Game.prototype.randomPositions = function() {
    return [Math.floor(Math.random() * Game.DIM_X), Math.floor(Math.random() * Game.DIM_Y)];
};

Game.prototype.remove = function(asteroid) {
    this.asteroids.splice(this.asteroids.indexOf(asteroid), 1);
}

Game.prototype.step = function(delta) {
    this.moveObjects(delta);
    this.checkCollisions();
}

Game.prototype.wrap = function(pos) {
    return [Util.wrap(pos[0], Game.DIM_X), Util.wrap(pos[1], Game.DIM_Y)];
}

module.exports = Game;