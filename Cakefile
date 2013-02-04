{exec} = require 'child_process'

task 'build', 'Build lib from src', ->
    exec './node_modules/.bin/coffee --compile --output lib src', (err, stdout) ->
        console.log stdout
        throw err if err

        exec './node_modules/.bin/uglifyjs --comments -o lib/brauhaus.min.js lib/brauhaus.js', (err, stdout) ->
            console.log stdout
            throw err if err

task 'test', 'Run library tests', ->
    exec './node_modules/.bin/mocha --compilers coffee:coffee-script -R spec --colors', (err, stdout) ->
        console.log stdout
        throw err if err
