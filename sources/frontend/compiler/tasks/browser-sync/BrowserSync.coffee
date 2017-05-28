# Setting class dependencies
path = require "path"
Atask = require path.join __dirname, "../Atask"

# Task class configuration
class BrowserSync extends Atask
    # Environment global variable for parameter
    constructor: (@environment = environment)->

        # Setting default configuration
        @config = require "./config"

        # Passing environment for task
        super(@environment)

    Task:=>
        @browserSync
            browser: @config.browser
            logPrefix: @config.logPrefix
            notify: @config.notify
            open: @config.open
            port: @config.port
            reloadDelay: @config.reloadDelay
            server:
                baseDir: @config.server.baseDir
                index: @config.server.index

    Dev:=>
        @gulp.task @config.taskName, @Task

module.exports = BrowserSync