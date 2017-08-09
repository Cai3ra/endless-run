# Mountain = require "./Mountain.coffee"
Scenery = require "./Scenery.coffee"
Runner = require "./Runner.coffee"
Obstacle = require "./Obstacle.coffee"

class InfiniteRoad

    constructor:()->
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
        @OBSTACLES_COUNT = 10

        @axishelper = {}
        @camera = {}
        @controls = {}
        @directionalLight = {}
        @globalRenderID = {}
        @runner = {}
        @hemisphereLight = {}
        @mountains = []
        @plane = {}
        @planeGeometry = {}
        @planeMaterial = {}
        @obstacle = {}	
        @obstacles = []
        @obstacleSpawnIntervalID = {}
        @obstacleSpawnTime = 4000
        @obstacleCounterIntervalID = {}
        @obstacleCounterTime = 30000
        @renderer = {}
        @scene = {}
        @sky = {}
        @skyGeometry = {}
        @skyMaterial = {}

    init:()=>
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
        # @camera.position.set 0, @PLANE_LENGTH / 125, @PLANE_LENGTH / 2 + @PLANE_LENGTH / 25
        @camera.position.set 0, @PLANE_LENGTH / 125, 325
        window.camera = @camera

        # FLOOR
        # planeGeometry = new THREE.BoxGeometry @PLANE_WIDTH, @PLANE_LENGTH + @PLANE_LENGTH / 10, 1
        # planeMaterial = new THREE.MeshLambertMaterial {
        #     color: 0x78909C
        # }
        # @plane = new THREE.Mesh( planeGeometry, planeMaterial )
        # @plane.rotation.x = 1.570
        # @plane.receiveShadow = true
        
        @scenery = new Scenery(@PLANE_WIDTH, @PLANE_LENGTH, @PADDING)
        @scene.add @scenery
        # do @createLandscapeFloors
        # for i in [0...120]
        #     isEast = false
        #     if i % 2 is 0
        #         isEast = true
        #     _mountain = new Mountain(i, isEast, @PLANE_LENGTH, @PLANE_WIDTH) 
        
        # $(window).on "mountain_loaded", (e, _mountain)=>
        #     @mountains.push _mountain
        #     @scene.add _mountain

        # SKY
        skyGeometry = new THREE.BoxGeometry @WW*1.5, @WH, 1, 1
        skyMaterial = new THREE.MeshBasicMaterial {
            map: THREE.ImageUtils.loadTexture( 'img/background.jpg' ),
            depthWrite: false,
            side: THREE.BackSide
        }
        sky = new THREE.Mesh skyGeometry, skyMaterial
        sky.position.y = 300
        sky.position.z = -@PLANE_LENGTH / 2 + @PADDING

        

        # OBSTACLES
        # do @startObstacles
        
        # RUNNER
        @runner = new Runner @PLANE_WIDTH, @PLANE_LENGTH, @PADDING

        # @scene.add @camera, directionalLight, @plane, @axishelper, @runner
        @scene.add @camera, sky, @axishelper

        $(window).on "load_complete", @loadComplete

    loadComplete:()=>
        # LIGHTS
        directionalLight = new THREE.DirectionalLight 0x00ff00, 1
        directionalLight.position.set 0, 1, 0
        hemisphereLight = new THREE.HemisphereLight 0x000000, 0x37474F, 1
        hemisphereLight.position.y = 500
        do @createSpotlights

        @scene.add directionalLight, hemisphereLight

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

            spotLight = new THREE.SpotLight 0x0052af, 2
            # spotLight.position.set 150, ( i * @PLANE_LENGTH / 5 ) - ( @PLANE_LENGTH / 2.5 ), -200
            spotLight.castShadow = true
            spotLight.shadowCameraNear = 10
            spotLight.shadowCameraVisible = false
            spotLight.target = target
            spotLight.shadowMapWidth = 2048
            spotLight.shadowMapHeight = 2048
            spotLight.fov = 40

            @scenery.objects.river.mesh.add spotLight
        
    startObstacles:=>
        @obstacleSpawnIntervalID = window.setInterval =>
            if @obstacles.length < @OBSTACLES_COUNT
                _obst = new Obstacle @PLANE_WIDTH, @PLANE_LENGTH, @PADDING
                @obstacles.push _obst
                @scene.add _obst
        , @obstacleSpawnTime

        @obstacleCounterIntervalID = window.setInterval =>
            @OBSTACLES_COUNT += 1
        , @obstacleCounterTime

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
    
    render:()=>
        @globalRenderID = requestAnimationFrame @render
        
        if @obstacles.length > 0
            @obstacles.forEach (el, idx)->
                el.animate() if el
        
        # if @mountains.length > 0
        #     @mountains.forEach (el, idx)->
        #         el.animate() if el

        if @detectCollisions(@obstacles) is true
            do @gameOver

        @renderer.render @scene, @camera
    
    gameOver:()=>
        cancelAnimationFrame @globalRenderID
        window.clearInterval @obstacleSpawnIntervalID
        window.clearInterval @obstacleCounterIntervalID

        $('#overlay-gameover').fadeIn 100
        $('#btn-restart').on 'click', @restartGame

    restartGame:=>
        $('#overlay-gameover').fadeOut 50
        @OBSTACLE_COUNT = 10
        @obstacles.forEach ( el, idx )=>
            @scene.remove @obstacles[ idx ]

        @obstacles = []
        @runner.position.x = 0
        do @render
        do @startObstacles
        $('#btn-restart').off 'click'

    detectCollisions:(_obsts)=>
        _origin = @runner.position.clone()
        _vMax = @runner.geometry.vertices.length
        for v in [0..._vMax]
            _localVertex = @runner.geometry.vertices[v].clone()
            _globalVertex = _localVertex.applyMatrix4(@runner.matrix)
            _directionVector = _globalVertex.sub(@runner.position)
            _ray = new THREE.Raycaster(_origin, _directionVector.clone().normalize())
            _intersections = _ray.intersectObjects(_obsts)

            if _intersections.length > 0 and _intersections[0].distance < _directionVector.length()
                return true
        
        return false
            

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