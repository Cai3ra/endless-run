# Setting class dependencies
path = require "path"
Atask = require path.join __dirname, "../Atask"

# Task class configuration
class Clean extends Atask
    # Environment global variable for parameter
    constructor: (@environment = environment)->

        # Loading dependencies
        @del = require "del"

        # Define paths and configuration for task
        @config = require "./config"

        super(@environment)

    Task:=>
        @del @config.paths, force: yes, (paths)->
            console.log "Arquivos e pastas deletadas:\n", paths.join("\n")

    Dev:=>
        @gulp.task @config.taskName, @Task

    Prod:=>
        @Dev()

module.exports = Clean