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

        # Calculate recipe values like og, fg, ibu
        recipe.calculate()

        # Run tests
        it 'Should include a single dry hop step', ->
            assert.equal 1, (recipe.spices.filter (x) -> x.dry()).length

        it 'Should have a bottle count of 56', ->
            assert.equal 56, recipe.bottleCount()

        it 'Should have a grade of 5', ->
            assert.equal 5.0, recipe.grade()

        it 'Should calculate OG as 1.051', ->
            assert.equal 1.051, recipe.og.toFixed(3)

        it 'Should calculate FG as 1.010', ->
            assert.equal 1.010, recipe.fg.toFixed(3)

        it 'Should calculate ABV as 5.3 %', ->
            assert.equal 5.3, recipe.abv.toFixed(1)

        it 'Should calculate color as 4.6 SRM', ->
            assert.equal 4.6, recipe.color.toFixed(1)

        it 'Should calculate colorName as yellow', ->
            assert.equal 'yellow', recipe.colorName()

        it 'Should calculate calories as 165 kcal', ->
            assert.equal 165, Math.round(recipe.calories)

        it 'Should calculate IBU (tinseth) as 14.0', ->
            assert.equal 14.0, recipe.ibu.toFixed(1)

        it 'Should calculate BU:GU as 0.28', ->
            assert.equal 0.28, recipe.buToGu.toFixed(2)

        it 'Should calculate BV as 0.64', ->
            assert.equal 0.64, recipe.bv.toFixed(2)

        it 'Should cost $31.09', ->
            assert.equal 31.09, recipe.price.toFixed(2)

        it 'Should calculate priming sugar', ->
            assert.equal 0.130, recipe.primingCornSugar.toFixed(3)
            assert.equal 0.118, recipe.primingSugar.toFixed(3)
            assert.equal 0.159, recipe.primingHoney.toFixed(3)
            assert.equal 0.173, recipe.primingDme.toFixed(3)

        it 'Should generate a metric unit timeline', ->
            timeline = recipe.timeline()
            assert.ok timeline

        it 'Should generate an imperial unit timeline', ->
            timeline = recipe.timeline(false)
            assert.ok timeline

        it 'Should calculate brew day time, start and end of boil', ->
            assert.equal 21.0, recipe.boilStartTime.toFixed(1)
            assert.equal 81.0, recipe.boilEndTime.toFixed(1)
            assert.equal 101.0, recipe.brewDayDuration.toFixed(1)

        it 'Should scale without changing gravity/bitterness', ->
            recipe.scale 25, 20
            recipe.calculate()

            assert.equal 25, recipe.batchSize
            assert.equal 20, recipe.boilSize
            assert.equal 1.051, recipe.og.toFixed(3)
            assert.equal 1.010, recipe.fg.toFixed(3)
            assert.equal 14.0, recipe.ibu.toFixed(1)

    describe 'Steep', ->
        recipe = new Brauhaus.Recipe
            batchSize: 20.0
            boilSize: 10.0
            ibuMethod: 'rager'

        # Add some ingredients
        recipe.add 'fermentable',
            name: 'Extra pale LME'
            weight: 4.0
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

        it 'Should calculate OG as 1.061', ->
            assert.equal 1.061, recipe.og.toFixed(3)

        it 'Should calculate FG as 1.014', ->
            assert.equal 1.014, recipe.fg.toFixed(3)

        it 'Should calculate ABV as 6.3 %', ->
            assert.equal 6.3, recipe.abv.toFixed(1)

        it 'Should calculate color as 9.9 SRM', ->
            assert.equal 9.9, recipe.color.toFixed(1)

        it 'Should calculate calories as 200 kcal', ->
            assert.equal 200, Math.round(recipe.calories)

        it 'Should calculate IBU (rager) as 23.2', ->
            assert.equal 23.2, recipe.ibu.toFixed(1)

        it 'Should calculate BU:GU as 0.38', ->
            assert.equal 0.38, recipe.buToGu.toFixed(2)

        it 'Should calculate BV as 0.84', ->
            assert.equal 0.84, recipe.bv.toFixed(2)

        it 'Should cost $36.59', ->
            assert.equal 36.59, recipe.price.toFixed(2)

        it 'Should generate a metric unit timeline', ->
            timeline = recipe.timeline()
            assert.ok timeline

        it 'Should generate an imperial unit timeline', ->
            timeline = recipe.timeline(false)
            assert.ok timeline

        it 'Should scale without changing gravity/bitterness', ->
            recipe.scale 10, 6
            recipe.calculate()

            assert.equal 10, recipe.batchSize
            assert.equal 6, recipe.boilSize
            assert.equal 1.061, recipe.og.toFixed(3)
            assert.equal 1.014, recipe.fg.toFixed(3)
            assert.equal 23.2, recipe.ibu.toFixed(1)

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

        it 'Should calculate IBU (tinseth) as 11.4', ->
            assert.equal 11.4, recipe.ibu.toFixed(1)

        it 'Should calculate BU:GU as 0.24', ->
            assert.equal 0.24, recipe.buToGu.toFixed(2)

        it 'Should calculate BV as 0.47', ->
            assert.equal 0.47, recipe.bv.toFixed(2)

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

    describe 'Missing Mash', ->
        it 'Should calculate a timeline without error', ->
            r = new Brauhaus.Recipe json

            r.mash = undefined
            r.calculate()

            assert.ok r.timeline()
