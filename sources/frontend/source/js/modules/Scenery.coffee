class Scenery extends THREE.Group
    objects: {
        river: {
            url: 'RIO_01.obj',
            x: 0,
            y: 0,
            z: 0
        },
        wallR: {
            url: 'PAREDE_01.obj',
            x: 300,
            y: 0,
            z: 0
        },
        bush: {
            url: 'ARBUSTO_01.obj',
            x: 0,
            y: -15,
            z: 200
        },
        arch: {
            url: 'ARCO_01.obj',
            x: 0,
            y: 0,
            z: 0,
        },
        three: {
            url: 'ARVORE_01.obj',
            x: 0,
            y: 5,
            z: 250,
        },        
        # rock1: {
        #     url: 'PEDRAS_01.obj',
        #     x: 0,
        #     y: 0,
        #     z: 0,
        # },
        # rock2:{
        #     url: 'PEDRAS_02.obj',
        #     x: 0,
        #     y: 0,
        #     z: 0,
        # },
        plant: {
            url: 'PLANTINHA_01.obj',
            x: 0,
            y: -3,
            z: 240,
        }
    }

    constructor:(@planeW, @planeLen, @padding)->
        super()
        console.log "Scenery", @planeW
        do @load

    load:=>
        manager = new THREE.LoadingManager()
        manager.onProgress = ( item, loaded, total )=>
            # console.log "LoadingManager onProgress: ", item, loaded, total

        manager.onLoad = (  )=>
            do @build
            $(window).trigger "load_complete"

        @loader = new THREE.OBJLoader manager
        for key of @objects
            @loadObject @objects[key]

    loadObject:(obj)=>
        @loader.load 'data/'+obj.url, ( object )=>
            object.traverse ( child ) =>

                if child instanceof THREE.Mesh
                    # child.material.map = texture;
                    obj.mesh = child

            obj.obj3d = object
        , @onProgress, @onError

    build:()=>
        @objects.wallR.x = @planeW
        @objects.wallL = {
            x: -@planeW,
            y: 0,
            z: 0,
            obj3d: @objects.wallR.obj3d.clone()
            mesh: @objects.wallR.mesh.clone()
        }
        
        @objects.wallL.obj3d.rotation.y = Math.PI
        
        
        @objects.bush.x = @planeW - @padding
        @objects.three.x = -@planeW * .6
        @objects.plant.x = -@planeW * .55

        window.three = @objects.three
        for key of @objects
            obj = @objects[key]
            obj.obj3d.position.x = obj.x
            obj.obj3d.position.y = obj.y
            obj.obj3d.position.z = obj.z
            @.add obj.obj3d

        $(window).trigger "scenery_ready"
        
        console.log("asas", @objects.river.mesh.material.color);
        # @objects.river.mesh.material.color = 0x0052af
        @objects.river.mesh.material = new THREE.MeshPhongMaterial ({color:0x0052af})
        do @addLights

    addLights:()=>
        # directionalLight = new THREE.DirectionalLight 0x0052af, 1
        # directionalLight.position.set 0, 1, 0
        # @objects.river.mesh.receiveShadow = true

    onProgress: ( xhr ) ->
        if xhr.lengthComputable
            percentComplete = xhr.loaded / xhr.total * 100
            console.log "onProgress: ", Math.round(percentComplete, 2) + '% downloaded'

    onError: ( xhr ) =>
        console.log "onError", xhr

module.exports = Scenery