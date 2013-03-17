Plugin = require './plugins/plugin' 

global.config = config = {}

config.plugins = {}

# config.Plugins
config.plugins.sources = []
config.plugins.decisions = []
config.plugins.actions = []

# helper function to load plugins
loadPlugin = (type, name) ->
    path = './plugins/' + type + '/' + name

    _klass = require(path)
    plugin = new _klass(path)

    config.plugins[type].push plugin 


loadPlugin 'sources', 'getCode'
loadPlugin 'decisions', 'alwaysFalse'
loadPlugin 'decisions', 'alwaysTrue'
loadPlugin 'actions', 'playMp3'
loadPlugin 'actions', 'printToConsole'


# loadPlugin 'actions', 'sendSms'
# loadPlugin 'actions', 'playMp3'
        
# export the module
module.exports = config