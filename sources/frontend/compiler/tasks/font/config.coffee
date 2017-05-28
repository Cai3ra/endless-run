# Setting dependencies
path = require "path"

# Setting task configuration
config = 
    taskName: "font"
    extension: ".{eot,svg,ttf,woff,woff2}"
    errorMsg: "Erro ao mover as fontes: <%= error.message %>"
    prefix: "**/*"
    paths:
        src: path.join __dirname, "../../../source/fonts/"
        dest: path.join __dirname, "../../../public/fonts/"
    dev:
        watch: yes
    prod: 
        watch: no

module.exports = config