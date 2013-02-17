###
@preserve
Brauhaus.js Beer Calculator
Copyright 2013 Daniel G. Taylor <danielgtaylor@gmail.com>
https://github.com/danielgtaylor/brauhausjs
###

# Import DOM parser if needed to process BeerXML input
# Works in Node.js, Chrome, Firefox, IE9+, etc
DOMParser = window?.DOMParser ? require('xmldom').DOMParser

# Hyperbolic tangent approximation
tanh = (number) ->
    (Math.exp(number) - Math.exp(-number)) / (Math.exp(number) + Math.exp(-number))

# Create the base module so it works in both node.js and in browsers
Brauhaus = exports? and exports or @Brauhaus = {}

###
Global constants -------------------------------------------------------------
###

# Friendly beer color names and their respective SRM values
Brauhaus.COLOR_NAMES = [
    [2, 'pale straw'],
    [3, 'straw'],
    [4, 'yellow'],
    [6, 'gold'],
    [9, 'amber'],
    [14, 'deep amber'],
    [17, 'copper'],
    [18, 'deep copper'],
    [22, 'brown'],
    [30, 'dark brown'],
    [35, 'very dark brown'],
    [40, 'black']
]

# List of style categories and names with valid ranges
Brauhaus.STYLES =
    'Light Lager':
        'Lite American Lager':
            gu: [1.028, 1.040]
            fg: [0.998, 1.008]
            srm: [2, 3]
            ibu: [8, 12]
            abv: [2.8, 4.2]
        'Standard American Lager':
            gu: [1.040, 1.050]
            fg: [1.004, 1.010]
            srm: [2, 4]
            ibu: [8, 15]
            abv: [4.2, 5.3]
        'Premium American Lager':
            gu: [1.046, 1.056]
            fg: [1.008, 1.012]
            srm: [2, 6]
            ibu: [15, 25]
            abv: [4.6, 6]
        'Munich Helles':
            gu: [1.045, 1.051]
            fg: [1.008, 1.012]
            srm: [3, 5]
            ibu: [16, 22]
            abv: [4.7, 5.4]
        'Dortmunder Export':
            gu: [1.048, 1.056]
            fg: [1.010, 1.015]
            srm: [4, 6]
            ibu: [23, 30]
            abv: [4.8, 6]
    'Pilsner':
        'German Pilsner (Pils)':
            gu: [1.044, 1.050]
            fg: [1.008, 1.013]
            srm: [2, 5]
            ibu: [25, 45]
            abv: [4.4, 5.2]
        'Bohemian Pilsener':
            gu: [1.044, 1.056]
            fg: [1.013, 1.017]
            srm: [3.5, 6]
            ibu: [35, 45]
            abv: [4.2, 5.4]
        'Classic American Pilsner':
            gu: [1.044, 1.050]
            fg: [1.010, 1.015]
            srm: [3, 6]
            ibu: [25, 40]
            abv: [4.5, 6]
    'European Amber Lager':
        'Vienna Lager':
            gu: [1.046, 1.052]
            fg: [1.010, 1.014]
            srm: [10, 16]
            ibu: [18, 30]
            abv: [4.5, 5.5]
        'Oktoberfest':
            gu: [1.050, 1.057]
            fg: [1.012, 1.016]
            srm: [7, 14]
            ibu: [20, 28]
            abv: [4.8, 5.7]
    'Dark Lager':
        'Dark American Lager':
            gu: [1.044, 1.056]
            fg: [1.008, 1.012]
            srm: [14, 22]
            ibu: [8, 20]
            abv: [4.2, 6]
        'Munich Dunkel':
            gu: [1.048, 1.056]
            fg: [1.010, 1.016]
            srm: [14, 28]
            ibu: [18, 28]
            abv: [4.5, 5.6]
        'Schwarzbier':
            gu: [1.046, 1.052]
            fg: [1.010, 1.016]
            srm: [17, 30]
            ibu: [22, 32]
            abv: [4.4, 5.4]
    'Bock':
        'Maibock / Helles Bock':
            gu: [1.064, 1.072]
            fg: [1.011, 1.018]
            srm: [6, 11]
            ibu: [23, 35]
            abv: [6.3, 7.4]
        'Traditional Bock':
            gu: [1.064, 1.072]
            fg: [1.013, 1.019]
            srm: [14, 22]
            ibu: [20, 27]
            abv: [6.3, 7.2]
        'Doppelbock':
            gu: [1.072, 1.112]
            fg: [1.016, 1.024]
            srm: [6, 25]
            ibu: [16, 26]
            abv: [7, 10]
        'Eisbock':
            gu: [1.078, 1.120]
            fg: [1.020, 1.035]
            srm: [18, 30]
            ibu: [25, 35]
            abv: [9, 14]
    'Light Hybrid Beer':
        'Cream Ale':
            gu: [1.042, 1.055]
            fg: [1.006, 1.012]
            srm: [2.5, 5]
            ibu: [15, 20]
            abv: [4.2, 5.6]
        'Blonde Ale':
            gu: [1.038, 1.054]
            fg: [1.008, 1.013]
            srm: [3, 6]
            ibu: [15, 28]
            abv: [3.8, 5.5]
        'Kölsch':
            gu: [1.044, 1.050]
            fg: [1.007, 1.011]
            srm: [3.5, 5]
            ibu: [20, 30]
            abv: [4.4, 5.2]
        'American Wheat or Rye Beer':
            gu: [1.040, 1.055]
            fg: [1.008, 1.013]
            srm: [3, 6]
            ibu: [15, 30]
            abv: [4, 5.5]
    'Amber Hybrid Beer':
        'Northern German Altbier':
            gu: [1.046, 1.054]
            fg: [1.010, 1.015]
            srm: [13, 19]
            ibu: [25, 40]
            abv: [4.5, 5.2]
        'California Common Beer':
            gu: [1.048, 1.054]
            fg: [1.011, 1.014]
            srm: [10, 14]
            ibu: [30, 45]
            abv: [4.5, 5.5]
        'Düsseldorf Altbier':
            gu: [1.046, 1.054]
            fg: [1.010, 1.015]
            srm: [11, 17]
            ibu: [35, 50]
            abv: [4.5, 5.2]
    'English Pale Ale':
        'Standard / Ordinary Bitter':
            gu: [1.032, 1.040]
            fg: [1.007, 1.011]
            srm: [4, 14]
            ibu: [25, 35]
            abv: [3.2, 3.8]
        'Special / Best / Premium Bitter':
            gu: [1.040, 1.048]
            fg: [1.008, 1.012]
            srm: [5, 16]
            ibu: [25, 40]
            abv: [3.8, 4.6]
        'Extra Special / Strong Bitter':
            gu: [1.048, 1.060]
            fg: [1.010, 1.016]
            srm: [6, 18]
            ibu: [30, 50]
            abv: [4.6, 6.2]
    'Scottish and Irish Ale':
        'Scottish Light 60/-':
            gu: [1.030, 1.035]
            fg: [1.010, 1.013]
            srm: [9, 17]
            ibu: [10, 20]
            abv: [2.5, 3.2]
        'Scottish Heavy 70/-':
            gu: [1.035, 1.040]
            fg: [1.010, 1.015]
            srm: [9, 17]
            ibu: [10, 25]
            abv: [3.2, 3.9]
        'Scottish Export 80/-':
            gu: [1.040, 1.054]
            fg: [1.010, 1.016]
            srm: [9, 17]
            ibu: [15, 30]
            abv: [3.9, 5.0]
        'Irish Red Ale':
            gu: [1.044, 1.050]
            fg: [1.010, 1.014]
            srm: [9, 18]
            ibu: [17, 28]
            abv: [4, 6]
        'Strong Scotch Ale':
            gu: [1.070, 1.130]
            fg: [1.018, 1.056]
            srm: [14, 25]
            ibu: [17, 35]
            abv: [6.5, 10]
    'American Ale':
        'American Pale Ale':
            gu: [1.045, 1.060]
            fg: [1.010, 1.015]
            srm: [5, 14]
            ibu: [30, 45]
            abv: [4.5, 6.2]
        'American Amber Ale':
            gu: [1.045, 1.060]
            fg: [1.010, 1.015]
            srm: [10, 17]
            ibu: [25, 40]
            abv: [4.5, 6.2]
        'American Brown Ale':
            gu: [1.045, 1.060]
            fg: [1.010, 1.016]
            srm: [18, 35]
            ibu: [20, 40]
            abv: [4.3, 6.2]
    'English Brown Ale':
        'Mild':
            gu: [1.030, 1.038]
            fg: [1.008, 1.013]
            srm: [12, 25]
            ibu: [10, 25]
            abv: [2.8, 4.5]
        'Southern English Brown':
            gu: [1.033, 1.042]
            fg: [1.011, 1.014]
            srm: [19, 35]
            ibu: [12, 20]
            abv: [2.8, 4.1]
        'Northern English Brown':
            gu: [1.040, 1.052]
            fg: [1.008, 1.013]
            srm: [12, 22]
            ibu: [20, 30]
            abv: [4.2, 5.4]
    'Porter':
        'Brown Porter':
            gu: [1.040, 1.052]
            fg: [1.008, 1.014]
            srm: [20, 30]
            ibu: [18, 35]
            abv: [4, 5.4]
        'Robust Porter':
            gu: [1.048, 1.065]
            fg: [1.012, 1.016]
            srm: [22, 35]
            ibu: [25, 50]
            abv: [4.8, 6.5]
        'Baltic Porter':
            gu: [1.060, 1.090]
            fg: [1.016, 1.024]
            srm: [17, 30]
            ibu: [20, 40]
            abv: [5.5, 9.5]
    'Stout':
        'Dry Stout':
            gu: [1.036, 1.050]
            fg: [1.007, 1.011]
            srm: [25, 40]
            ibu: [30, 45]
            abv: [4, 5]
        'Sweet Stout':
            gu: [1.044, 1.060]
            fg: [1.012, 1.024]
            srm: [30, 40]
            ibu: [20, 40]
            abv: [4, 6]
        'Oatmeal Stout':
            gu: [1.048, 1.065]
            fg: [1.010, 1.018]
            srm: [22, 40]
            ibu: [25, 40]
            abv: [4.2, 5.9]
        'Foreign Extra Stout':
            gu: [1.056, 1.075]
            fg: [1.010, 1.018]
            srm: [30, 40]
            ibu: [30, 70]
            abv: [5.5, 8]
        'American Stout':
            gu: [1.050, 1.075]
            fg: [1.010, 1.022]
            srm: [30, 40]
            ibu: [35, 75]
            abv: [5, 7]
        'Russian Imperial Stout':
            gu: [1.075, 1.115]
            fg: [1.018, 1.030]
            srm: [30, 40]
            ibu: [50, 90]
            abv: [8, 12]
    'India Pale Ale':
        'English IPA':
            gu: [1.050, 1.075]
            fg: [1.010, 1.018]
            srm: [8, 14]
            ibu: [40, 60]
            abv: [5, 7.5]
        'American IPA':
            gu: [1.056, 10.75]
            fg: [1.010, 1.018]
            srm: [6, 15]
            ibu: [40, 70]
            abv: [5.5, 7.5]
        'Imperial IPA':
            gu: [1.070, 1.090]
            fg: [1.010, 1.020]
            srm: [8, 15]
            ibu: [60, 120]
            abv: [7.5, 10]
    'German Wheat and Rye Beer':
        'Weizen / Weissbier':
            gu: [1.044, 1.052]
            fg: [1.010, 1.014]
            srm: [2, 8]
            ibu: [8, 15]
            abv: [4.3, 5.6]
        'Dunkelweizen':
            gu: [1.044, 1.056]
            fg: [1.010, 1.014]
            srm: [14, 23]
            ibu: [10, 18]
            abv: [4.3, 5.6]
        'Weizenbock':
            gu: [1.064, 1.090]
            fg: [1.015, 1.022]
            srm: [12, 25]
            ibu: [15, 30]
            abv: [6.5, 8]
        'Roggenbier (German Rye Beer)':
            gu: [1.046, 1.056]
            fg: [1.010, 1.014]
            srm: [14, 19]
            ibu: [10, 20]
            abv: [4.5, 6]
    'Belgian and French Ale':
        'Witbier':
            gu: [1.044, 1.052]
            fg: [1.008, 1.012]
            srm: [2, 4]
            ibu: [10, 20]
            abv: [4.5, 5.5]
        'Belgian Pale Ale':
            gu: [1.048, 1.054]
            fg: [1.010, 1.014]
            srm: [8, 14]
            ibu: [20, 30]
            abv: [4.8, 5.5]
        'Saison':
            gu: [1.048, 1.065]
            fg: [1.002, 1.012]
            srm: [5, 14]
            ibu: [20, 35]
            abv: [5, 7]
        'Bière de Garde':
            gu: [1.060, 1.080]
            fg: [1.008, 1.016]
            srm: [6, 19]
            ibu: [18, 28]
            abv: [6, 8.5]
        'Belgian Specialty Ale':
            gu: [1.000, 1.120]
            fg: [1.000, 1.060]
            srm: [2, 40]
            ibu: [0, 120]
            abv: [0, 14]
    'Sour Ale':
        'Berliner Weisse':
            gu: [1.028, 1.032]
            fg: [1.003, 1.006]
            srm: [2, 3]
            ibu: [3, 8]
            abv: [2.8, 3.8]
        'Flanders Red Ale':
            gu: [1.048, 1.057]
            fg: [1.002, 1.012]
            srm: [10, 16]
            ibu: [10, 25]
            abv: [4.6, 6.5]
        'Flanders Brown Ale / Oud Bruin':
            gu: [1.040, 1.074]
            fg: [1.008, 1.012]
            srm: [15, 22]
            ibu: [20, 25]
            abv: [4, 8]
        'Straight (Unblended) Lambic':
            gu: [1.040, 1.054]
            fg: [1.001, 1.010]
            srm: [3, 7]
            ibu: [0, 10]
            abv: [5, 6.5]
        'Gueuze':
            gu: [1.040, 1.060]
            fg: [1.000, 1.006]
            srm: [3, 7]
            ibu: [0, 10]
            abv: [5, 8]
        'Fruit Lambic':
            gu: [1.040, 1.060]
            fg: [1.000, 1.010]
            srm: [3, 7]
            ibu: [0, 10]
            abv: [5, 7]
    'Belgian Strong Ale':
        'Belgian Blond Ale':
            gu: [1.062, 1.075]
            fg: [1.008, 1.018]
            srm: [4, 7]
            ibu: [15, 30]
            abv: [6, 7.5]
        'Belgian Dubbel':
            gu: [1.062, 1.075]
            fg: [1.008, 1.018]
            srm: [10, 17]
            ibu: [15, 25]
            abv: [6, 7.6]
        'Belgian Tripel':
            gu: [1.075, 1.085]
            fg: [1.008, 1.014]
            srm: [4.5, 7]
            ibu: [20, 40]
            abv: [7.5, 9.5]
        'Belgian Golden Strong Ale':
            gu: [1.070, 1.095]
            fg: [1.005, 1.016]
            srm: [3, 6]
            ibu: [22, 35]
            abv: [7.5, 10.5]
        'Belgian Dark Strong Ale':
            gu: [1.075, 1.110]
            fg: [1.010, 1.024]
            srm: [12, 22]
            ibu: [20, 35]
            abv: [8, 11]
    'Strong Ale':
        'Old Ale':
            gu: [1.060, 1.090]
            fg: [1.015, 1.022]
            srm: [10, 22]
            ibu: [30, 60]
            abv: [6, 9]
        'English Barleywine':
            gu: [1.080, 1.120]
            fg: [1.018, 1.030]
            srm: [8, 22]
            ibu: [35, 70]
            abv: [8, 12]
        'American Barleywine':
            gu: [1.080, 1.120]
            fg: [1.016, 1.030]
            srm: [10, 19]
            ibu: [50, 120]
            abv: [8, 12]
    'Fruit Beer':
        'Fruit Beer':
            gu: [1.000, 1.120]
            fg: [1.000, 1.160]
            srm: [1, 40]
            ibu: [0, 120]
            abv: [0, 14]
    'Spice / Herb / Vegetable Beer':
        'Spice, Herb, or Vegetable Beer':
            gu: [1.000, 1.120]
            fg: [1.000, 1.160]
            srm: [1, 40]
            ibu: [0, 120]
            abv: [0, 14]
        'Christmas / Winter Specialty Spiced Beer':
            gu: [1.000, 1.120]
            fg: [1.000, 1.160]
            srm: [8, 40]
            ibu: [0, 120]
            abv: [6, 14]
    'Smoke-Flavored and Wood-Aged Beer':
        'Classic Rauchbier':
            gu: [1.050, 1.056]
            fg: [1.012, 1.016]
            srm: [14, 22]
            ibu: [20, 30]
            abv: [4.8, 6]
        'Other Smoked Beer':
            gu: [1.000, 1.120]
            fg: [1.000, 1.160]
            srm: [1, 40]
            ibu: [0, 120]
            abv: [0, 14]
        'Wood-Aged Beer':
            gu: [1.000, 1.120]
            fg: [1.000, 1.160]
            srm: [1, 40]
            ibu: [0, 120]
            abv: [0, 14]
    'Specialty Beer':
        'Specialty Beer':
            gu: [1.000, 1.120]
            fg: [1.000, 1.160]
            srm: [1, 40]
            ibu: [0, 120]
            abv: [0, 14]

