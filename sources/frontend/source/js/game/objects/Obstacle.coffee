class Obstacle
    obj = {}
    objDimension = 0
    objGeometry = {}
    objMaterial = {}
    xPos = 0
    xPosValues = []
    yPos = 0
    yPosValues = []
    zPos = 0
    zPosValues = []

    constructor:(@planeW, @planeLen, @padding)->
        @objDimension = 2

        @xPosValues = [ -( @planeW - @padding ) / 2, 0, ( @planeW - @padding ) / 2 ]
        @yPosValues = [ @objDimension + 1 ]
        @zPosValues = [ -( @planeLen - @padding ) / 2 ]

        @xPos = @xPosValues[ @getRandomInteger( 0, @xPosValues.length - 1 ) ]
        @yPos = @yPosValues[ @getRandomInteger( 0, @yPosValues.length - 1 ) ]
        @zPos = @zPosValues[ @getRandomInteger( 0, @zPosValues.length - 1 ) ]

        @objGeometry = new THREE.BoxGeometry @objDimension, @objDimension, @objDimension, @objDimension
        @objMaterial = new THREE.MeshLambertMaterial {
            color: 0xff00d2
            shading: THREE.FlatShading
        }

        @obj = new THREE.Mesh @objGeometry, @objMaterial
        @obj.position.set @xPos, @yPos, @zPos
        @obj.castShadow = true
        @obj.receiveShadow = true
        @obj.animate = =>
            if @obj.position.z < @planeLen / 2 + @planeLen / 10
                @obj.position.z += 10
            else
                @obj.position.x = @xPosValues[ @getRandomInteger(0, @xPosValues.length - 1)]
                @obj.position.z = -@planeLen * 3

        return @obj



    getRandomInteger:( min, max ) ->
        return Math.floor( Math.random() * ( max - min + 1 ) ) + min

module.exports = Obstacle