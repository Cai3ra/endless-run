class SkyBox extends THREE.Mesh
	constructor:()->
		@cubeMap = new THREE.CubeTexture([])
		@cubeMap.format = THREE.RGBFormat

		loader = new THREE.ImageLoader()
		loader.load 'img/skybox.png', (image) =>
			# console.log(">>>>>> SkyBox loaded")

			getSide = (x, y) ->
				size = 1024

				canvas = document.createElement('canvas')
				canvas.width = size
				canvas.height = size
				
				context = canvas.getContext('2d')
				context.drawImage image, -x * size, -y * size
				
				canvas

			@cubeMap.images[0] = getSide(2, 1) # px
			@cubeMap.images[1] = getSide(0, 1) # nx
			@cubeMap.images[2] = getSide(1, 0) # py
			@cubeMap.images[3] = getSide(1, 2) # ny
			@cubeMap.images[4] = getSide(1, 1) # pz
			@cubeMap.images[5] = getSide(3, 1) # nz
			@cubeMap.needsUpdate = true

			return
				
		cubeShader = THREE.ShaderLib['cube']
		cubeShader.uniforms['tCube'].value = @cubeMap
		
		skyBoxMaterial = new THREE.ShaderMaterial(
			fragmentShader: cubeShader.fragmentShader
			vertexShader: cubeShader.vertexShader
			uniforms: cubeShader.uniforms
			depthWrite: false
			side: THREE.BackSide
		)

		super(new THREE.BoxGeometry(1000, 1000, 1000), skyBoxMaterial)
		


module.exports = SkyBox;