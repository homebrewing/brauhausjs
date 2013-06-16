{exec} = require 'child_process'

# Map of output filename to list of input files. The input files are
# concatenated and then compiled and minified.
compile =
    brauhaus: [
        'globals',
        'style',
        'util',
        'base',
        'fermentable',
        'spice',
        'yeast',
        'mashStep',
        'mash',
        'recipe'
    ]

task 'build', 'Build lib from src', ->
    for own key, value of compile
        console.log "Building lib/#{key}.js"

        files = ("src/#{filename}.coffee" for filename in value).join ' '

        exec "./node_modules/coffee-script/bin/coffee -j lib/#{key}.js --compile #{files}", (err, stdout) ->
            console.log stdout if stdout
            throw err if err

            exec "./node_modules/uglify-js/bin/uglifyjs --comments -o dist/#{key}.min.js lib/#{key}.js", (err, stdout) ->
                console.log stdout if stdout
                throw err if err

    exec './node_modules/coffee-script/bin/coffee --compile --bare test', (err, stdout) ->
        console.log stdout if stdout
        throw err if err

task 'test', 'Run library tests', ->
    exec './node_modules/mocha/bin/mocha --compilers coffee:coffee-script -R spec --colors test/*.coffee', (err, stdout) ->
        console.log stdout if stdout
        throw err if err

    # Run headless web browser tests on continuous integration hosts
    if process.env.CI
        exec './node_modules/mocha-phantomjs/bin/mocha-phantomjs test/test.html', (err, stdout) ->
            console.log stdout if stdout
            throw err if err

task 'updateCoverage', 'Generate and push unit test code coverage info to coveralls.io', ->
    exec './node_modules/istanbul/lib/cli.js cover -v ./node_modules/mocha/bin/_mocha -- test/*.js', (err, stdout) ->
        console.log stdout if stdout
        throw err if err

        exec './node_modules/istanbul/lib/cli.js report lcovonly', (err, stdout) ->
            console.log stdout if stdout
            throw err if err

            console.log 'Trying to send coverage information to coveralls...'
            exec './node_modules/coveralls/bin/coveralls.js <coverage/lcov.info', (err, stdout) ->
                console.log stdout if stdout
                throw err if err

task 'coverage', 'Determine unit test code coverage', ->
    exec './node_modules/istanbul/lib/cli.js cover -v ./node_modules/mocha/bin/_mocha -- test/*.js', (err, stdout) ->
        console.log stdout if stdout
        throw err if err

        exec './node_modules/istanbul/lib/cli.js report html', (err, stdout) ->
            console.log stdout if stdout
            throw err if err
