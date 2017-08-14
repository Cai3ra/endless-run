class ScenerySegment extends THREE.Group
    elements: []
    constructor:(@objs, @planeW, @planeLen, @idx)->
        super()
        @objs.river.mesh.material = new THREE.MeshPhongMaterial( {
            color: 0x0052af,
            shininess: 100,
            envMap: window.skyboxCubeMap
        } )

        @.position.x = 0
        @.position.y = 0
        @.position.z = -@planeLen * @idx if @idx isnt 0

        console.log "ScenerySegment: ", @objs
        for key of @objs
            el = @objs[key].clone()
            if key is "wallR"
                el.position.x = @planeW
            if key is "wallL"
                el.position.x = -@planeW
                el.rotation.y = Math.PI
            @.add el

module.exports = ScenerySegment