###
Style functions --------------------------------------------------------------
###

# Get a list of categories for style information
Brauhaus.getStyleCategories = ->
    categories = []

    for own key, value of Brauhaus.STYLES
        categories.push key

    return categories

# Get a list of styles for a specific category
Brauhaus.getStyles = (category) ->
    styles = []

    for own key, value of Brauhaus.STYLES[category]
        styles.push key

    return styles

# Get a style from a category and name
Brauhaus.getStyle = (category, name) ->
    return Brauhaus.STYLES[category][name]

###
Conversion functions ---------------------------------------------------------
###

# Kilograms <=> pounds
Brauhaus.kgToLb = (kg) ->
    kg * 2.20462

Brauhaus.lbToKg = (lb) ->
    lb / 2.20462

# Kilograms <=> pounds/ounces
Brauhaus.kgToLbOz = (kg) ->
    lb = Brauhaus.kgToLb kg

    # Returns an anonymous object with lb and oz properties
    { lb: Math.floor(lb), oz: (lb - Math.floor(lb)) * 16.0 }

Brauhaus.lbOzToKg = (lb, oz) ->
    Brauhaus.lbToKg lb + (oz / 16.0)

# Liters <=> gallons
Brauhaus.litersToGallons = (liters) ->
    liters * 0.264172

