# Setting dependencies
path = require "path"

# Setting task configuration
config =
    taskName: "js"
    extension: ".{coffee,js}"
    transform: ["coffeeify"]
    extname: ".js"
    prefix:  "app-**"
    errorMsg: "Erro ao processar o JS: <%= error.message %>"
    paths:
        src: path.join __dirname, "../../../source/js/"
        dest: path.join __dirname, "../../../public/js/"
        watch: path.join __dirname, "../../../source/js/**/*"
    dev:
        watch: yes
        debug: yes
        firstPass: yes
    prod:
        watch: no
        debug: no
        firstPass: yes

module.exports = config