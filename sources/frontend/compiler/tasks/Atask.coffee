# Root task class configuration
class Atask
	# Environment global variable for parameter
	constructor: (@environment = environment)->

		# loading dependencies
		@gulp = require "gulp"
		@browserSync = require "browser-sync"
		@plumber = require "gulp-plumber"
		@notify = require "gulp-notify"
		@changed = require "gulp-changed"
		@cached = require "gulp-cached"

		# Building task
		@Build()

	Build:=>
		# Calling task based on environment
		if @environment is "prod" 
			# Calling prod
			@Prod()
		else
			# Calling dev
			@Dev()

	Prod:=>
		# Production task
		console.log "Set task for production"

	Dev:=>
		# Development / Homolog task
		console.log "Set task for development"

	# Only for move files
	Move:( files, dest, cached = false )=>
		src = @gulp.src files

		if cached
			if typeof cached is "string"
				src = src.pipe @cached cached
			else
				throw new Error "É necessário passar um nome para cachear os arquivos."
		else
			src = src.pipe @changed()

		src = src.pipe @plumber
			errorHandler: @notify.onError "Ouve um erro ao mover os arquivos: <%= error.message %>"
		.pipe @gulp.dest dest
		
		if @environment isnt "prod"
			src = src.pipe @browserSync.stream()

module.exports = Atask