###
A yeast ingredient, e.g. Safbrew T-58 or Brett B. Each yeast has a
type (ale, lager, other), a form (liquid, dry), and an attenuation
percentage that describes the maximum attenuation under ideal
conditions.
###
class Brauhaus.Yeast extends Brauhaus.Ingredient
    type: 'ale'
    form: 'liquid'
    attenuation: 75.0

    # Convert to JSON, storing only values that cannot be easily computed
    toJSON: ->
        json = {@name, @type, @form, @attenuation}

    # Get the price for this yeast in USD
    price: ->
        @nameRegex [
            [/wyeast|white labs|wlp/i, 7.00],
            [/.*/i, 3.50]
        ]
