config = {}

config.plugins = {}

# config.Plugins
config.plugins.sources = []
config.plugins.decisions = []
config.plugins.actions = []

# Module loader

# Loop through the database

    # Read decision plugins from DB and pass to module loader

# loadModule 'decisions', './plugins/decisions/alwaysTrue'

# loadModule: (type, path) ->

#     config.plugins[type].push { name: hash(path), plugin: require(path) }


# Decisions
config.plugins.decisions.push require('./plugins/decisions/alwaysTrue')
config.plugins.decisions.push require('./plugins/decisions/alwaysFalse')

# Actions
config.plugins.actions.push require('./plugins/actions/printToConsole')
config.plugins.actions.push require('./plugins/actions/sendSms')
config.plugins.actions.push require('./plugins/actions/playMp3')

# export the module
module.exports = config