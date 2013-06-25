###
A mash step, which contains information about a specific step during the mash
process, such as the amount of water to add, temperature to raise or lower
the mash to, etc.
###
class Brauhaus.MashStep extends Brauhaus.OptionConstructor
    # Mash step types
    @types = [
        # Infuse an amount of water into the mash
        'Infusion',
        # Modify the temperature of the mash
        'Temperature',
        # Decoct an amount of liquid to boil
        'Decoction'
    ]

    # Step name
    name: 'Saccharification'

    # The type of mash step, defined above
    type: 'Infusion'

    # Optional ratio of liquid in liters per kg of grain to either infuse
    # or decoct, depending on the `type` of the mash step.
    waterRatio: 3.0

    # Step temperature and ending temperature after the step has been
    # completed in degrees C.
    temp: 68.0
    endTemp: null

    # Total time of this step in minutes
    time: 60

    # Time to ramp up to the step temperature in minutes
    rampTime: null

    # Convert to JSON, storing only values that cannot be easily computed
    toJSON: ->
        json = {@name, @type, @waterRatio, @temp, @endTemp, @time, @rampTime}

    # Generated description based on the type and parameters of this step
    # If siUnits is true, then use SI units (liters and kilograms), otherwise
    # use quarts per pound when describing the liquid amounts.
    description: (siUnits = true, totalGrainWeight) ->
        desc = ''

        if siUnits
            absoluteUnits = 'l'
            relativeUnits = 'l per kg'
            temp = "#{@temp}C"
            waterRatio = @waterRatio
        else
            absoluteUnits = 'qt'
            relativeUnits = 'qt per lb'
            temp = "#{@tempF()}F"
            waterRatio = @waterRatioQtPerLb()

        if totalGrainWeight?
            if not siUnits
                totalGrainWeight = Brauhaus.kgToLb totalGrainWeight

            waterAmount = "#{(waterRatio * totalGrainWeight).toFixed 1}#{absoluteUnits}"
        else
            waterAmount = "#{waterRatio.toFixed 1}#{relativeUnits} of grain"

        switch @type
            when 'Infusion'
                desc = "Infuse #{waterAmount} for #{@time} minutes at #{temp}"
            when 'Temperature'
                desc = "Stop heating and hold for #{@time} minutes at #{temp}"
            when 'Decoction'
                desc = "Add #{waterAmount} boiled water to reach #{temp} and hold for #{@time} minutes"
            else
                desc = "Unknown mash step type '#{@type}'!"

        return desc

    # Water ratio in quarts / pound of grain
    waterRatioQtPerLb: ->
        Brauhaus.litersPerKgToQuartsPerLb @waterRatio

    # Step temperature in degrees F
    tempF: ->
        Brauhaus.cToF @temp

    # Step end temperature in degrees F
    endTempF: ->
        Brauhaus.cToF @endTemp
