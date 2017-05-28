	# Setting class dependencies
path = require "path"
Atask = require path.join __dirname, "../Atask"

# Task class configuration
class Js extends Atask
	# Environment global variable for parameter
	constructor: (@environment = environment)->

		# Loading dependencies
		@browserify = require "browserify"
		@coffeeify = require "coffeeify"
		@source = require "vinyl-source-stream"
		@buffer = require "vinyl-buffer"
		@uglify = require "gulp-uglify"
		@glob = require "glob"
		@es = require "event-stream"
		@rename = require "gulp-rename"

		# Loading configuration
		@config = require "./config"

		super(@environment)

	Task:=>
		glob = "#{@config.paths.src}#{@config.prefix}#{@config.extension}"

		@glob glob, nodir: yes, (err, files)=>

			tasks = files.map (entry)=>
				src = @browserify
					entries: [entry]
					debug:  @config[@environment].debug
					transform: @config.transform
				.bundle()
				.pipe @plumber
					errorHandler: @notify.onError @config.errorMsg
				.pipe @source path.basename entry
				.pipe @buffer()
				.pipe @rename
					extname: @config.extname

				# Minify task for prod environment
				if @environment is "prod"
					src = src.pipe @uglify
						debug: @config[@environment].debug

				src = src.pipe @gulp.dest @config.paths.dest

				# Not send stream to prod environment
				if @environment isnt "prod"
					# src = src.pipe @changed @config.paths.dest,
					# 	extension: path.extname entry
					# 	hasChanged: @changed.compareSha1Digest
					src = src.pipe @browserSync.stream()

				return src
					
			return @es.merge tasks

	Dev:=>
		@gulp.task @config.taskName, @Task

	Prod:=>
		@Dev()

module.exports = Js