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
            console.log "LoadingManager onProgress: ", item, loaded, total

        manager.onLoad = (  )=>
            console.log "all complete"
            do @build
            $(window).trigger "load_complete"

        @loader = new THREE.OBJLoader manager
        for key of @objects
            console.log "for: ", @objects[key]
            @loadObject @objects[key]

    loadObject:(obj)=>
        @loader.load 'data/'+obj.url, ( object )=>
            obj.mesh = object
        , @onProgress, @onError

    build:()=>
        @objects.wallR.x = @planeW
        @objects.wallL = {
            x: -@planeW,
            y: 0,
            z: 0,
            mesh: @objects.wallR.mesh.clone()
        }
        @objects.wallL.mesh.rotation.y = Math.PI
        
        @objects.bush.x = @planeW - @padding
        @objects.three.x = -@planeW * .6
        @objects.plant.x = -@planeW * .55

        window.three = @objects.three
        for key of @objects
            obj = @objects[key]
            obj.mesh.position.x = obj.x
            obj.mesh.position.y = obj.y
            obj.mesh.position.z = obj.z
            @.add obj.mesh

    onProgress: ( xhr ) ->
        if xhr.lengthComputable
            percentComplete = xhr.loaded / xhr.total * 100
            console.log "onProgress: ", Math.round(percentComplete, 2) + '% downloaded'

    onError: ( xhr ) =>
        console.log "onError", xhr

module.exports = Scenery