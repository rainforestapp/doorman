// Generated by CoffeeScript 1.3.3
(function() {
  var Plugin;

  Plugin = (function() {

    function Plugin(path) {
      var crypto;
      crypto = require('crypto');
      this.hash = crypto.createHash('md5').update(path).digest("hex");
    }

    Plugin.prototype.run = function() {};

    return Plugin;

  })();

  module.exports = Plugin;

}).call(this);