Brauhaus = Brauhaus ? require '../lib/brauhaus'
assert = assert ? require 'assert'

describe 'Fermentible', ->
  f = new Brauhaus.Fermentable

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

  it 'Should calculate 1kg as 2 lb, 3 oz', ->
    f.weight = 1.0
    weight = f.weightLbOz()
    assert.equal 2, parseInt(weight.lb)
    assert.equal 3, parseInt(weight.oz)

  it 'Should calculate GU of 1kg @ 75% yield as 76.4 per gallon', ->
    f.weight = 1.0
    f.yield = 75.0
    assert.equal 76.4, f.gu(Brauhaus.gallonsToLiters(1.0)).toFixed(1)

  it 'Should calculate degrees Plato of 1kg @ 75% yield as 58 per liter', ->
    f.weight = 1.0
    f.yield = 75.0
    assert.equal 58, parseInt(f.plato())

  it 'Should calculate 3.5 SRM as RGB [233, 157, 63]', ->
    f.color = 3.5
    rgb = f.colorRgb()
    assert.equal 233, rgb[0]
    assert.equal 157, rgb[1]
    assert.equal 63, rgb[2]

  it 'Should calculate 3.5 SRM as CSS rgb(233, 157, 63)', ->
    f.color = 3.5
    assert.equal 'rgb(233, 157, 63)', f.colorCss()

  it 'Should calculate 3.5 SRM as "straw"', ->
    f.color = 3.5
    assert.equal 'straw', f.colorName()

  it 'Should calculate 2.5kg "Pale liquid malt extract" as $16.50', ->
    f.name = 'Pale liquid malt extract'
    f.weight = 2.5
    assert.equal 16.5, f.price()

  it 'Should calculate 2.5kg "Light dry malt extract" as $22', ->
    f.name = 'Light dry malt extract'
    f.weight = 2.5
    assert.equal 22, f.price()

  it 'Should calculate 2.5kg "Pale malt" as $11', ->
    f.name = 'Pale malt'
    f.weight = 2.5
    assert.equal 11, f.price()