Brauhaus.gallonsToLiters = (gallons) ->
    gallons / 0.264172

# Celcius <=> Fahrenheit
Brauhaus.cToF = (celcius) ->
    celcius * 1.8 + 32

Brauhaus.fToC = (fahrenheit) ->
    (fahrenheit - 32) / 1.8

###
Color functions --------------------------------------------------------------
###

# Convert SRM color values to [r, g, b] triplets
Brauhaus.srmToRgb = (srm) ->
    r = Math.round(Math.min(255, Math.max(0, 255 * Math.pow(0.975, srm))))
    g = Math.round(Math.min(255, Math.max(0, 245 * Math.pow(0.88, srm))))
    b = Math.round(Math.min(255, Math.max(0, 220 * Math.pow(0.7, srm))))
    
    [r, g, b]

# Convert SRM color values to CSS-friendly strings
Brauhaus.srmToCss = (srm) ->
    [r, g, b] = Brauhaus.srmToRgb srm
    "rgb(#{ r }, #{ g }, #{ b })"

# Convert SRM color values into friendly names
Brauhaus.srmToName = (srm) ->
    color = Brauhaus.COLOR_NAMES[0][1]

    for item in Brauhaus.COLOR_NAMES
        color = item[1] if item[0] <= srm

    color

###
Base objects -----------------------------------------------------------------
###

