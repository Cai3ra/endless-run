Model3D = require "./Model3D.coffee" 

class Scenery extends THREE.Group
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
        three: {
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
        @elements = {};
        for key of @objects
            @loadObject @objects[key], key

    loadObject:(obj, key)=>
        @loader.load 'data/'+obj.url, ( object )=>
            @elements[key] = new Model3D(object, obj.position)
            # console.log(key+": ", @elements[key]);
        , @onProgress, @onError

    build:()=>
        # console.log "@elements: >> ", @elements
        @elements.bush.position.x = @planeW - @padding
        @elements.three.position.x = -@planeW * .6
        @elements.plant.position.x = -@planeW * .55
        
        @elements.wallR.position.x = -@planeW * 5

        # Criando parede esquerda manualmente baseada na direita
        @elements.wallL = new Model3D(@elements.wallR.clone())
        @elements.wallL.position.x = @planeW*5
        @elements.wallL.rotation.y = Math.PI

        
        for key of @elements
            el = @elements[key]
            @.add el

        # Computing total width, height and length
        bbox = new THREE.Box3().setFromObject(@)
        @width = bbox.max.x - bbox.min.x
        @height = bbox.max.y - bbox.min.y
        @length = bbox.max.z - bbox.min.z

        $(window).trigger "scenery_ready"
        
        
        # @elements.river.mesh.material.color = 0x0052af
        @elements.river.mesh.material = new THREE.MeshPhongMaterial ({color:0x0052af})
        do @addLights

    addLights:()=>
        # directionalLight = new THREE.DirectionalLight 0x0052af, 1
        # directionalLight.position.set 0, 1, 0
        # @objects.river.mesh.receiveShadow = true


    move:()=>
        @position.z+=1;
        if @position.z > @length
            @position.z = 0

    onProgress: ( xhr ) ->
        if xhr.lengthComputable
            percentComplete = xhr.loaded / xhr.total * 100
            # console.log "onProgress: ", Math.round(percentComplete, 2) + '% downloaded'

    onError: ( xhr ) =>
        console.log "onError", xhr

module.exports = Scenery