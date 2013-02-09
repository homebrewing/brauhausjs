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

        recipe.add 'yeast'
            name: 'Wyeast 3724 - Belgian Saison'
            type: 'ale'
            form: 'liquid'
            attenuation: 80

        # Calculate recipe values like og, fg, ibu
        recipe.calculate()

        # Run tests
        it 'Should calculate OG as 1.051', ->
            assert.equal 1.051, recipe.og.toFixed(3)

        it 'Should calculate FG as 1.010', ->
            assert.equal 1.010, recipe.fg.toFixed(3)

        it 'Should calculate ABV as 5.3 %', ->
            assert.equal 5.3, recipe.abv.toFixed(1)

        it 'Should calculate color as 4.6 SRM', ->
            assert.equal 4.6, recipe.color.toFixed(1)

        it 'Should calculate calories as 165 kcal', ->
            assert.equal 165, Math.round(recipe.calories)

        it 'Should calculate IBU (tinseth) as 22.0', ->
            assert.equal 22.0, recipe.ibu.toFixed(1)

        it 'Should cost $30.85', ->
            assert.equal 30.85, recipe.price.toFixed(2)

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

        recipe.add 'yeast'
            name: 'Wyeast 1214 - Belgian Abbey'
            type: 'ale'
            form: 'liquid'
            attenuation: 78

        recipe.calculate()

        it 'Should calculate OG as 1.040', ->
            assert.equal 1.040, recipe.og.toFixed(3)

        it 'Should calculate FG as 1.009', ->
            assert.equal 1.009, recipe.fg.toFixed(3)

        it 'Should calculate ABV as 4.1 %', ->
            assert.equal 4.1, recipe.abv.toFixed(1)

        it 'Should calculate color as 9.4 SRM', ->
            assert.equal 9.4, recipe.color.toFixed(1)

        it 'Should calculate calories as 129 kcal', ->
            assert.equal 129, Math.round(recipe.calories)

        it 'Should calculate IBU (rager) as 31.6', ->
            assert.equal 31.6, recipe.ibu.toFixed(1)

        it 'Should cost $26.69', ->
            assert.equal 26.69, recipe.price.toFixed(2)

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

        recipe.add 'yeast'
            name: 'Wyeast 1728 - Scottish Ale'
            type: 'ale'
            form: 'liquid'
            attenuation: 73

        recipe.calculate()

        it 'Should calculate OG as 1.048', ->
            assert.equal 1.048, recipe.og.toFixed(3)

        it 'Should calculate FG as 1.013', ->
            assert.equal 1.013, recipe.fg.toFixed(3)

        it 'Should calculate ABV as 4.6 %', ->
            assert.equal 4.6, recipe.abv.toFixed(1)

        it 'Should calculate color as 3.0 SRM', ->
            assert.equal 3.0, recipe.color.toFixed(1)

        it 'Should calculate calories as 158 kcal', ->
            assert.equal 158, Math.round(recipe.calories)

        it 'Should calculate IBU (tinseth) as 17.5', ->
            assert.equal 17.5, recipe.ibu.toFixed(1)

        it 'Should cost $27.30', ->
            assert.equal 27.30, recipe.price.toFixed(2)