# A base class which sets passed options as properties on itself.
class Brauhaus.OptionConstructor
    constructor: (options) ->
        # Set any properties passed in
        for own property of options
            @[property] = options[property]

###
Base class for new recipe ingredients. Each ingredient gets a name,
which defaults to 'New ' + the class name. For classes that inherit
Ingredient it will use their name, e.g:
###
class Brauhaus.Ingredient extends Brauhaus.OptionConstructor
    constructor: (options) ->
        # Set default name based on the class name
        @name = 'New ' + @constructor.name

        super(options)

    # Check if a regex or list of regexes matches the name, returning
    # either true/false or a value if the list has two items
    nameRegex: (regex) ->
        result = false

        if typeof regex is 'string'
            result = regex.exec(@name)
        else
            for item in regex
                if Array.isArray(item) and item.length is 2
                    if item[0].exec(@name)
                        result = item[1]
                        break
                else if typeof item is 'string'
                    result = item.exec(@name)
                else
                    throw 'Invalid regex input!'

        result

###
Ingredients ------------------------------------------------------------------
###

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
        @yield * 0.46214

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

###
A spice ingredient, e.g. cascade hops or crushed coriander. Each spice
has a weight in kilograms, alpha acid (aa) percentage, use (mash, boil,
primary, secondary, etc), time in minutes to add the spice, and the
spice's form (whole, leaf, pellet, crushed, ground, etc).
###
class Brauhaus.Spice extends Brauhaus.Ingredient
    weight: 0.025
    aa: 0.0
    use: 'boil'
    time: 60
    form: 'pellet'

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

    # Get the price for this yeast in USD
    price: ->
        @nameRegex [
            [/wyeast|white labs|wlp/i, 7.00],
            [/.*/i, 3.50]
        ]

