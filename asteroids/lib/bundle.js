/******/ (function(modules) { // webpackBootstrap
/******/ 	// The module cache
/******/ 	var installedModules = {};
/******/
/******/ 	// The require function
/******/ 	function __webpack_require__(moduleId) {
/******/
/******/ 		// Check if module is in cache
/******/ 		if(installedModules[moduleId]) {
/******/ 			return installedModules[moduleId].exports;
/******/ 		}
/******/ 		// Create a new module (and put it into the cache)
/******/ 		var module = installedModules[moduleId] = {
/******/ 			i: moduleId,
/******/ 			l: false,
/******/ 			exports: {}
/******/ 		};
/******/
/******/ 		// Execute the module function
/******/ 		modules[moduleId].call(module.exports, module, module.exports, __webpack_require__);
/******/
/******/ 		// Flag the module as loaded
/******/ 		module.l = true;
/******/
/******/ 		// Return the exports of the module
/******/ 		return module.exports;
/******/ 	}
/******/
/******/
/******/ 	// expose the modules object (__webpack_modules__)
/******/ 	__webpack_require__.m = modules;
/******/
/******/ 	// expose the module cache
/******/ 	__webpack_require__.c = installedModules;
/******/
/******/ 	// define getter function for harmony exports
/******/ 	__webpack_require__.d = function(exports, name, getter) {
/******/ 		if(!__webpack_require__.o(exports, name)) {
/******/ 			Object.defineProperty(exports, name, {
/******/ 				configurable: false,
/******/ 				enumerable: true,
/******/ 				get: getter
/******/ 			});
/******/ 		}
/******/ 	};
/******/
/******/ 	// getDefaultExport function for compatibility with non-harmony modules
/******/ 	__webpack_require__.n = function(module) {
/******/ 		var getter = module && module.__esModule ?
/******/ 			function getDefault() { return module['default']; } :
/******/ 			function getModuleExports() { return module; };
/******/ 		__webpack_require__.d(getter, 'a', getter);
/******/ 		return getter;
/******/ 	};
/******/
/******/ 	// Object.prototype.hasOwnProperty.call
/******/ 	__webpack_require__.o = function(object, property) { return Object.prototype.hasOwnProperty.call(object, property); };
/******/
/******/ 	// __webpack_public_path__
/******/ 	__webpack_require__.p = "";
/******/
/******/ 	// Load entry module and return exports
/******/ 	return __webpack_require__(__webpack_require__.s = 5);
/******/ })
/************************************************************************/
/******/ ([
/* 0 */
/***/ (function(module, exports) {

const Util = {
    dir(vec) {
        let norm = Util.norm(vec);
        return Util.scale(vec, 1/norm);
    },
    
    dist(pos1, pos2) {
        return Math.sqrt(
            Math.pow(pos1[0] - pos2[0], 2) + Math.pow(pos1[1] - pos2[1], 2)
        )
    },

    inherits (ChildClass, ParentClass) {
        ChildClass.prototype = Object.create(ParentClass.prototype);
        ChildClass.prototype.constructor = ChildClass;
    },

    norm(vec) {
        return Util.dist([0,0], vec)
    },

    randomVec (length) {
        const deg = 2 * Math.PI * Math.random();
        return Util.scale([Math.sin(deg), Math.cos(deg)], length);
      },
      // Scale the length of a vector by the given amount.
      
    scale (vec, m) {
        return [vec[0] * m, vec[1] * m];
    },

    wrap(coord, max) {
        if (coord < 0) {
            return max - (coord % max);
        } else if (coord > max) {
            return coord % max;
        } else {
            return coord;
        }
    }
      
}

module.exports = Util;

/***/ }),
/* 1 */
/***/ (function(module, exports, __webpack_require__) {

const Util = __webpack_require__(0)

function MovingObject(options) {
    this.pos = options.pos;
    this.vel = options.vel;
    this.radius = options.radius;
    this.color = options.color;
    this.game = options.game;
}

MovingObject.prototype.isCollideWith = function(otherObject) {
    return ((Util.dist(this.pos, otherObject.pos)) < (this.radius + otherObject.radius))
}

MovingObject.prototype.isWrappable = true;

MovingObject.prototype.collideWith = function(otherObject) {
}

MovingObject.prototype.draw = function draw(ctx) {
    ctx.fillStyle = this.color;
    ctx.beginPath();
    ctx.arc(this.pos[0], this.pos[1], this.radius, 0, 2 * Math.PI, true);
    ctx.fill();
}

const NORMAL_FRAME_TIME_DELTA = 1000 / 60;
MovingObject.prototype.move = function move(timeDelta) {
    const velocityScale = timeDelta / NORMAL_FRAME_TIME_DELTA;
    const offsetX = this.vel[0] * velocityScale;
    const offsetY = this.vel[1] * velocityScale;
    this.pos = [this.pos[0] + offsetX, this.pos[1] + offsetY];
    if (this.game.isOutOfBounds(this.pos)) {
        if (this.isWrappable) {
            this.pos = this.game.wrap(this.pos);
        } else {
            this.remove();
        }
    }
    
}

module.exports = MovingObject;

/***/ }),
/* 2 */
/***/ (function(module, exports, __webpack_require__) {

const Asteroid = __webpack_require__(3)
const Util = __webpack_require__(0)
const Ship = __webpack_require__(4)

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

/***/ }),
/* 3 */
/***/ (function(module, exports, __webpack_require__) {

const Util = __webpack_require__(0);
const MovingObject = __webpack_require__(1);
const Ship = __webpack_require__(4);

const DEFAULTS = {
    COLOR: "blue",
    RADIUS: 10,
    SPEED: 4
}

function Asteroid(options = {}) {
    options.pos = options.pos;
    options.color = DEFAULTS.COLOR;
    options.radius = DEFAULTS.RADIUS;
    options.vel = options.vel || Util.randomVec(DEFAULTS.SPEED);

    MovingObject.call(this, options);
}

Util.inherits(Asteroid, MovingObject);

Asteroid.prototype.collideWith = function(otherObject) {
    if (otherObject instanceof Ship) {
        otherObject.relocate();
    }
}

module.exports = Asteroid;

/***/ }),
/* 4 */
/***/ (function(module, exports, __webpack_require__) {

const MovingObject = __webpack_require__(1);
const Util = __webpack_require__(0);
const Bullet = __webpack_require__(6);

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

/***/ }),
/* 5 */
/***/ (function(module, exports, __webpack_require__) {

const Game = __webpack_require__(2)
const GameView = __webpack_require__(7)

document.addEventListener("DOMContentLoaded", function() {
    const canvasEl = document.getElementById("game-canvas");
    canvasEl.width = Game.DIM_X;
    canvasEl.height = Game.DIM_Y;

    const ctx = canvasEl.getContext("2d");
    const game = new Game();
    new GameView(game, ctx).start();
})

/***/ }),
/* 6 */
/***/ (function(module, exports, __webpack_require__) {

const Util = __webpack_require__(0);
const Asteroid = __webpack_require__(3);
const MovingObject = __webpack_require__(1);

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

/***/ }),
/* 7 */
/***/ (function(module, exports, __webpack_require__) {

const Game = __webpack_require__(2)

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

/***/ })
/******/ ]);