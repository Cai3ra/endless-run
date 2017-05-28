class Tunel

    constructor:(texture)->
        console.log "Tunel", texture
        @WW = window.innerWidth
        @WH = window.innerHeight

        @WW2 = @WW * 0.5
        @WH2 = @WH * 0.5

        do @init
        @createMesh texture
        do @handleEvents
        do @initAnimation
        window.requestAnimationFrame @render.bind(this)

    init:()=>
        console.log "init"

        @mouse = {
            position: new THREE.Vector2(@WW2,@WH2)
            ratio: new THREE.Vector2(0, 0)
            target: new THREE.Vector2(@WW2,@WH2)
        }

        @renderer = new THREE.WebGLRenderer({
            antialias: true,
            canvas: document.querySelector "#scene"
        })
        @renderer.setSize @WW, @WH
        console.log @WW, @WH

        @camera = new THREE.PerspectiveCamera(15, @WW / @WH, 0.01, 1000)
        @camera.rotation.y = Math.PI
        @camera.position.z = 0.035

        @scene = new THREE.Scene()

    createMesh:(texture)=>
        console.log "createMesh"
        points = []
        geometry = new THREE.Geometry()
        @scene.remove @tubeMesh

        for i in [0...5]
            points.push(new THREE.Vector3(0, 0, 3 * (i / 4)))
        
        points[4].y = -0.06
        @curve = new THREE.CatmullRomCurve3 points
        @curve.type = "catmullrom"

        geometry = new THREE.Geometry()
        geometry.vertices = @curve.getPoints(70)
        @splineMesh = new THREE.Line(geometry, new THREE.LineBasicMaterial())

        @tubeMaterial = new THREE.MeshBasicMaterial({
            side: THREE.BackSide
            map: texture
        })
        @tubeMaterial.map.wrapS = THREE.MirroredRepeatWrapping
        @tubeMaterial.map.wrapT = THREE.MirroredRepeatWrapping
        @tubeMaterial.map.repeat.set(
            @tubeMaterial.repx,
            @tubeMaterial.repy
        )

        @tubeGeometry = new THREE.TubeGeometry(@curve, 70, 0.02, 30, false)
        @tubeGeometry_o = @tubeGeometry.clone()
        @tubeMesh = new THREE.Mesh @tubeGeometry, @tubeMaterial

        @scene.add @tubeMesh


    handleEvents:()=>
        console.log "handleEvents"
        window.addEventListener "resize", @onResize.bind(this), false
        document.body.addEventListener "mousemove", @mouseMove.bind(this), false

    initAnimation:()=>
        @textureParams = {
            offsetX: 0,
            offsetY: 0,
            repeatX: 10,
            repeatY: 4
        }
        @cameraShake = {
            x: 0,
            y: 0
        }
        hyperSpace = new TimelineMax({ repeat: -1 })
        hyperSpace.to(@textureParams, 4, {
            repeatX: 0.3,
            ease: Power1.easeInOut
        })
        hyperSpace.to(@textureParams, 12, {
            offsetX: 8,
            ease: Power2.easeInOut
        }, 0)
        hyperSpace.to(@textureParams, 6, {
            repeatX: 10,
            ease: Power2.easeInOut
        }, "-=5")

        shake = new TimelineMax({ repeat: -1, repeatDelay: 5 })
        shake.to(@cameraShake, 2, {
            x: -0.01,
            ease: RoughEase.ease.config({
                template: Power0.easeNone,
                strength: 0.5,
                points: 100,
                taper: "none",
                randomize: true,
                clamp: false
            })
        }, 4)
        shake.to(@cameraShake, 2, {
            x: 0,
            ease: RoughEase.ease.config({
                template: Power0.easeNone,
                strength: 0.5,
                points: 100,
                taper: "none",
                randomize: true,
                clamp: false
            })
        })
        console.log "initAnimation", shake, hyperSpace
        

    render:()=>
        # console.log "render"
        do @updateMaterialOffset
        do @updateCameraPosition
        do @updateCurve
        @renderer.render @scene, @camera
        window.requestAnimationFrame(@render.bind(this))

    updateMaterialOffset:()=>
        # console.log "updateMaterialOffset"
        @tubeMaterial.map.offset.x = @textureParams.offsetX
        @tubeMaterial.map.offset.y += 0.001
        @tubeMaterial.map.repeat.set(
            @textureParams.repeatX,
            @textureParams.repeatY
        )

    updateCameraPosition:()=>
        # console.log "updateCameraPosition"
        @mouse.position.x += (@mouse.target.x - @mouse.position.x) / 50
        @mouse.position.y += (@mouse.target.y - @mouse.position.y) / 50

        @mouse.ratio.x = @mouse.position.x / @WW
        @mouse.ratio.y = @mouse.position.y / @WH

        @camera.position.x = @mouse.ratio.x * 0.044 - 0.025 + @cameraShake.x
        @camera.position.y = @mouse.ratio.y * 0.044 - 0.025    

    updateCurve:()=>
        # console.log "updateCurve"
        index = 0
        vertice = null
        vertice_o = null

        for i in [0...@tubeGeometry.vertices.length]
            vertice_o = @tubeGeometry_o.vertices[i]
            vertice = @tubeGeometry.vertices[i]
            index = Math.floor(i / 30)
            vertice.x += (vertice_o.x + @splineMesh.geometry.vertices[index].x - vertice.x) / 15
            vertice.y += (vertice_o.y + @splineMesh.geometry.vertices[index].y - vertice.y) / 15
        
        @tubeGeometry.verticesNeedUpdate = true

        @curve.points[2].x = 0.6 * (1 - @mouse.ratio.x) - 0.3
        @curve.points[3].x = 0
        @curve.points[4].x = 0.6 * (1 - @mouse.ratio.x) - 0.3

        @curve.points[2].y = 0.6 * (1 - @mouse.ratio.y) - 0.3
        @curve.points[3].y = 0
        @curve.points[4].y = 0.6 * (1 - @mouse.ratio.y) - 0.3

        @splineMesh.geometry.verticesNeedUpdate = true
        @splineMesh.geometry.vertices = @curve.getPoints(70)



    mouseMove:(e)=>
        @mouse.target.x = e.clientX
        @mouse.target.y = e.clientY
        # console.log "mousemove", @mouse


    onResize:()=>
        @WW = window.innerWidth
        @WH = window.innerHeight
        @WW2 = @WW * 0.5
        @WH2 = @WH * 0.5

        @camera.aspect = @WW / @WH
        do @camera.updateProjectionMatrix
        @renderer.setSize @WW, @WH



module.exports = Tunel  
