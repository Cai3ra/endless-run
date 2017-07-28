Tunel = require './modules/Tunel.coffee'
InfiniteRoad = require './modules/InfiniteRoad.coffee'

class App
	texturesLoaded:0
	textures: {
		'stone': {
			url: 'img/textures/stonePattern.jpg'
		},
		'galaxy': {
			url: 'img/textures/galaxyTexture.jpg'
		},
		'galaxy1': {
			url: 'img/textures/galaxyTexture1.jpg'
		},
		'galaxy2': {
			url: 'img/textures/galaxyTexture2.jpg'
		},
		'geometric': {
			url: 'img/textures/geometricPattern.png'
		}
	}
	loader: new THREE.TextureLoader()

	constructor:()->
		@infiniteRoad = new InfiniteRoad()
		# do @initLoader

	initLoader:()=>
		@loader.crossOrigin = "Anonymous"
		@loader.load @textures.galaxy2.url, (texture)=>
			@tunel = new Tunel(texture)


init = ->	
	app = new App()
	
document.addEventListener("DOMContentLoaded", init)