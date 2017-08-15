Game = require './game/Game.coffee'

class App

	constructor:()->
		@game = new Game()
		$(@game).on 'load_complete', @loadComplete

	loadComplete:()=>
		console.log "game load complete"



init = ->	
	app = new App()
	
document.addEventListener("DOMContentLoaded", init)