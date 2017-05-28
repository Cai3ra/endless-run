# Setting class dependencies
path = require "path"
Atask = require path.join __dirname, "../Atask"

# Task class configuration
class Css extends Atask
    # Environment global variable for parameter
    constructor: (@environment = environment)->

        # Loading dependencies
        @compass = require "gulp-compass"

        # Loading configuration
        @config = require "./config"

        super(@environment)

    Task:=>
        src = @gulp.src "#{@config.paths.src}#{@config.prefix}#{@config.extension}"
        .pipe @plumber
            errorHandler: @notify.onError @config.errorMsg
        .pipe @compass
            style: @config[@environment].style
            comments: @config[@environment].comments
            css: @config.paths.dest
            sass: @config.paths.src
            javascript: @config.paths.js
            font: @config.paths.font
            image: @config.paths.image

        # if @environment isnt "prod"
        #     src = src.pipe @changed @config.paths.dest,
        #         extension: @config.changed.extension
        #         hasChanged: @changed.compareSha1Digest

        src = src.pipe @gulp.dest @config.paths.dest
        
        if @environment isnt "prod"
            src = src.pipe @browserSync.stream()

    Dev:=>
        @gulp.task @config.taskName, @Task

    Prod:=>
        @Dev()

module.exports = Css