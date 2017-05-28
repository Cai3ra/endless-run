# Setting class dependencies
path = require "path"
Atask = require path.join __dirname, "../Atask"

# Task class configuration
class Watch extends Atask
	# Environment global variable for parameter
	constructor: (@environment = environment, @tasks = tasks)->

		# Loading dependencies
		@watch = require "gulp-watch"

		super(@environment)

	Task:=>
		@tasks.forEach (task)=>
			if task.config.paths.hasOwnProperty "watch"
				glob = "#{task.config.paths.watch}#{task.config.extension}"
			else
				glob = "#{task.config.paths.src}#{task.config.prefix}#{task.config.extension}"

			@watch glob, (vinyl)=>
				task.Task()
				@browserSync.reload()
		return

	Dev:=>
		@gulp.task "watch", @Task

module.exports = Watch