ScenerySegment = require "./ScenerySegment.coffee" 

class SegmentManager

    constructor:(@objs)->
        @scenerySegment = new ScenerySegment(@objs)

        console.log @scenerySegment

    getSegments:=>
        @scenerySegment

module.exports = SegmentManager