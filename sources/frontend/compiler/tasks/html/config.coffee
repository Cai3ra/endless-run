# Setting dependencies
path = require "path"

# Setting task configuration
config =
    taskName: "html"
    extension: ".html"
    searchPath: path.join __dirname, "../../../bower/"
    prefix: "*"
    paths:
        src: path.join __dirname, "../../../source/html/"
        dest: path.join __dirname, "../../../public/"
        watch: path.join __dirname, "../../../source/html/**/*"
    dev:
        watch: yes
        firstPass: yes
    prod:
        watch: no
        collapseWhitespace: yes
        firstPass: yes

module.exports = config