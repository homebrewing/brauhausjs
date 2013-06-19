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

# Run a command, logging output and errors. Calls `callback` if given
# which should be a function taking one argument `err`.
run = (cmd, callback) ->
    exec cmd, (err, stdout) ->
        if stdout then console.log stdout
        if err then return console.log err
        callback?(err)

task 'build', 'Build lib from src', ->
    for own key, value of compile
        do (key, value) ->
            console.log "Building lib/#{key}.js"

            files = ("src/#{filename}.coffee" for filename in value).join ' '

            run "./node_modules/coffee-script/bin/coffee -j lib/#{key}.js --compile #{files}", (err) ->
                if err then return

                console.log "Building lib/#{key}.min.js"
                run "./node_modules/uglify-js/bin/uglifyjs --comments -o dist/#{key}.min.js lib/#{key}.js"

    run './node_modules/coffee-script/bin/coffee --compile --bare test'

task 'test', 'Run library tests', ->
    run './node_modules/mocha/bin/mocha --compilers coffee:coffee-script -R spec --colors test/*.coffee', (err) ->
        if err then return

        # Run headless web browser tests on continuous integration hosts
        if process.env.CI
            run './node_modules/mocha-phantomjs/bin/mocha-phantomjs test/test.html'

task 'updateCoverage', 'Generate and push unit test code coverage info to coveralls.io', ->
    run './node_modules/istanbul/lib/cli.js cover -v ./node_modules/mocha/bin/_mocha -- test/*.js', (err) ->
        if err then return

        run './node_modules/istanbul/lib/cli.js report lcovonly', (err) ->
            if err then return

            console.log 'Trying to send coverage information to coveralls...'
            run './node_modules/coveralls/bin/coveralls.js <coverage/lcov.info'

task 'coverage', 'Determine unit test code coverage', ->
    run './node_modules/istanbul/lib/cli.js cover -v ./node_modules/mocha/bin/_mocha -- test/*.js', (err) ->
        if err then return

        run './node_modules/istanbul/lib/cli.js report html'
