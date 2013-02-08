Brauhaus = Brauhaus ? require '../lib/brauhaus'
assert = assert ? require 'assert'

describe 'Recipe', ->
    describe 'Extract', ->
        recipe = new Brauhaus.Recipe
            batchSize: 20.0
            boilSize: 10.0

        # Add some ingredients
        recipe.add 'fermentable',
            name: 'Pale liquid extract'
            weight: 3.5
            yield: 75.0
            color: 3.5

        recipe.add 'spice',
            name: 'Cascade hops'
            weight: 0.02835
            aa: 5.0
            use: 'boil'
            time: 60
            form: 'pellet'

        recipe.add 'spice',
            name: 'Cascade hops'
            weight: 0.014
            aa: 5.0
            use: 'boil'
            time: 10
            form: 'pellet'

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

        it 'Should calculate calories as 166 kcal', ->
            assert.equal 166, Math.round(recipe.calories)

        it 'Should calculate IBU (tinseth) as 22.0', ->
            assert.equal 22.0, recipe.ibu.toFixed(1)

    describe 'Steep', ->
        recipe = new Brauhaus.Recipe
            batchSize: 20.0
            boilSize: 10.0
            ibuMethod: 'rager'

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

        recipe.add 'spice',
            name: 'Cascade hops'
            weight: 0.02835
            aa: 5.0
            use: 'boil'
            time: 60
            form: 'pellet'

        recipe.add 'spice',
            name: 'Cascade hops'
            weight: 0.014
            aa: 5.0
            use: 'boil'
            time: 20
            form: 'pellet'

        recipe.add 'spice',
            name: 'Cascade hops'
            weight: 0.014
            aa: 5.0
            use: 'boil'
            time: 5
            form: 'pellet'

        recipe.calculate()

        it 'Should calculate OG as 1.040', ->
            assert.equal 1.040, recipe.og.toFixed(3)

        it 'Should calculate FG as 1.010', ->
            assert.equal 1.010, recipe.fg.toFixed(3)

        it 'Should calculate ABV as 3.9 %', ->
            assert.equal 3.9, recipe.abv.toFixed(1)

        it 'Should calculate color as 9.4 SRM', ->
            assert.equal 9.4, recipe.color.toFixed(1)

        it 'Should calculate calories as 130 kcal', ->
            assert.equal 130, Math.round(recipe.calories)

        it 'Should calculate IBU (rager) as 31.6', ->
            assert.equal 31.6, recipe.ibu.toFixed(1)

    describe 'Mash', ->
        recipe = new Brauhaus.Recipe
            batchSize: 20.0
            boilSize: 10.0

        # Add some ingredients
        recipe.add 'fermentable'
            name: 'Pilsner malt'
            weight: 4.5
            yield: 74.0
            color: 1.5

        recipe.add 'spice',
            name: 'Cascade hops'
            weight: 0.02835
            aa: 5.0
            use: 'boil'
            time: 45
            form: 'pellet'

        recipe.calculate()

        it 'Should calculate OG as 1.048', ->
            assert.equal 1.048, recipe.og.toFixed(3)

        it 'Should calculate FG as 1.012', ->
            assert.equal 1.012, recipe.fg.toFixed(3)

        it 'Should calculate ABV as 4.7 %', ->
            assert.equal 4.7, recipe.abv.toFixed(1)

        it 'Should calculate color as 3.0 SRM', ->
            assert.equal 3.0, recipe.color.toFixed(1)

        it 'Should calculate calories as 158 kcal', ->
            assert.equal 158, Math.round(recipe.calories)

        it 'Should calculate IBU (tinseth) as 17.5', ->
            assert.equal 17.5, recipe.ibu.toFixed(1)