###
Recipe -----------------------------------------------------------------------
###

###
A beer recipe, consisting of various ingredients and metadata which
provides a calculate() method to calculate OG, FG, IBU, ABV, and a
timeline of instructions for brewing the recipe.
###
class Brauhaus.Recipe extends Brauhaus.OptionConstructor
    name: 'New Recipe'
    description: 'Recipe description'
    author: 'Anonymous Brewer'
    boilSize: 10.0
    batchSize: 20.0
    servingSize: 0.355

    steepEfficiency: 50
    mashEfficiency: 75

    style = null

    # The IBU calculation method (tinseth or rager)
    ibuMethod: 'tinseth'

    fermentables: null
    spices: null
    yeast: null

    og: 0.0
    fg: 0.0
    color: 0.0
    ibu: 0.0
    abv: 0.0
    price: 0.0

    ogPlato: 0.0
    fgPlato: 0.0
    abw: 0.0
    realExtract: 0.0
    calories: 0.0

    # Get a list of parsed recipes from BeerXML input
    @fromBeerXml: (xml) ->
        recipes = []
        parser = new DOMParser()
        doc = parser.parseFromString xml, 'text/xml'
        
        for recipeNode in doc.documentElement.childNodes or []
            if recipeNode.nodeName.toLowerCase() isnt 'recipe'
                continue

            recipe = new Brauhaus.Recipe()

            for recipeProperty in recipeNode.childNodes or []
                switch recipeProperty.nodeName.toLowerCase()
                    when 'name'
                        recipe.name = recipeProperty.textContent
                    when 'brewer'
                        recipe.author = recipeProperty.textContent
                    when 'batch_size'
                        recipe.batchSize = parseFloat recipeProperty.textContent
                    when 'boil_size'
                        recipe.boilSize = parseFloat recipeProperty.textContent
                    when 'efficiency'
                        recipe.mashEfficiency = parseFloat recipeProperty.textContent
                    when 'fermentables'
                        for fermentableNode in recipeProperty.childNodes or []
                            if fermentableNode.nodeName.toLowerCase() isnt 'fermentable'
                                continue

                            fermentable = new Brauhaus.Fermentable()

                            for fermentableProperty in fermentableNode.childNodes or []
                                switch fermentableProperty.nodeName.toLowerCase()
                                    when 'name'
                                        fermentable.name = fermentableProperty.textContent
                                    when 'amount'
                                        fermentable.weight = parseFloat fermentableProperty.textContent
                                    when 'yield'
                                        fermentable.yield = parseFloat fermentableProperty.textContent
                                    when 'color'
                                        fermentable.color = parseFloat fermentableProperty.textContent
                                    when 'add_after_boil'
                                        fermentable.late = fermentableProperty.textContent.toLowerCase() == 'true'

                            recipe.fermentables.push fermentable
                    when 'hops', 'miscs'
                        for spiceNode in recipeProperty.childNodes or []
                            if spiceNode.nodeName.toLowerCase() not in ['hop', 'misc']
                                continue

                            spice = new Brauhaus.Spice()

                            for spiceProperty in spiceNode.childNodes or []
                                switch spiceProperty.nodeName.toLowerCase()
                                    when 'name'
                                        spice.name = spiceProperty.textContent
                                    when 'amount'
                                        spice.weight = parseFloat spiceProperty.textContent
                                    when 'alpha'
                                        spice.aa = parseFloat spiceProperty.textContent
                                    when 'use'
                                        spice.use = spiceProperty.textContent
                                    when 'form'
                                        spice.form = spiceProperty.textContent

                            recipe.spices.push spice
                    when 'yeasts'
                        for yeastNode in recipeProperty.childNodes or []
                            if yeastNode.nodeName.toLowerCase() isnt 'yeast'
                                continue

                            yeast = new Brauhaus.Yeast()

                            for yeastProperty in yeastNode.childNodes or []
                                switch yeastProperty.nodeName.toLowerCase()
                                    when 'name'
                                        yeast.name = yeastProperty.textContent
                                    when 'type'
                                        yeast.type = yeastProperty.textContent
                                    when 'form'
                                        yeast.form = yeastProperty.textContent
                                    when 'attenuation'
                                        yeast.attenuation = parseFloat yeastProperty.textContent

                            recipe.yeast.push yeast

            recipes.push recipe

        recipes

    constructor: (options) ->
        @fermentables = []
        @spices = []
        @yeast = []

        super(options)

    # Get the batch size in gallons
    batchSizeGallons: ->
        Brauhaus.litersToGallons @batchSize

    # Get the boil size in gallons
    boilSizeGallons: ->
        Brauhaus.litersToGallons @boilSize

    add: (type, values) ->
        if type is 'fermentable'
            @fermentables.push new Brauhaus.Fermentable(values)
        else if type is 'spice'
            @spices.push new Brauhaus.Spice(values)
        else if type is 'yeast'
            @yeast.push new Brauhaus.Yeast(values)

    calculate: ->
        @og = 1.0
        @fg = 0.0
        @ibu = 0.0
        @price = 0.0

        earlyOg = 1.0
        mcu = 0.0
        attenuation = 0.0
        
        # Calculate gravities and color from fermentables
        for fermentable in @fermentables
            efficiency = 1.0
            addition = fermentable.addition()
            if addition is 'steep'
                efficiency = @steepEfficiency / 100.0
            else if addition is 'mash'
                efficiency = @mashEfficiency / 100.0

            mcu += fermentable.color * fermentable.weightLb() / @batchSizeGallons()

            # Update gravities
            gravity = fermentable.gu(@batchSize) * efficiency / 1000.0
            @og += gravity

            if not fermentable.late
                earlyOg += gravity

            # Update recipe price with fermentable
            @price += fermentable.price()

        @color = 1.4922 * Math.pow(mcu, 0.6859)

        # Get attenuation for final gravity
        for yeast in @yeast
            attenuation = yeast.attenuation if yeast.attenuation > attenuation

            # Update recipe price with yeast
            @price += yeast.price()

        attenuation = 75.0 if attenuation is 0

        # Update final gravity based on original gravity and maximum
        # attenuation from yeast.
        @fg = @og - ((@og - 1.0) * attenuation / 100.0)

        # Update alcohol by volume based on original and final gravity
        @abv = ((1.05 * (@og - @fg)) / @fg) / 0.79 * 100.0

        # Gravity degrees plato approximations
        @ogPlato = (-463.37) + (668.72 * @og) - (205.35 * (@og * @og))
        @fgPlato = (-463.37) + (668.72 * @fg) - (205.35 * (@fg * @fg))

        # Update calories
        @realExtract = (0.1808 * @ogPlato) + (0.8192 * @fgPlato)
        @abw = 0.79 * @abv / @fg
        @calories = Math.max(0, ((6.9 * @abw) + 4.0 * (@realExtract - 0.10)) * @fg * @servingSize * 10)

        # Calculate bitterness
        for spice in @spices
            bitterness = 0.0
            if spice.aa and spice.use is 'boil'
                # Account for better utilization from pellets vs. whole
                utilizationFactor = 1.0
                if spice.form is 'pellet'
                    utilizationFactor = 1.15

                # Calculate bitterness based on chosen method
                if @ibuMethod is 'tinseth'
                    bitterness = 1.65 * Math.pow(0.000125, earlyOg - 1.0) * ((1 - Math.pow(Math.E, -0.04 * spice.time)) / 4.15) * ((spice.aa / 100.0 * spice.weight * 1000000) / @batchSize) * utilizationFactor
                    @ibu += bitterness
                else if @ibuMethod is 'rager'
                    utilization = 18.11 + 13.86 * tanh((spice.time - 31.32) / 18.27)
                    adjustment = Math.max(0, (earlyOg - 1.050) / 0.2)
                    bitterness = spice.weight * 100 * utilization * utilizationFactor * spice.aa / (@batchSize * (1 + adjustment))
                    @ibu += bitterness
                else
                    throw "Unknown IBU method '#{@ibuMethod}'!"

            # Update recipe price with spice
            @price += spice.price()

    toBeerXml: ->
        xml = '<?xml version="1.0" encoding="utf-8"?><recipes><recipe>'

        xml += '<version>1</version>'
        xml += "<name>#{@name}</name>"
        xml += "<brewer>#{@author}</brewer>"
        xml += "<batch_size>#{@batchSize}</batch_size>"
        xml += "<boil_size>#{@boilSize}</boil_size>"
        xml += "<efficiency>#{@mashEfficiency}</efficiency>"

        xml += '<fermentables>'
        for fermentable in @fermentables
            xml += '<fermentable><version>1</version>'
            xml += "<name>#{ fermentable.name }</name>"
            xml += "<type>#{ fermentable.type() }</name>"
            xml += "<weight>#{ fermentable.weight.toFixed 1 }</weight>"
            xml += "<yield>#{ fermentable.yield.toFixed 1 }</yield>"
            xml += "<color>#{ fermentable.color.toFixed 1 }</color>"
            xml += '</fermentable>'
        xml += '</fermentables>'

        xml += '<hops>'
        for hop in @spices.filter((item) -> item.aa > 0)
            xml += '<hop>'
            xml += "<name>#{ hop.name }</name>"
            xml += "<time>#{ hop.time }</time>"
            xml += "<amount>#{ hop.weight }</amount>"
            xml += "<alpha>#{ hop.aa.toFixed 2 }</alpha>"
            xml += "<use>#{ hop.use }</use>"
            xml += "<form>#{ hop.form }</form>"
            xml += '</hop>'
        xml += '</hops>'

        xml += '<yeasts>'
        for yeast in @yeast
            xml += '<yeast>'
            xml += "<name>#{ yeast.name }</name>"
            xml += "<type>#{ yeast.type }</type>"
            xml += "<form>#{ yeast.form }</form>"
            xml += "<attenuation>#{ yeast.attenuation }</attenuation>"
            xml += '</yeast>'
        xml += '</yeasts>'

        xml += '<miscs>'
        for misc in @spices.filter((item) -> item.aa is 0)
            xml += '<misc>'
            xml += "<name>#{ misc.name }</name>"
            xml += "<time>#{ misc.time }</time>"
            xml += "<amount>#{ misc.weight }</amount>"
            xml += "<use>#{ misc.use }</use>"
            xml += '</misc>'
        xml += '</miscs>'

        xml += '</recipe></recipes>'
