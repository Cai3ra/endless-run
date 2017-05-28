# Setting dependencies
path = require "path"

# Setting task configuration
config = 
    taskName: "clean"
    watch: no
    paths: [path.join __dirname, "../../../public/"]

module.exports = config