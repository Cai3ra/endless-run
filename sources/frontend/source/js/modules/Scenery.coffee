class Scenery extends THREE.Group
    objects: {
        river: {
            url: 'RIO_01.obj',
            x: 0,
            y: 0,
            z: 0,
        },
        wallR: {
            url: 'PAREDE_01.obj',
            x: 300,
            y: 0,
            z: 0,
        }
        # ,
        # {
        #     url: 'ARBUSTO_01.obj',
        #     x: 0,
        #     y: 0,
        #     z: 0,
        # },
        # {
        #     url: 'ARCO_01.obj',
        #     x: 0,
        #     y: 0,
        #     z: 0,
        # },
        # {
        #     url: 'ARVORE_01.obj',
        #     x: 0,
        #     y: 0,
        #     z: 0,
        # },        
        # {
        #     url: 'PEDRAS_01.obj',
        #     x: 0,
        #     y: 0,
        #     z: 0,
        # },
        # {
        #     url: 'PEDRAS_02.obj',
        #     x: 0,
        #     y: 0,
        #     z: 0,
        # },
        # {
        #     url: 'PLANTINHA_01.obj',
        #     x: 0,
        #     y: 0,
        #     z: 0,
        # },
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