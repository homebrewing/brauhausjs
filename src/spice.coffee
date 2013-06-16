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

    # True if this is an ingredient added after the boil
    dry: ->
        Brauhaus.Spice.DRY_SPICE.exec(@use) or false

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
