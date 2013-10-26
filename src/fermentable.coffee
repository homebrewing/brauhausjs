###
A fermentable ingredient, e.g. liquid malt extract. Each ingredient
has a name, weight in kilograms, yield as a percentage, color in
degrees SRM, and is marked as either late or normal. Late additions
affect hop utilization. Each fermentable also provides methods for
getting the type, addition, color name, and gravity units per volume
of liquid.
###
class Brauhaus.Fermentable extends Brauhaus.Ingredient
    # Regular expressions to match for steeping grains, such as caramel malts.
    # This is used to create the recipe timeline.
    @STEEP = /biscuit|black|cara|chocolate|crystal|munich|roast|special ?b|toast|victory|vienna/i

    # Regular expressions to match for boiling sugars (DME, LME, etc).
    # This is used to create the recipe timeline.
    @BOIL = /candi|candy|dme|dry|extract|honey|lme|liquid|sugar|syrup|turbinado/i

    weight: 1.0
    yield: 75.0
    color: 2.0
    late: false

    # Convert to JSON, storing only values that cannot be easily computed
    toJSON: ->
        json = {@name, @weight, @yield, @color, @late}

    # Get the type of fermentable based on its name, either extract
    # or grain (steeping / mashing)
    type: ->
        @nameRegex [
            [Brauhaus.Fermentable.BOIL, 'extract'],
            [/.*/, 'grain']
        ]

    # When is this item added in the brewing process? Boil, steep, or mash?
    addition: ->
        @nameRegex [
            # Forced values take precedence, then search known names and
            # default to mashing
            [/mash/i, 'mash'],
            [/steep/i, 'steep'],
            [/boil/i, 'boil'],
            [Brauhaus.Fermentable.BOIL, 'boil'],
            [Brauhaus.Fermentable.STEEP, 'steep'],
            [/.*/, 'mash']
        ]

    # Get the weight in pounds
    weightLb: ->
        Brauhaus.kgToLb @weight

    # Get the weight in pounds and ounces
    weightLbOz: ->
        Brauhaus.kgToLbOz @weight

    # Get the parts per gallon for this fermentable
    ppg: ->
        Brauhaus.yieldToPpg @yield

    # Get the gravity for a specific liquid volume with 100% efficiency in degrees plato
    plato: (liters = 1.0) ->
        259 - (259 / (1.0 + @gu(liters) / 1000))

    # Get the gravity units for a specific liquid volume with 100% efficiency
    gu: (liters = 1.0) ->
        # gu = parts per gallon * weight in pounds / gallons
        @ppg() * @weightLb() / Brauhaus.litersToGallons(liters)

    # Get a rgb triplet for this fermentable's color
    colorRgb: ->
        Brauhaus.srmToRgb @color

    # Get a CSS-friendly string for this fermentable's color
    colorCss: ->
        Brauhaus.srmToCss @color

    # Get a friendly human-readable color name
    colorName: ->
        Brauhaus.srmToName @color

    # Get the price for this fermentable in USD
    price: ->
        pricePerKg = @nameRegex [
            [/dry|dme/i, 8.80],
            [/liquid|lme/i, 6.60],
            [/.*/i, 4.40]
        ]

        @weight * pricePerKg
