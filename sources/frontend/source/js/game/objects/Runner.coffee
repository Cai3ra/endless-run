class Runner extends THREE.Object3D

    destPos:{}
    lane:0

    constructor:(@container, @planeW, @planeLen, @padding)->
        super()

        # console.log("Runner")

        material = {}

        material = new THREE.MeshLambertMaterial {
            color: 0x00FFFF
        }
        @container.mesh.material = material;

        @.add @container

        @container.mesh.castShadow = true
        @position.set 0, -1.2, 280
        @rotation.y = Math.PI
        @scale.set 0.9, 0.9, 0.9

        @destPos = @position.clone();

        @laneDistance = ( @planeW - @padding ) / 3;

        # console.log("Runner", @, @castShadow)

        window.addEventListener 'keydown', @updateControls

        stage = document.getElementById 'scene'
        mc = new Hammer stage
        mc.on "swipe", @updateControls
  

    updateControls:(e)=>
        laneDest = @lane
        if e.keyCode is 37 or e.deltaX < 0
            laneDest--
        else if e.keyCode is 39 or e.deltaX > 0
            laneDest++

        if laneDest < -1 or laneDest > 1
            return

        @lane = laneDest
        @destPos.x = @lane * @laneDistance


    update:()=>
        @position.x += (@destPos.x - @position.x) * 0.2

module.exports = Runner