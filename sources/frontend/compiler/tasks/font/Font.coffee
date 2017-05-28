# Setting class dependencies
path = require "path"
Atask = require path.join __dirname, "../Atask"

# Task class configuration
class Font extends Atask
    # Environment global variable for parameter
    constructor: (@environment = environment)->

        # Setting task configuration
        @config = require "./config"

        super(@environment)

    Task:=>
        @Move "#{@config.paths.src}#{@config.prefix}#{@config.extension}", @config.paths.dest, "fonts"

    Dev:=>
        @gulp.task @config.taskName, @Task

    Prod:=>
        @Dev()

module.exports = Font