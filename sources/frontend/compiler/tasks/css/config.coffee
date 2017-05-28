# Setting dependencies
path = require "path"

# Setting task configuration
config = 
    taskName: "css"
    extension: ".scss"
    prefix: "**/*"
    errorMsg: "Erro ao compilar o Compass: <%= error.message %>"
    changed:
        extension: ".css"
    dev:
        comments: yes
        watch: yes
        style: "expanded"
        firstPass: yes
    prod:
        comments: no
        watch: no
        style: "compressed"
        firstPass: yes
    paths:
        src: path.join __dirname, "../../../source/css/"
        dest: path.join __dirname, "../../../public/css/"
        js: path.join __dirname, "../../../public/js/"
        font: path.join __dirname, "../../../source/font/"
        image: path.join __dirname, "../../../source/img/"

module.exports = config