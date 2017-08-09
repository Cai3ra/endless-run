class Model3D extends THREE.Object3D
    
    constructor:(object, position)->
        console.log "Model3D", @
        super()

        @obj = object

        if position
            @obj.position.x = position.x
            @obj.position.y = position.y
            @obj.position.z = position.z

        @obj.traverse ( child ) =>
            if child instanceof THREE.Mesh
                # child.material.map = texture;
                @.mesh = child

        @.add @obj

    clone:=>
        @obj.clone()

module.exports = Model3D