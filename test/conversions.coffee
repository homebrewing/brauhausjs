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

    it 'Should parse start into minutes', ->
        assert.equal 0, Brauhaus.parseDuration('start')

    it 'Should parse compound durations into minutes', ->
        assert.equal 1561, Brauhaus.parseDuration('1day 2 hrs 1 m')

    it 'Should parse no units into minutes', ->
        assert.equal 1, Brauhaus.parseDuration('1')

    it 'Should parse number into minutes', ->
        assert.equal 1, Brauhaus.parseDuration(1)

    it 'Should convert minutes to display strings', ->
        assert.equal 'start', Brauhaus.displayDuration(0)
        assert.equal '1 minute', Brauhaus.displayDuration(1)
        assert.equal '2 minutes', Brauhaus.displayDuration(2)
        assert.equal '1 hour', Brauhaus.displayDuration(60)
        assert.equal '2 hours', Brauhaus.displayDuration(120)
        assert.equal '1 day', Brauhaus.displayDuration(1440)
        assert.equal '2 days', Brauhaus.displayDuration(2880)
        assert.equal '1 day 2 hours 35 minutes', Brauhaus.displayDuration(1595)

    it 'Should convert minutes to approximate strings', ->
        assert.equal '2 hours', Brauhaus.displayDuration(110, 1)
        assert.equal '1 hour 5 minutes', Brauhaus.displayDuration(64.5, 2)
        assert.equal '1 day', Brauhaus.displayDuration(1441, 2)
        assert.equal '1 day 23 hours', Brauhaus.displayDuration(2833, 2)
        assert.equal '1 week', Brauhaus.displayDuration(10080, 3)

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
