ObjContainer = require "../objects/ObjContainer.coffee" 
SegmentManager = require "./SegmentManager.coffee" 

class Scenery extends THREE.Group
    segments:{}
    velocity: 3
    constructor:(@planeW, @planeLen, @padding)->
        super()
        console.log "Scenery", @planeW

    build:(@elements)=>
        # console.log "@elements: >> ", @elements

        @elements.wallR.position.x = -@planeW * 5
        # Criando parede esquerda manualmente baseada na direita
        @elements.wallL = new ObjContainer(@elements.wallR.clone(), "wallL")
        @elements.wallL.position.x = @planeW*5
        @elements.wallL.rotation.y = Math.PI

        # criando gerenciador de segmentos do cenario
        @sceneryElements = {
            bush: @elements.bush
            arch: @elements.arch
            tree: @elements.tree
            plant: @elements.plant
        }

        # criando gerenciador de segmentos do cenario
        @segmentManager = new SegmentManager({
            wallL: @elements.wallL
            wallR: @elements.wallR
            river: @elements.river
        }, @sceneryElements, @planeW, @planeLen)
        @segments = @segmentManager.getSegments() 
        for key of @segments
            el = @segments[key]
            @.add el

        # Computing total width, height and length
        bbox = new THREE.Box3().setFromObject(@)
        @width = bbox.max.x - bbox.min.x
        @height = bbox.max.y - bbox.min.y
        @length = bbox.max.z - bbox.min.z

        # bbox2 = new THREE.Box3().setFromObject(@elements.wallR)
        # @width = bbox2.max.x - bbox2.min.x
        # @height = bbox2.max.y - bbox2.min.y
        # @length = bbox2.max.z - bbox2.min.z

        
        do @addLights

    addLights:()=>
        # directionalLight = new THREE.DirectionalLight 0x0052af, 1
        # directionalLight.position.set 0, 1, 0
        # @objects.river.mesh.receiveShadow = true


    move:()=>
        for key of @segments
            _seg = @segments[key]
            _seg.position.z += @velocity
            if _seg.position.z > @planeLen
                $(@segmentManager).trigger "segment_update", [_seg]    


module.exports = Scenery