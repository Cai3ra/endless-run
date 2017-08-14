# Mountain = require "./Mountain.coffee"
Loader = require "./Loader.coffee"
Scenery = require "./scenery/Scenery.coffee"
Runner = require "./objects/Runner.coffee"
Obstacle = require "./objects/Obstacle.coffee"
SkyBox = require "./objects/SkyBox.coffee"

class Scene

    constructor:()->
        window.addEventListener 'resize', @onResize
        do @setUp
        do @init

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
        @renderer.shadowMap.enabled = true
        @renderer.shadowMapSoft = true

        @scene = new THREE.Scene()

        @camera = new THREE.PerspectiveCamera 45, @WW / @WH, 1, 3000
        # @camera.position.set 0, @PLANE_LENGTH / 125, @PLANE_LENGTH / 2 + @PLANE_LENGTH / 25
        @camera.position.set 0, 17, 325
        window.camera = @camera

        @axishelper = new THREE.AxisHelper -@PLANE_LENGTH

        #  CONTROLS
        controls = new THREE.OrbitControls( @camera, @renderer.domElement )
        controls.enableKeys = false

        # STATS
        stats = new Stats()
        document.body.appendChild stats.domElement

        @loader = new Loader()
        $(@loader).on 'complete', @loadComplete
        @loader.start()

        # SCENERY
        @scenery = new Scenery(@PLANE_WIDTH, @PLANE_LENGTH, @PADDING)
        # @scene.segments.firstSegment.lookAt(@camera.position)
        @scene.add @scenery

        # SKY
        @skybox = new SkyBox()

        window.skyboxCubeMap = @skybox.cubeMap


        # OBSTACLES
        # do @startObstacles
    

        @scene.add @camera, @axishelper, @skybox

        

    loadComplete:()=>

        # SCENERY BUILD
        @scenery.build(@loader.getSceneryElements())

        
        # RUNNER
        @runner = new Runner @loader.getRunner(), @PLANE_WIDTH, @PLANE_LENGTH, @PADDING
        @scene.add @runner
        
        
        # LIGHTS
        directionalLight = new THREE.DirectionalLight 0xFFFFFF, 1
        directionalLight.position.set 0, 1, 0
        hemisphereLight = new THREE.HemisphereLight 0x000000, 0xFFFFFF, 1
        hemisphereLight.position.y = 500
        
        @scene.add directionalLight, hemisphereLight
        
        do @render
        do @onResize

    createSpotlights:()=>
        spotLight = {}
        # target = {}
        # targetGeometry = {}
        # targetMaterial = {}

        # for i in [0...5]
        # targetGeometry = new THREE.BoxGeometry 1, 1, 1
        # targetMaterial = new THREE.MeshNormalMaterial()
        # target = new THREE.Mesh targetGeometry, targetMaterial
        # target.position.set 0, 2, 0
        # target.visible = false
        # @scene.add target

        spotLight = new THREE.SpotLight 0x0052af, 2
        spotLight.position.set @PLANE_WIDTH * .5, 300, 0
        spotLight.castShadow = true
        spotLight.shadowCameraNear = 10
        spotLight.shadowCameraVisible = true
        spotLight.shadowDarkness = 0.70
        spotLight.intensity = 2

        # spotLight.shadowMapWidth = 2048
        # spotLight.shadowMapHeight = 2048
        # spotLight.fov = 40

        @scene.add spotLight

        # lightTarget = new THREE.Object3D()
        # lightTarget.position.set(150,10,-100)
        # @scene.add(lightTarget)
        # spotLight.target = lightTarget

        # spotLight.target = @scenery.objects.river.mesh
        # @scenery.objects.river.mesh.add spotLight
        
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

    
    render:()=>
        @globalRenderID = requestAnimationFrame @render

        @scenery.move()

        @runner.update()
        
        if @obstacles.length > 0
            @obstacles.forEach (el, idx)->
                el.animate() if el

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
        # _origin = @runner.position.clone()
        # _vMax = @runner.geometry.vertices.length
        # for v in [0..._vMax]
        #     _localVertex = @runner.geometry.vertices[v].clone()
        #     _globalVertex = _localVertex.applyMatrix4(@runner.matrix)
        #     _directionVector = _globalVertex.sub(@runner.position)
        #     _ray = new THREE.Raycaster(_origin, _directionVector.clone().normalize())
        #     _intersections = _ray.intersectObjects(_obsts)

        #     if _intersections.length > 0 and _intersections[0].distance < _directionVector.length()
        #         return true
        
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


module.exports = Scene