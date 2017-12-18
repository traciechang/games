const Util = require("./util");
const Asteroid = require("./asteroid");
const MovingObject = require("./moving_object");

function Bullet(options = {}) {
    options.radius = Bullet.RADIUS;
    MovingObject.call(this, options);
}

Bullet.RADIUS = 2;
Bullet.SPEED = 15;

Util.inherits(Bullet, MovingObject);

Bullet.prototype.collideWith = function(otherObject) {
    if (otherObject instanceof Asteroid) {
        this.game.remove(otherObject);
        this.game.remove(this);
    }
}

Bullet.prototype.isWrappable = false;

module.exports = Bullet;