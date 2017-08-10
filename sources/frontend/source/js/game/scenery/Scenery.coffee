ObjContainer = require "../objects/ObjContainer.coffee" 
SegmentManager = require "./SegmentManager.coffee" 

class Scenery extends THREE.Group

    constructor:(@planeW, @planeLen, @padding)->
        super()
        console.log "Scenery", @planeW

    build:(@elements)=>
        # console.log "@elements: >> ", @elements
        @elements.bush.position.x = @planeW - @padding
        @elements.tree.position.x = -@planeW * .6
        @elements.plant.position.x = -@planeW * .55
        
        @elements.wallR.position.x = -@planeW * 5

        # Criando parede esquerda manualmente baseada na direita
        @elements.wallL = new ObjContainer(@elements.wallR.clone())
        @elements.wallL.position.x = @planeW*5
        @elements.wallL.rotation.y = Math.PI

        
        @segmentManager = new SegmentManager({
            wallL: @elements.wallL
            wallR: @elements.wallR
            river: @elements.river
        })
        @.add @segmentManager.getSegments()

        @sceneryElements = {
            bush: @elements.bush
            arch: @elements.arch
            tree: @elements.tree
            plant: @elements.plant
        }
        for key of @sceneryElements
            el = @sceneryElements[key]
            @.add el


        # Computing total width, height and length
        bbox = new THREE.Box3().setFromObject(@)
        @width = bbox.max.x - bbox.min.x
        @height = bbox.max.y - bbox.min.y
        @length = bbox.max.z - bbox.min.z
        
        do @addLights

    addLights:()=>
        # directionalLight = new THREE.DirectionalLight 0x0052af, 1
        # directionalLight.position.set 0, 1, 0
        # @objects.river.mesh.receiveShadow = true


    move:()=>
        @position.z+=1;
        if @position.z > @length
            @position.z = 0


module.exports = Scenery