class Mountain
    object: {}
    prototype = {}
    
    constructor:(@idx, @isEast, @planeLen, @planeW)->
        loader = new THREE.ColladaLoader()
        loader.load 'https://s3-us-west-2.amazonaws.com/s.cdpn.io/26757/mountain.dae', (collada)=>
            @prototype = collada.scene
            @prototype.visible = false
            do @createObject

    createObject:()=>
        # console.log "createObject"
        objectDimensionX = {}
        objectDimensionY = {}
        objectDimensionZ = {}
        @object = @prototype.clone()
        objectDimensionX = Math.random() * 0.25 + 0.05
        objectDimensionY = Math.random() * 0.25
        objectDimensionZ = objectDimensionX
        @object.scale.set objectDimensionX, objectDimensionY, objectDimensionZ

        if @isEast is true
            @object.position.x = @planeW * 2
            @object.position.z = (@idx * @planeLen / 27) - (1.5 * @planeLen)
        else
            @object.position.x = -@planeW * 2
            @object.position.z = (@idx * @planeLen / 27) - (@planeLen / 2)
        
        @object.visible = true
        @object.animate = =>
            if @object.position.z < @planeLen / 2 - @planeLen / 10
                @object.position.z += 5
            else
                @object.position.z = -@planeLen / 2

        $(window).trigger "mountain_loaded", [@object]

    getObj:()=>
        return @object

module.exports = Mountain