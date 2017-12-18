const MovingObject = require("./moving_object");
const Util = require("./util");
const Bullet = require("./bullet");

function Ship(options = {}) {
    options.radius = Ship.RADIUS;
    options.vel = options.vel || [0,0];
    options.color = Ship.COLOR;

    MovingObject.call(this, options)
}

Util.inherits(Ship, MovingObject);

Ship.RADIUS = 15;
Ship.COLOR = "white";

Ship.prototype.fireBullet = function() {
    const norm = Util.norm(this.vel);

    if (norm === 0) {
        return;
    }

    const relVel = Util.scale(Util.dir(this.vel), Bullet.SPEED);

    const bulletVel = [relVel[0] + this.vel[0], relVel[1] + this.vel[1]];
    
    this.game.bullets.push(new Bullet({ pos: this.pos, color: this.color, game: this.game, vel: bulletVel}));
}

Ship.prototype.power = function(impulse) {
    this.vel = [this.vel[0] + impulse[0], this.vel[1] + impulse[1]];
}

Ship.prototype.relocate = function() {
    this.pos = this.game.randomPositions();
    this.vel = [0, 0];
}

module.exports = Ship;