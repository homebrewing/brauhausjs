{Recipe} = require '../lib/spalt'

assert = require 'assert'

describe 'Recipe', ->
    describe 'Extract', ->
        recipe = new Recipe
            batchSize: 20.0
            boilSize: 10.0

        # Add some ingredients
        recipe.add 'fermentable',
            name: 'Pale liquid extract'
            weight: 3.5
            yield: 75.0
            color: 3.5

        # Calculate recipe values like og, fg, ibu
        recipe.calculate()

        # Run tests
        it 'Should calculate OG as 1.051', ->
            assert.equal 1.051, recipe.og.toFixed(3)
