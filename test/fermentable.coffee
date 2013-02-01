{Fermentable} = require '../lib/spalt'

assert = require 'assert'

describe 'Fermentible', ->
    f = new Fermentable
    
    names =
        'Light liquid malt extract': ['extract', 'boil']
        'Candi sugar': ['extract', 'boil']
        'Extra pale lme': ['extract', 'boil']
        'Foo (boil)': ['grain', 'boil']
        'Caramel 30L': ['grain', 'steep']
        'Crystal 60L': ['grain', 'steep']
        'Caramunich': ['grain', 'steep']
        'Special B': ['grain', 'steep']
        'Some other item': ['grain', 'mash']
        'Special B (mash)': ['grain', 'mash']
        'Special B (boil)': ['grain', 'boil']

    for name, data of names
        it "Should show '#{ name }' type: #{ data[0] }, addition: #{ data[1] }", do (name, data) ->
            ->
                f.name = name
                assert.equal data[0], f.type()
                assert.equal data[1], f.addition()

    it 'Should calculate GU of 1kg @ 75% yield as 76.4', ->
        f.weight = 1.0
        f.yield = 75.0
        assert.equal 76.4, f.gu().toFixed(1)

    it 'Should calculate 3.5 SRM as rgb(233, 157, 63)', ->
        f.color = 3.5
        assert.equal 'rgb(233, 157, 63)', f.colorCss()
