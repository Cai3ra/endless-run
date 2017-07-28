class Runner

    object: {}

    constructor:(@planeW, @planeLen, @padding)->
        objectGeometry = {}
        objectMaterial = {}

        objectGeometry = new THREE.CylinderGeometry 1, 1, 5, 100
        objectMaterial = new THREE.MeshLambertMaterial {
            color: 0x7f1462,
            shading: THREE.FlatShading
        }
        @object = new THREE.Mesh objectGeometry, objectMaterial
        @object.castShadow = true
        @object.position.set 0, 5, ( @planeLen / 2 )
        @object.rotation.x = 0.200

        window.addEventListener 'keydown', @updateControls
  
        return @object

    updateControls:(e)=>
        if e.keyCode is 37 and @object.position.x isnt -( @planeW - @padding ) / 2
            @object.position.x -= ( @planeW - @padding ) / 2
        else if e.keyCode is 39 and @object.position.x isnt ( @planeW - @padding ) / 2
            @object.position.x += ( @planeW - @padding ) / 2

module.exports = Runner