config = {}

config.plugins = {}

# config.Plugins
config.plugins.sources = []
config.plugins.decisions = []
config.plugins.actions = []

# Decisions
config.plugins.decisions.push require('./plugins/decisions/alwaysTrue')
config.plugins.decisions.push require('./plugins/decisions/alwaysFalse')

# Actions
config.plugins.actions.push require('./plugins/actions/printToConsole')
config.plugins.actions.push require('./plugins/actions/sendSms')
config.plugins.actions.push require('./plugins/actions/playMp3')

# export the module
module.exports = config