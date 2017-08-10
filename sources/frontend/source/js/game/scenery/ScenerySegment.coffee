class ScenerySegment extends THREE.Group

    constructor:(@objs)->
        super()
        for key of @objs
            console.log "el", el
            el = @objs[key]
            @.add el


module.exports = ScenerySegment