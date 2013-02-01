{srmToCss, srmToName} = require '../lib/spalt'

assert = require 'assert'

describe 'Color', ->
    it 'Should convert -5 SRM to rgb(255, 255, 255)', ->
        assert.equal 'rgb(255, 255, 255)', srmToCss(-5.0)

    it 'Should convert 3.5 SRM to rgb(233, 157, 63)', ->
        assert.equal 'rgb(233, 157, 63)', srmToCss(3.5)

    it 'Should convert 8.2 SRM to rgb(207, 86, 12)', ->
        assert.equal 'rgb(207, 86, 12)', srmToCss(8.2)

    it 'Should convert 250 SRM to rgb(0, 0, 0)', ->
        assert.equal 'rgb(0, 0, 0)', srmToCss(250)

    it 'Should convert 1 SRM to pale straw', ->
        assert.equal 'pale straw', srmToName(1.0)

    it 'Should convert 7.2 SRM to deep gold', ->
        assert.equal 'deep gold', srmToName(7.2)

    it 'Should convert 25 SRM to ruby brown', ->
        assert.equal 'ruby brown', srmToName(25)

    it 'Should convert 50 SRM to black', ->
        assert.equal 'black', srmToName(50)
