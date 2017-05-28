# Setting class dependencies
path = require "path"
Atask = require path.join __dirname, "../Atask"

# Task class configuration
class Html extends Atask
	# Environment global variable for parameter
	constructor: (@environment = environment)->

		# Loading dependencies
		@nunjucks = require "gulp-nunjucks"
		@htmlmin = require "gulp-htmlmin"
		@useref = require "gulp-useref"

		# Loading configuration
		@config = require "./config"

		super(@environment)

	Task:=>
		src = @gulp.src "#{@config.paths.src}#{@config.prefix}#{@config.extension}"
		.pipe @plumber
			errorHandler: @notify.onError @config.errorMsg
		.pipe @nunjucks.compile()
		.pipe @useref
			searchPath: @config.searchPath

		# if @environment is "prod"
		# 	src = src.pipe @htmlmin
		# 		collapseWhitespace: @config[@environment].collapseWhitespace

		# if @environment isnt "prod"
		# 	src = src.pipe @changed @config.paths.dest

		src = src.pipe @gulp.dest @config.paths.dest

		if @environment isnt "prod"
			src = src.pipe @browserSync.stream()

	Dev:=>
		@gulp.task @config.taskName, @Task

	Prod:=>
		@Dev()

module.exports = Html