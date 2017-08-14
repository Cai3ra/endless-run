class ObjContainer extends THREE.Object3D
    
    constructor:(@obj, name, position)->
        super()

        @name = name
        if position
            @obj.position.x = position.x
            @obj.position.y = position.y
            @obj.position.z = position.z

        # console.log "ObjContainer", @name, @position

        @obj.name = @name

        @obj.traverse ( child ) =>
            if child instanceof THREE.Mesh
                @mesh = child
                @mesh.name = @name + "_mesh"
                @obj.mesh = @mesh

        @.add @obj

    clone:=>
        # console.log(@name, "CLONE", @obj.position.clone())
        # return new ObjContainer(@obj.clone(), @name, new THREE.Vector3(@obj.position.x, @obj.position.y, @obj.position.z))
        clone = @obj.clone()
        clone.mesh = @obj.mesh
        clone

module.exports = ObjContainer