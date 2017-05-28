# Setting class dependencies
path = require "path"
Atask = require path.join __dirname, "../Atask"

# Task class configuration
class Image extends Atask
    # Environment global variable for parameter
    constructor: (@environment = environment)->

        # Loading dependencies
        @image = require "gulp-image"

        # Setting task configuration
        @config = require "./config"

        super(@environment)

    Task:=>
        @Move "#{@config.paths.src}#{@config.prefix}#{@config.extension}", @config.paths.dest, "images"

    Dev:=>
        @gulp.task @config.taskName, @Task

    Prod:=>
        @gulp.task @config.taskName, =>
            @gulp.src "#{@config.paths.src}**/*#{@config.extension}"
            # .pipe @plumber
            #     errorHandler: @notify.onError @config.errorMsg
            # .pipe @image()
            .pipe @gulp.dest @config.paths.dest

module.exports = Image