# Setting dependencies
path = require "path"

# Setting task configuration
config = 
    taskName: "data"
    extension: ".{json, xml, /*.**}"
    errorMsg: "Erro ao mover o data: <%= error.message %>"
    prefix: "**/*"
    paths:
        src: path.join __dirname, "../../../source/data/"
        dest: path.join __dirname, "../../../public/data/"
    dev:
        watch: yes
    prod: 
        watch: no

module.exports = config