{Recipe} = require '../lib/brauhaus'

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

        it 'Should calculate FG as 1.013', ->
            assert.equal 1.013, recipe.fg.toFixed(3)

        it 'Should calculate ABV as 5.0 %', ->
            assert.equal 5.0, recipe.abv.toFixed(1)

        it 'Should calculate color as 4.6 SRM', ->
            assert.equal 4.6, recipe.color.toFixed(1)

    describe 'Steep', ->
        recipe = new Recipe
            batchSize: 20.0
            boilSize: 10.0

        # Add some ingredients
        recipe.add 'fermentable'
            name: 'Extra pale LME'
            weight: 2.5
            yield: 75.0
            color: 2.0

        recipe.add 'fermentable'
            name: 'Caramel 60L'
            weight: 0.5
            yield: 73.0
            color: 60.0

        recipe.calculate()

        it 'Should calculate OG as 1.040', ->
            assert.equal 1.040, recipe.og.toFixed(3)

        it 'Should calculate FG as 1.010', ->
            assert.equal 1.010, recipe.fg.toFixed(3)

        it 'Should calculate ABV as 3.9 %', ->
            assert.equal 3.9, recipe.abv.toFixed(1)

        it 'Should calculate color as 9.4 SRM', ->
            assert.equal 9.4, recipe.color.toFixed(1)

    describe 'Mash', ->
        recipe = new Recipe
            batchSize: 20.0
            boilSize: 10.0

        # Add some ingredients
        recipe.add 'fermentable'
            name: 'Pilsner malt'
            weight: 4.5
            yield: 74.0
            color: 1.5

        recipe.calculate()

        it 'Should calculate OG as 1.048', ->
            assert.equal 1.048, recipe.og.toFixed(3)

        it 'Should calculate FG as 1.012', ->
            assert.equal 1.012, recipe.fg.toFixed(3)

        it 'Should calculate ABV as 4.7 %', ->
            assert.equal 4.7, recipe.abv.toFixed(1)

        it 'Should calculate color as 3.0 SRM', ->
            assert.equal 3.0, recipe.color.toFixed(1)
