class Runner extends THREE.Object3D

    destPos:{}

    constructor:(@mesh, @planeW, @planeLen, @padding)->
        super()

        console.log("Runner")

        material = {}

        material = new THREE.MeshLambertMaterial {
            color: 0x00FFFF
        }
        @mesh.material = material;

        @.add @mesh

        @mesh.castShadow = true
        @position.set 0, 0, 280
        @rotation.y = Math.PI
        @scale.set 0.9, 0.9, 0.9

        @destPos = @position.clone();

        console.log("Runner", @, @castShadow)

        window.addEventListener 'keydown', @updateControls
  

    updateControls:(e)=>
        if e.keyCode is 37 and @position.x isnt -( @planeW - @padding ) / 2
            @destPos.x -= ( @planeW - @padding ) / 3
        else if e.keyCode is 39 and @position.x isnt ( @planeW - @padding ) / 2
            @destPos.x += ( @planeW - @padding ) / 3


    update:()=>
        @position.x += (@destPos.x - @position.x) * 0.2

module.exports = Runner