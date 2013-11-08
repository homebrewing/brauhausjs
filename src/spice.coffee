###
A spice ingredient, e.g. cascade hops or crushed coriander. Each spice
has a weight in kilograms, alpha acid (aa) percentage, use (mash, boil,
primary, secondary, etc), time in minutes to add the spice, and the
spice's form (whole, leaf, pellet, crushed, ground, etc).
###
class Brauhaus.Spice extends Brauhaus.Ingredient
    # Regular expressions to match for dry hopping vs. mash/boil additions
    @DRY_SPICE = /primary|secondary|dry/i

    weight: 0.025
    aa: 0.0
    use: 'boil'
    time: 60
    form: 'pellet'

    # Convert to JSON, storing only values that cannot be easily computed
    toJSON: ->
        json = {@name, @weight, @aa, @use, @time, @form}

    # True if this is an ingredient added after the boil
    dry: ->
        Brauhaus.Spice.DRY_SPICE.exec(@use) or false

    # Account for better utilization from pellets vs. whole
    utilizationFactor: ->
        if @form is 'pellet' then 1.15 else 1.0

    # Get the bitterness of this spice
    bitterness: (ibuMethod, earlyOg, batchSize) ->
        # Calculate bitterness based on chosen method
        if ibuMethod is 'tinseth'
            bitterness = 1.65 * Math.pow(0.000125, earlyOg - 1.0) * ((1 - Math.pow(Math.E, -0.04 * @time)) / 4.15) * ((@aa / 100.0 * @weight * 1000000) / batchSize) * @utilizationFactor()
        else if ibuMethod is 'rager'
            utilization = 18.11 + 13.86 * tanh((@time - 31.32) / 18.27)
            adjustment = Math.max(0, (earlyOg - 1.050) / 0.2)
            bitterness = @weight * 100 * utilization * @utilizationFactor() * @aa / (batchSize * (1 + adjustment))
        else
            throw new Error("Unknown IBU method '#{ibuMethod}'!")

        bitterness

    # Get the weight in pounds
    weightLb: ->
        Brauhaus.kgToLb @weight

    # Get the weight in pounds and ounces
    weightLbOz: ->
        Brauhaus.kgToLbOz @weight

    # Get the price for this spice in USD
    price: ->
        pricePerKg = @nameRegex [
            [/.*/i, 17.64]
        ]

        @weight * pricePerKg
