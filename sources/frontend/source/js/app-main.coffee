Tunel = require './modules/Tunel.coffee'

class App
	texturesLoaded:0
	textures: {
		'stone': {
			url: 'img/textures/stonePattern.jpg'
		},
		'galaxy': {
			url: 'img/textures/galaxyTexture.jpg'
		}
	}
	loader: new THREE.TextureLoader()

	constructor:()->
		do @initLoader

	initLoader:()=>
		@loader.crossOrigin = "Anonymous"
		@loader.load @textures.galaxy.url, (texture)=>
			@tunel = new Tunel(texture)

init = ->	
	app = new App()
	
document.addEventListener("DOMContentLoaded", init)