{exec} = require 'child_process'

task 'build', 'Build lib from src', ->
    exec './node_modules/.bin/coffee --compile --output lib src', (err, stdout) ->
        throw err if err
        console.log stdout

task 'test', 'Run library tests', ->
    exec './node_modules/.bin/mocha --compilers coffee:coffee-script -R spec --colors', (err, stdout) ->
        throw err if err
        console.log stdout
