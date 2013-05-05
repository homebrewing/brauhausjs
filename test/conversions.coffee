Brauhaus = Brauhaus ? require '../lib/brauhaus'
assert = assert ? require 'assert'

describe 'Time conversions', ->
    it 'Should parse weeks into minutes', ->
        assert.equal 10080, Brauhaus.parseDuration('1w')
        assert.equal 10080, Brauhaus.parseDuration('1 w')
        assert.equal 10080, Brauhaus.parseDuration('1 week')
        assert.equal 20160, Brauhaus.parseDuration('2 weeks')

    it 'Should parse days into minutes', ->
        assert.equal 1440, Brauhaus.parseDuration('1d')
        assert.equal 1440, Brauhaus.parseDuration('1 d')
        assert.equal 1440, Brauhaus.parseDuration('1 day')
        assert.equal 2880, Brauhaus.parseDuration('2 days')

    it 'Should parse hours into minutes', ->
        assert.equal 60, Brauhaus.parseDuration('1h')
        assert.equal 60, Brauhaus.parseDuration('1 h')
        assert.equal 60, Brauhaus.parseDuration('1 hr')
        assert.equal 60, Brauhaus.parseDuration('1 hour')
        assert.equal 120, Brauhaus.parseDuration('2 hours')

    it 'Should parse minutes into minutes', ->
        assert.equal 1, Brauhaus.parseDuration('1m')
        assert.equal 1, Brauhaus.parseDuration('1 m')
        assert.equal 1, Brauhaus.parseDuration('1 min')
        assert.equal 1, Brauhaus.parseDuration('1 minute')
        assert.equal 2, Brauhaus.parseDuration('2 mins')
        assert.equal 2, Brauhaus.parseDuration('2 minutes')

    it 'Should parse no units into minutes', ->
        assert.equal 1, Brauhaus.parseDuration('1')

    it 'Should parse number into minutes', ->
        assert.equal 1, Brauhaus.parseDuration(1)

describe 'Unit conversions', ->
    it 'Should convert 1 kg to 2.2 lb', ->
        assert.equal 2.2, Brauhaus.kgToLb(1.0).toFixed(1)

    it 'Should convert 1 kg to 2 lb, 3 oz', ->
        weight = Brauhaus.kgToLbOz 1.0
        assert.equal 2, weight.lb
        assert.equal 3, parseInt(weight.oz)

    it 'Should convert 2.2 lb to 1 kg', ->
        assert.equal 1.0, Brauhaus.lbToKg(2.2).toFixed(1)

    it 'Should convert 2 lb, 3 oz to 1 kg', ->
        assert.equal 1.0, Brauhaus.lbOzToKg(2, 3).toFixed(1)

    it 'Should convert 1 liter to about 0.3 gallons', ->
        assert.equal 0.3, Brauhaus.litersToGallons(1).toFixed(1)

    it 'Should convert 0.3 gallons to about 1.1 liters', ->
        assert.equal 1.1, Brauhaus.gallonsToLiters(0.3).toFixed(1)

    it 'Should convert 3 liters per kilogram to 1.4 quarts per pound', ->
        assert.equal 1.4, Brauhaus.litersPerKgToQuartsPerLb(3).toFixed(1)

    it 'Should convert 1.5 quarts per pound to 3.1 liters per kilogram', ->
        assert.equal 3.1, Brauhaus.quartsPerLbToLitersPerKg(1.5).toFixed(1)

    it 'Should convert 68C to 154F', ->
        assert.equal 154, parseInt(Brauhaus.cToF 68)

    it 'Should convert 154.5F to 68C', ->
        assert.equal 68, parseInt(Brauhaus.fToC 154.5)
