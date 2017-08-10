Game = require './game/Game.coffee'

class App

	constructor:()->
		@game = new Game()


init = ->	
	app = new App()
	
document.addEventListener("DOMContentLoaded", init)