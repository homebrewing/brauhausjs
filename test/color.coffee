Brauhaus = Brauhaus ? require '../dist/brauhaus.min'
assert = assert ? require 'assert'

describe 'Color', ->
    it 'Should convert 5 SRM to 10 EBC', ->
        assert.equal 10, Math.round Brauhaus.srmToEbc(5)

    it 'Should convert 10 EBC to 5 SRM', ->
        assert.equal 5, Math.round Brauhaus.ebcToSrm(10)

    it 'Should convert 12.7 SRM to 10 Lovibond', ->
        assert.equal 10, Math.round Brauhaus.srmToLovibond(12.7)

    it 'Should convert 10 Lovibond to 12.8 SRM', ->
        assert.equal 12.8, Brauhaus.lovibondToSrm(10).toFixed 1

    it 'Should convert -5 SRM to rgb(255, 255, 255)', ->
        assert.equal 'rgb(255, 255, 255)', Brauhaus.srmToCss(-5.0)

    it 'Should convert 3.5 SRM to rgb(233, 157, 63)', ->
        assert.equal 'rgb(233, 157, 63)', Brauhaus.srmToCss(3.5)

    it 'Should convert 8.2 SRM to rgb(207, 86, 12)', ->
        assert.equal 'rgb(207, 86, 12)', Brauhaus.srmToCss(8.2)

    it 'Should convert 250 SRM to rgb(0, 0, 0)', ->
        assert.equal 'rgb(0, 0, 0)', Brauhaus.srmToCss(250)

    it 'Should convert 1 SRM to pale straw', ->
        assert.equal 'pale straw', Brauhaus.srmToName(1.0)

    it 'Should convert 7.2 SRM to gold', ->
        assert.equal 'gold', Brauhaus.srmToName(7.2)

    it 'Should convert 25 SRM to brown', ->
        assert.equal 'brown', Brauhaus.srmToName(25)

    it 'Should convert 50 SRM to black', ->
        assert.equal 'black', Brauhaus.srmToName(50)
