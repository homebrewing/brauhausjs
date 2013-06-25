Brauhaus = Brauhaus ? require '../lib/brauhaus'
assert = assert ? require 'assert'

json = '{"name":"New Recipe","description":"Recipe description","author":"Anonymous Brewer","boilSize":10,"batchSize":20,"servingSize":0.355,"steepEfficiency":50,"steepTime":20,"mashEfficiency":75,"style":null,"ibuMethod":"tinseth","fermentables":[{"name":"Test fermentable","weight":1,"yield":75,"color":2,"late":false}],"spices":[{"name":"Test hop","weight":0.025,"aa":3.5,"use":"boil","time":60,"form":"pellet"}],"yeast":[{"name":"Test yeast","type":"ale","form":"liquid","attenuation":75}],"mash":{"name":"Test mash","grainTemp":23,"spargeTemp":76,"ph":null,"notes":"","steps":[{"name":"Test step","type":"infusion","waterRatio":3,"temp":68,"endTemp":null,"time":60,"rampTime":null}]},"bottlingTemp":0,"bottlingPressure":0,"primaryDays":14,"primaryTemp":20,"secondaryDays":0,"secondaryTemp":0,"tertiaryDays":0,"tertiaryTemp":0,"agingDays":14,"agingTemp":20}'

describe 'Recipe', ->
    describe 'Extract', ->
        recipe = new Brauhaus.Recipe
            batchSize: 20.0
            boilSize: 10.0
            secondaryDays: 5

        recipe.style =
            name: 'Saison'
            category: 'Belgian and French Ale'
            og: [1.060, 1.080]
            fg: [1.010, 1.016]
            ibu: [32, 38]
            color: [3.5, 8.5]
            abv: [4.5, 6.0]
            carb: [1.6, 2.4]

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

        recipe.add 'spice',
            name: 'Cascade hops'
            weight: 0.014
            aa: 5.0
            use: 'primary'
            time: 2880
            form: 'whole'

        recipe.add 'yeast',
            name: 'Wyeast 3724 - Belgian Saison'
            type: 'ale'
            form: 'liquid'
            attenuation: 80

        recipe.mash = new Brauhaus.Mash
            name: 'My Mash'
            ph: 5.4

        recipe.mash.addStep
            name: 'Saccharification'
            time: 60
            temp: 68
            endTemp: 60

        # Calculate recipe values like og, fg, ibu
        recipe.calculate()

        # Run tests
        it 'Should include a single dry hop step', ->
            assert.equal 1, (recipe.spices.filter (x) -> x.dry()).length

        it 'Should have a bottle count of 56', ->
            assert.equal 56, recipe.bottleCount()

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

        it 'Should calculate BU:GU as 0.44', ->
            assert.equal 0.44, recipe.buToGu.toFixed(2)

        it 'Should calculate BV as 1.01', ->
            assert.equal 1.01, recipe.bv.toFixed(2)

        it 'Should cost $31.09', ->
            assert.equal 31.09, recipe.price.toFixed(2)

        it 'Should generate a metric unit timeline', ->
            timeline = recipe.timeline()
            assert.ok timeline

        it 'Should generate an imperial unit timeline', ->
            timeline = recipe.timeline(false)
            assert.ok timeline

    describe 'Steep', ->
        recipe = new Brauhaus.Recipe
            batchSize: 20.0
            boilSize: 10.0
            ibuMethod: 'rager'

        # Add some ingredients
        recipe.add 'fermentable',
            name: 'Extra pale LME'
            weight: 2.5
            yield: 75.0
            color: 2.0

        recipe.add 'fermentable',
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

        recipe.add 'yeast',
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

        it 'Should calculate BU:GU as 0.80', ->
            assert.equal 0.80, recipe.buToGu.toFixed(2)

        it 'Should calculate BV as 1.77', ->
            assert.equal 1.77, recipe.bv.toFixed(2)

        it 'Should cost $26.69', ->
            assert.equal 26.69, recipe.price.toFixed(2)

        it 'Should generate a metric unit timeline', ->
            timeline = recipe.timeline()
            assert.ok timeline

        it 'Should generate an imperial unit timeline', ->
            timeline = recipe.timeline(false)
            assert.ok timeline

    describe 'Mash', ->
        recipe = new Brauhaus.Recipe
            batchSize: 20.0
            boilSize: 10.0

        # Add some ingredients
        recipe.add 'fermentable',
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

        recipe.add 'yeast',
            name: 'Wyeast 1728 - Scottish Ale'
            type: 'ale'
            form: 'liquid'
            attenuation: 73

        recipe.mash = new Brauhaus.Mash
            name: 'Test mash'
            ph: 5.4

        recipe.mash.addStep
            name: 'Rest'
            type: 'Infusion'
            temp: 60
            time: 30
            waterRatio: 2.75

        recipe.mash.addStep
            name: 'Saccharification'
            type: 'Temperature'
            temp: 70
            time: 60
            waterRatio: 2.75

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

        it 'Should calculate BU:GU as 0.36', ->
            assert.equal 0.36, recipe.buToGu.toFixed(2)

        it 'Should calculate BV as 0.73', ->
            assert.equal 0.73, recipe.bv.toFixed(2)

        it 'Should cost $27.30', ->
            assert.equal 27.30, recipe.price.toFixed(2)

        it 'Should generate a metric unit timeline', ->
            timeline = recipe.timeline()
            assert.ok timeline

        it 'Should generate an imperial unit timeline', ->
            timeline = recipe.timeline(false)
            assert.ok timeline

    describe 'JSON', ->
        it 'Should load a recipe from a JSON string', ->
            r = new Brauhaus.Recipe json

            assert.equal 'Test fermentable', r.fermentables[0].name
            assert.equal 2.2, r.fermentables[0].weightLb().toFixed(1)
            assert.equal 'Test hop', r.spices[0].name
            assert.equal 0.06, r.spices[0].weightLb().toFixed(2)
            assert.equal 3.5, r.yeast[0].price()
            assert.equal 73.4, r.mash.grainTempF()
            assert.equal 154.4, r.mash.steps[0].tempF()

        it 'Should convert a recipe to a JSON string', ->
            r = new Brauhaus.Recipe()

            r.add 'fermentable',
                name: 'Test fermentable'

            r.add 'hop',
                name: 'Test hop'
                aa: 3.5

            r.add 'yeast',
                name: 'Test yeast'

            r.mash = new Brauhaus.Mash
                name: 'Test mash'

            r.mash.addStep
                name: 'Test step'
                type: 'infusion'

            assert.equal json, JSON.stringify(r)
