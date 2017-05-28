# Setting dependencies
path = require "path"

# Setting task configuration
config = 
    taskName: "image"
    extension: ".{jpg,gif,png}"
    errorMsg: "Erro ao otimizar as imagens: <%= error.message %>"
    prefix: "**/*"
    paths:
        src: path.join __dirname, "../../../source/img/"
        dest: path.join __dirname, "../../../public/img/"
    dev:
        watch: yes
    prod: 
        watch: no

module.exports = config