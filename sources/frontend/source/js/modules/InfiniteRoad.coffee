class InfiniteRoad

    constructor:()->
        console.log "InifiniteRoad"
        

        window.addEventListener 'resize', @onResize
        do @setUp
        do @init
        do @render
        do @onResize

    setUp:()=>
        @WW = window.innerWidth
        @WH = window.innerHeight
        @WW2 = @WW * 0.5
        @WH2 = @WH * 0.5
        @PLANE_WIDTH = 50
        @PLANE_LENGTH = 1000
        @PADDING = @PLANE_WIDTH / 5 * 2
        @POWERUP_COUNT = 10

        @axishelper = {}
        @camera = {}
        @controls = {}
        @directionalLight = {}
        @globalRenderID = {}
        @hero = {}
        @hemisphereLight = {}
        @mountains = []
        @plane = {}
        @planeGeometry = {}
        @planeMaterial = {}
        @powerup = {}	
        @powerups = []
        @powerupSpawnIntervalID = {}
        @powerupCounterIntervalID = {}
        @queue = {}
        @renderer = {}
        @scene = {}
        @sky = {}
        @skyGeometry = {}
        @skyMaterial = {}

    init:()=>
        console.log "init"
        THREE.ImageUtils.crossOrigin = ''

        @renderer = new THREE.WebGLRenderer {
            antialias: true,
            canvas: document.querySelector "#scene"
        }
        @renderer.setSize @WW, @WH
        @renderer.setClearColor 0xFFFFFF, 1
        @renderer.shadowMapEnabled = true
        @renderer.shadowMapSoft = true

        @scene = new THREE.Scene()

        @axishelper = new THREE.AxisHelper @PLANE_LENGTH / 2

        @camera = new THREE.PerspectiveCamera 45, @WW / @WH, 1, 3000
        @camera.position.set 0, @PLANE_LENGTH / 125, @PLANE_LENGTH / 2 + @PLANE_LENGTH / 25

        # FLOOR
        planeGeometry = new THREE.BoxGeometry @PLANE_WIDTH, @PLANE_LENGTH + @PLANE_LENGTH / 10, 1
        planeMaterial = new THREE.MeshLambertMaterial {
            color: 0x78909C
        }
        @plane = new THREE.Mesh( planeGeometry, planeMaterial )
        @plane.rotation.x = 1.570
        @plane.receiveShadow = true

        do @createLandscapeFloors
        for i in [0...30]
            isEast = false
            if i % 2 is 0
                isEast = true
            @createMountain i, isEast

        # SKY
        skyGeometry = new THREE.BoxGeometry 1200, 800, 1, 1
        skyMaterial = new THREE.MeshBasicMaterial {
            map: THREE.ImageUtils.loadTexture( 'https://s3-us-west-2.amazonaws.com/s.cdpn.io/26757/background.jpg' ),
            depthWrite: false,
            side: THREE.BackSide
        }
        sky = new THREE.Mesh skyGeometry, skyMaterial
        sky.position.y = 300
        sky.position.z = -@PLANE_LENGTH / 2 + @PADDING

        # LIGHTS
        # do @createSpotlights
        directionalLight = new THREE.DirectionalLight 0xffffff, 1
        directionalLight.position.set 0, 1, 0
        hemisphereLight = new THREE.HemisphereLight 0x000000, 0x37474F, 1
        hemisphereLight.position.y = 500

        @scene.add @camera, directionalLight, hemisphereLight, @plane, @axishelper

    createLandscapeFloors:()=>
        planeLeft = {}
        planeLeftGeometry = {}
        planeLeftMaterial = {}
        planeRight = {}

        planeLeftGeometry = new THREE.BoxGeometry @PLANE_WIDTH, @PLANE_LENGTH + @PLANE_LENGTH / 10, 1
        planeLeftMaterial = new THREE.MeshLambertMaterial {
            color: 0x8BC34A
        }
        planeLeft = new THREE.Mesh planeLeftGeometry, planeLeftMaterial
        planeLeft.receiveShadow = true
        planeLeft.rotation.x = 1.570
        planeLeft.position.x = -@PLANE_WIDTH
        planeLeft.position.y = 1

        planeRight = planeLeft.clone()
        planeRight.position.x = @PLANE_WIDTH

        @scene.add planeLeft, planeRight

        
    createSpotlights:()=>
        spotLight = {}
        target = {}
        targetGeometry = {}
        targetMaterial = {}

        for i in [0...5]
            targetGeometry = new THREE.BoxGeometry 1, 1, 1
            targetMaterial = new THREE.MeshNormalMaterial()
            target = new THREE.Mesh targetGeometry, targetMaterial
            target.position.set 0, 2, ( i * @PLANE_LENGTH / 5 ) - ( @PLANE_LENGTH / 2.5 )
            target.visible = false
            @scene.add target

            spotLight = new THREE.SpotLight 0xFFFFFF, 2
            spotLight.position.set 150, ( i * @PLANE_LENGTH / 5 ) - ( @PLANE_LENGTH / 2.5 ), -200
            spotLight.castShadow = true
            spotLight.shadowCameraNear = 10
            spotLight.shadowCameraVisible = false
            spotLight.target = target
            spotLight.shadowMapWidth = 2048
            spotLight.shadowMapHeight = 2048
            spotLight.fov = 40

            @plane.add spotLight
    
    render:()=>
        @globalRenderID = requestAnimationFrame @render
        
        if @mountains.length > 0
            @mountains.forEach (el, idx)->
                el.animate()

        @renderer.render @scene, @camera

    createObject:(i, isEast, prototype)=>
        # console.log "createObject"
        object = {}
        objectDimensionX = {}
        objectDimensionY = {}
        objectDimensionZ = {}
        object = prototype.clone()
        objectDimensionX = Math.random() * 0.25 + 0.05
        objectDimensionY = Math.random() * 0.25
        objectDimensionZ = objectDimensionX
        object.scale.set objectDimensionX, objectDimensionY, objectDimensionZ

        if isEast is true
            object.position.x = @PLANE_WIDTH * 2
            object.position.z = (i * @PLANE_LENGTH / 27) - (1.5 * @PLANE_LENGTH)
        else
            object.position.x = -@PLANE_WIDTH * 2
            object.position.z = (i * @PLANE_LENGTH / 27) - (@PLANE_LENGTH / 2)
        
        object.visible = true
        object.animate = =>
            if object.position.z < @PLANE_LENGTH / 2 - @PLANE_LENGTH / 10
                object.position.z += 5
            else
                object.position.z = -@PLANE_LENGTH / 2
        @mountains.push object
        @scene.add object


    createMountain:(idx, isEast)=>
        prototype = {}
        loader = new THREE.ColladaLoader()
        loader.load 'https://s3-us-west-2.amazonaws.com/s.cdpn.io/26757/mountain.dae', (collada)=>
            prototype = collada.scene
            prototype.visible = false
            @createObject idx, isEast, prototype

    
    onResize:()=>
        @WW = window.innerWidth
        @WH = window.innerHeight

        @WW2 = @WW * 0.5
        @WH2 = @WH * 0.5
        @camera.aspect = @WW / @WH
        @camera.updateProjectionMatrix()
        @renderer.clear()
        @renderer.setSize @WW, @WH


module.exports = InfiniteRoad