ObjContainer = require "./objects/ObjContainer.coffee" 

class Loader
    objects: {
        river: {
            url: 'RIO_01.obj',
            position:{x:0, y:0, z:0}
        },
        wallR: {
            url: 'PAREDE_01.obj',
            position:{x:300, y:0, z:0}
        },
        bush: {
            url: 'ARBUSTO_01.obj',
            position:{x:0, y:-15, z:200}
        },
        arch: {
            url: 'ARCO_01.obj',
            position:{x:0, y:0, z:0}
        },
        tree: {
            url: 'ARVORE_01.obj',
            position:{x:0, y:5, z:250}
        },        
        # rock1: {
        #     url: 'PEDRAS_01.obj',
            # position:{x:0, y:0, z:0}
        # },
        # rock2:{
        #     url: 'PEDRAS_02.obj',
            # position:{x:0, y:0, z:0}
        # },
        plant: {
            url: 'PLANTINHA_01.obj',
            position:{x:0, y:-3, z:240}
        }
    }

    constructor:()->
        console.log "Loader", @

    start:()=>
        manager = new THREE.LoadingManager()
        manager.onProgress = ( item, loaded, total )=>
            # console.log "LoadingManager onProgress: ", item, loaded, total

        manager.onLoad = @onComplete

        @loader = new THREE.OBJLoader manager
        for key of @objects
            @loadObject @objects[key], key

    loadObject:(obj, key)=>
        @loader.load 'data/'+obj.url, ( object )=>
            @objects[key].model = new ObjContainer(object, obj.position)
        , @onProgress, @onError

    getSceneryElements:()->
        {
            river:@objects.river.model,
            wallR:@objects.wallR.model,
            bush:@objects.bush.model,
            arch:@objects.arch.model,
            tree:@objects.tree.model,
            plant:@objects.plant.model
        }

    onProgress: ( xhr ) ->
        if xhr.lengthComputable
            percentComplete = xhr.loaded / xhr.total * 100
            # console.log "onProgress: ", Math.round(percentComplete, 2) + '% downloaded'

    onComplete:()=>
        $(@).trigger "complete"

    onError: ( xhr ) =>
        console.log "onError", xhr
        

module.exports = Loader