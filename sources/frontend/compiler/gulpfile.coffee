# Setting global dependencies
gulp = require "gulp"
sequence = require "gulp-sequence"
Watch = require "./tasks/watch/Watch"

# Setting environment
environment = "dev"

# Loading tasks
tasks =
	browserSync: require "./tasks/browser-sync/BrowserSync"
	clean: require "./tasks/clean/Clean"
	css: require "./tasks/css/Css"
	font: require "./tasks/font/Font"
	html: require "./tasks/html/Html"
	image: require "./tasks/image/Image"
	js: require "./tasks/js/Js"
	data: require "./tasks/data/Data"

builTasks = ->
	count = 0
	watchable = []

	# Calling all tasks
	for task of tasks
		CurrentTask = tasks[task]
		CurrentTask = new CurrentTask environment

		# Check watch propertie
		hasWatch = CurrentTask.config.hasOwnProperty "watch"
		hasEnvironment = CurrentTask.config.hasOwnProperty environment

		# Separate watchable tasks
		if  hasWatch and CurrentTask.config.watch
			watchable[count] = CurrentTask
			count++
		else if hasEnvironment and 
		CurrentTask.config[environment].hasOwnProperty("watch") and 
		CurrentTask.config[environment].watch
			watchable[count] = CurrentTask
			count++
	return watchable

builTasks()

# Avaliable environments
gulp.task "default", (cb)->
	# Getting watchable tasks and building tasks
	watchable = builTasks()

	# Calling watch task
	watchTask = new Watch environment, watchable

	console.log "\nAmbiente: ", "#{environment}\n".toUpperCase()

	# Starting tasks
	sequence("clean", ["image","font"], ["html", "css", "data", "js"], ["browser-sync", "watch"])(cb)

gulp.task "prod", (cb)->
	# Changing environment
	environment = "prod"

	# Building tasks
	builTasks()

	console.log "\nAmbiente: ", "#{environment}\n".toUpperCase()

	# Starting tasks
	sequence("clean", ["image","font"], ["html","css", "data", "js"])(cb)
return