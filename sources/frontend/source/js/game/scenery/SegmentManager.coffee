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

    addElementsInSegment:(_segment)=>
        for key of @sceneryElements
            _sceneryEl = @sceneryElements[key]
            for idx in [0...2]
                _sceneryCloneEl = _sceneryEl.clone()
                _sceneryCloneEl.position.z = Math.random() *  _segment.position.z

                if key is "bush"
                    _sceneryCloneEl.position.x = @planeW
                    if idx % 2 is 0
                        _sceneryCloneEl.position.x = -@planeW

                if key is "tree"
                    _sceneryCloneEl.position.x = -@planeW * .6
                    if idx % 2 is 0
                        _sceneryCloneEl.position.x = @planeW * .6

                if key is "plant"
                    _sceneryCloneEl.position.x = -@planeW * .55
                    if idx % 2 is 0
                        _sceneryCloneEl.position.x = @planeW * .55

                _sceneryCloneEl.name = "random_elem"
                _segment.add _sceneryCloneEl
                _segment.elements.push _sceneryCloneEl
        
        _segment.position.z = -@planeLen

    removeElementsInSegment:(e, _segment)=>
        # console.log "removeElementsInSegment", _segment
        if _segment.elements.length > 0
            for el in _segment.elements
                _segment.remove el
        @addElementsInSegment _segment
        
    getSegments:=>
        @segments

module.exports = SegmentManager