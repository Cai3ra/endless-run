# Setting dependencies
path = require "path"

# Setting task configuration
config = 
    taskName: "browser-sync"
    watch: no
    browser: "google chrome"
    logPrefix: "Development"
    notify: yes
    open: "local"
    reloadDelay: 2000
    port: 3000
    server:
        baseDir: path.join __dirname, "../../../public/"
        index: "index.html"

module.exports = config