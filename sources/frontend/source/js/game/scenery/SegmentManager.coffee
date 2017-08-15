ScenerySegment = require "./ScenerySegment.coffee" 

class SegmentManager
    first: true
    constructor:(@sceneryBaseElems, @sceneryElements, @planeW, @planeLen)->

        @segments = {
            firstSegment: new ScenerySegment(@sceneryBaseElems, @planeW, @planeLen, 0)
            secondSegment: new ScenerySegment(@sceneryBaseElems, @planeW, @planeLen, 1)
            thirdSegment: new ScenerySegment(@sceneryBaseElems, @planeW, @planeLen, 2)
        }

        # $(@).on "segment_start", @addElementsInSegment
        $(@).on "segment_update", @removeElementsInSegment

        @sceneryElements.bush.position.x = @planeW
        @sceneryElements.tree.position.x = -@planeW * .6
        @sceneryElements.plant.position.x = -@planeW * .55

        @addElementsInSegment @segments.firstSegment
        @addElementsInSegment @segments.secondSegment
        @addElementsInSegment @segments.thirdSegment

    addElementsInSegment:(_segment)=>
        for key of @sceneryElements
            _sceneryEl = @sceneryElements[key]
            # console.log "key", key
            for idx in [0...2]
                _sceneryCloneEl = _sceneryEl.clone()
                _sceneryCloneEl.position.z = Math.random() *  @planeLen - (@planeLen/2)
                # if _segment.materialDebug
                #     _sceneryCloneEl.mesh.material = _segment.materialDebug

                if key is "bush"
                    _sceneryCloneEl.position.x = @planeW * 0.55
                    if idx % 2 is 0
                        _sceneryCloneEl.position.x = -@planeW * 0.5

                if key is "tree"
                    _sceneryCloneEl.position.x = -@planeW * .6
                    if idx % 2 is 0
                        _sceneryCloneEl.position.x = @planeW * .6

                if key is "plant"
                    _sceneryCloneEl.position.x = -@planeW * .5
                    if idx % 2 is 0
                        _sceneryCloneEl.position.x = @planeW * .5

                _sceneryCloneEl.name = "random_elem"
                _segment.add _sceneryCloneEl
                _segment.elements.push _sceneryCloneEl
        
        

    removeElementsInSegment:(e, _segment)=>
        # console.log "removeElementsInSegment", _segment
        if _segment.elements.length > 0
            for el in _segment.elements
                _segment.remove el
        @addElementsInSegment _segment
        _segment.position.z = -@planeLen*2
        
    getSegments:=>
        @segments

module.exports = SegmentManager