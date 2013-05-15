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
            carb: [2.5, 2.8]
        'Standard American Lager':
            gu: [1.040, 1.050]
            fg: [1.004, 1.010]
            srm: [2, 4]
            ibu: [8, 15]
            abv: [4.2, 5.3]
            carb: [2.5, 2.8]
        'Premium American Lager':
            gu: [1.046, 1.056]
            fg: [1.008, 1.012]
            srm: [2, 6]
            ibu: [15, 25]
            abv: [4.6, 6]
            carb: [2.5, 2.8]
        'Munich Helles':
            gu: [1.045, 1.051]
            fg: [1.008, 1.012]
            srm: [3, 5]
            ibu: [16, 22]
            abv: [4.7, 5.4]
            carb: [2.3, 2.7]
        'Dortmunder Export':
            gu: [1.048, 1.056]
            fg: [1.010, 1.015]
            srm: [4, 6]
            ibu: [23, 30]
            abv: [4.8, 6]
            carb: [2.4, 2.7]
    'Pilsner':
        'German Pilsner (Pils)':
            gu: [1.044, 1.050]
            fg: [1.008, 1.013]
            srm: [2, 5]
            ibu: [25, 45]
            abv: [4.4, 5.2]
            carb: [2.4, 2.7]
        'Bohemian Pilsener':
            gu: [1.044, 1.056]
            fg: [1.013, 1.017]
            srm: [3.5, 6]
            ibu: [35, 45]
            abv: [4.2, 5.4]
            carb: [2.3, 2.6]
        'Classic American Pilsner':
            gu: [1.044, 1.050]
            fg: [1.010, 1.015]
            srm: [3, 6]
            ibu: [25, 40]
            abv: [4.5, 6]
            carb: [2.5, 2.7]
    'European Amber Lager':
        'Vienna Lager':
            gu: [1.046, 1.052]
            fg: [1.010, 1.014]
            srm: [10, 16]
            ibu: [18, 30]
            abv: [4.5, 5.5]
            carb: [2.4, 2.6]
        'Oktoberfest':
            gu: [1.050, 1.057]
            fg: [1.012, 1.016]
            srm: [7, 14]
            ibu: [20, 28]
            abv: [4.8, 5.7]
            carb: [2.5, 2.8]
    'Dark Lager':
        'Dark American Lager':
            gu: [1.044, 1.056]
            fg: [1.008, 1.012]
            srm: [14, 22]
            ibu: [8, 20]
            abv: [4.2, 6]
            carb: [2.5, 2.9]
        'Munich Dunkel':
            gu: [1.048, 1.056]
            fg: [1.010, 1.016]
            srm: [14, 28]
            ibu: [18, 28]
            abv: [4.5, 5.6]
            carb: [2.2, 2.7]
        'Schwarzbier':
            gu: [1.046, 1.052]
            fg: [1.010, 1.016]
            srm: [17, 30]
            ibu: [22, 32]
            abv: [4.4, 5.4]
            carb: [2.2, 2.7]
    'Bock':
        'Maibock / Helles Bock':
            gu: [1.064, 1.072]
            fg: [1.011, 1.018]
            srm: [6, 11]
            ibu: [23, 35]
            abv: [6.3, 7.4]
            carb: [2.2, 2.7]
        'Traditional Bock':
            gu: [1.064, 1.072]
            fg: [1.013, 1.019]
            srm: [14, 22]
            ibu: [20, 27]
            abv: [6.3, 7.2]
            carb: [2.2, 2.7]
        'Doppelbock':
            gu: [1.072, 1.112]
            fg: [1.016, 1.024]
            srm: [6, 25]
            ibu: [16, 26]
            abv: [7, 10]
            carb: [2.3, 2.6]
        'Eisbock':
            gu: [1.078, 1.120]
            fg: [1.020, 1.035]
            srm: [18, 30]
            ibu: [25, 35]
            abv: [9, 14]
            carb: [2.2, 2.6]
    'Light Hybrid Beer':
        'Cream Ale':
            gu: [1.042, 1.055]
            fg: [1.006, 1.012]
            srm: [2.5, 5]
            ibu: [15, 20]
            abv: [4.2, 5.6]
            carb: [2.4, 2.8]
        'Blonde Ale':
            gu: [1.038, 1.054]
            fg: [1.008, 1.013]
            srm: [3, 6]
            ibu: [15, 28]
            abv: [3.8, 5.5]
            carb: [2.4, 2.8]
        'Kölsch':
            gu: [1.044, 1.050]
            fg: [1.007, 1.011]
            srm: [3.5, 5]
            ibu: [20, 30]
            abv: [4.4, 5.2]
            carb: [2.4, 2.8]
        'American Wheat or Rye Beer':
            gu: [1.040, 1.055]
            fg: [1.008, 1.013]
            srm: [3, 6]
            ibu: [15, 30]
            abv: [4, 5.5]
            carb: [2.5, 2.9]
    'Amber Hybrid Beer':
        'Northern German Altbier':
            gu: [1.046, 1.054]
            fg: [1.010, 1.015]
            srm: [13, 19]
            ibu: [25, 40]
            abv: [4.5, 5.2]
            carb: [2.2, 2.7]
        'California Common Beer':
            gu: [1.048, 1.054]
            fg: [1.011, 1.014]
            srm: [10, 14]
            ibu: [30, 45]
            abv: [4.5, 5.5]
            carb: [2.3, 2.8]
        'Düsseldorf Altbier':
            gu: [1.046, 1.054]
            fg: [1.010, 1.015]
            srm: [11, 17]
            ibu: [35, 50]
            abv: [4.5, 5.2]
            carb: [2.1, 3.1]
    'English Pale Ale':
        'Standard / Ordinary Bitter':
            gu: [1.032, 1.040]
            fg: [1.007, 1.011]
            srm: [4, 14]
            ibu: [25, 35]
            abv: [3.2, 3.8]
            carb: [0.8, 2.2]
        'Special / Best / Premium Bitter':
            gu: [1.040, 1.048]
            fg: [1.008, 1.012]
            srm: [5, 16]
            ibu: [25, 40]
            abv: [3.8, 4.6]
            carb: [0.8, 2.1]
        'Extra Special / Strong Bitter':
            gu: [1.048, 1.060]
            fg: [1.010, 1.016]
            srm: [6, 18]
            ibu: [30, 50]
            abv: [4.6, 6.2]
            carb: [1.5, 2.4]
    'Scottish and Irish Ale':
        'Scottish Light 60/-':
            gu: [1.030, 1.035]
            fg: [1.010, 1.013]
            srm: [9, 17]
            ibu: [10, 20]
            abv: [2.5, 3.2]
            carb: [1.5, 2.3]
        'Scottish Heavy 70/-':
            gu: [1.035, 1.040]
            fg: [1.010, 1.015]
            srm: [9, 17]
            ibu: [10, 25]
            abv: [3.2, 3.9]
            carb: [1.5, 2.3]
        'Scottish Export 80/-':
            gu: [1.040, 1.054]
            fg: [1.010, 1.016]
            srm: [9, 17]
            ibu: [15, 30]
            abv: [3.9, 5.0]
            carb: [1.5, 2.3]
        'Irish Red Ale':
            gu: [1.044, 1.050]
            fg: [1.010, 1.014]
            srm: [9, 18]
            ibu: [17, 28]
            abv: [4, 6]
            carb: [2.1, 2.6]
        'Strong Scotch Ale':
            gu: [1.070, 1.130]
            fg: [1.018, 1.056]
            srm: [14, 25]
            ibu: [17, 35]
            abv: [6.5, 10]
            carb: [1.6, 2.4]
    'American Ale':
        'American Pale Ale':
            gu: [1.045, 1.060]
            fg: [1.010, 1.015]
            srm: [5, 14]
            ibu: [30, 45]
            abv: [4.5, 6.2]
            carb: [2.3, 2.8]
        'American Amber Ale':
            gu: [1.045, 1.060]
            fg: [1.010, 1.015]
            srm: [10, 17]
            ibu: [25, 40]
            abv: [4.5, 6.2]
            carb: [2.3, 2.8]
        'American Brown Ale':
            gu: [1.045, 1.060]
            fg: [1.010, 1.016]
            srm: [18, 35]
            ibu: [20, 40]
            abv: [4.3, 6.2]
            carb: [2.0, 2.6]
    'English Brown Ale':
        'Mild':
            gu: [1.030, 1.038]
            fg: [1.008, 1.013]
            srm: [12, 25]
            ibu: [10, 25]
            abv: [2.8, 4.5]
            carb: [1.3, 2.3]
        'Southern English Brown':
            gu: [1.033, 1.042]
            fg: [1.011, 1.014]
            srm: [19, 35]
            ibu: [12, 20]
            abv: [2.8, 4.1]
            carb: [1.3, 2.3]
        'Northern English Brown':
            gu: [1.040, 1.052]
            fg: [1.008, 1.013]
            srm: [12, 22]
            ibu: [20, 30]
            abv: [4.2, 5.4]
            carb: [2.2, 2.7]
    'Porter':
        'Brown Porter':
            gu: [1.040, 1.052]
            fg: [1.008, 1.014]
            srm: [20, 30]
            ibu: [18, 35]
            abv: [4, 5.4]
            carb: [1.8, 2.5]
        'Robust Porter':
            gu: [1.048, 1.065]
            fg: [1.012, 1.016]
            srm: [22, 35]
            ibu: [25, 50]
            abv: [4.8, 6.5]
            carb: [1.8, 2.5]
        'Baltic Porter':
            gu: [1.060, 1.090]
            fg: [1.016, 1.024]
            srm: [17, 30]
            ibu: [20, 40]
            abv: [5.5, 9.5]
            carb: [1.8, 2.5]
    'Stout':
        'Dry Stout':
            gu: [1.036, 1.050]
            fg: [1.007, 1.011]
            srm: [25, 40]
            ibu: [30, 45]
            abv: [4, 5]
            carb: [1.8, 2.5]
        'Sweet Stout':
            gu: [1.044, 1.060]
            fg: [1.012, 1.024]
            srm: [30, 40]
            ibu: [20, 40]
            abv: [4, 6]
            carb: [2.0, 2.4]
        'Oatmeal Stout':
            gu: [1.048, 1.065]
            fg: [1.010, 1.018]
            srm: [22, 40]
            ibu: [25, 40]
            abv: [4.2, 5.9]
            carb: [1.9, 2.5]
        'Foreign Extra Stout':
            gu: [1.056, 1.075]
            fg: [1.010, 1.018]
            srm: [30, 40]
            ibu: [30, 70]
            abv: [5.5, 8]
            carb: [2.0, 2.6]
        'American Stout':
            gu: [1.050, 1.075]
            fg: [1.010, 1.022]
            srm: [30, 40]
            ibu: [35, 75]
            abv: [5, 7]
            carb: [2.3, 2.9]
        'Russian Imperial Stout':
            gu: [1.075, 1.115]
            fg: [1.018, 1.030]
            srm: [30, 40]
            ibu: [50, 90]
            abv: [8, 12]
            carb: [1.8, 2.6]
    'India Pale Ale':
        'English IPA':
            gu: [1.050, 1.075]
            fg: [1.010, 1.018]
            srm: [8, 14]
            ibu: [40, 60]
            abv: [5, 7.5]
            carb: [2.2, 2.7]
        'American IPA':
            gu: [1.056, 10.75]
            fg: [1.010, 1.018]
            srm: [6, 15]
            ibu: [40, 70]
            abv: [5.5, 7.5]
            carb: [2.2, 2.7]
        'Imperial IPA':
            gu: [1.070, 1.090]
            fg: [1.010, 1.020]
            srm: [8, 15]
            ibu: [60, 120]
            abv: [7.5, 10]
            carb: [2.2, 2.7]
    'German Wheat and Rye Beer':
        'Weizen / Weissbier':
            gu: [1.044, 1.052]
            fg: [1.010, 1.014]
            srm: [2, 8]
            ibu: [8, 15]
            abv: [4.3, 5.6]
            carb: [2.4, 2.9]
        'Dunkelweizen':
            gu: [1.044, 1.056]
            fg: [1.010, 1.014]
            srm: [14, 23]
            ibu: [10, 18]
            abv: [4.3, 5.6]
            carb: [2.5, 2.9]
        'Weizenbock':
            gu: [1.064, 1.090]
            fg: [1.015, 1.022]
            srm: [12, 25]
            ibu: [15, 30]
            abv: [6.5, 8]
            carb: [2.4, 2.9]
        'Roggenbier (German Rye Beer)':
            gu: [1.046, 1.056]
            fg: [1.010, 1.014]
            srm: [14, 19]
            ibu: [10, 20]
            abv: [4.5, 6]
            carb: [2.5, 2.9]
    'Belgian and French Ale':
        'Witbier':
            gu: [1.044, 1.052]
            fg: [1.008, 1.012]
            srm: [2, 4]
            ibu: [10, 20]
            abv: [4.5, 5.5]
            carb: [2.1, 2.9]
        'Belgian Pale Ale':
            gu: [1.048, 1.054]
            fg: [1.010, 1.014]
            srm: [8, 14]
            ibu: [20, 30]
            abv: [4.8, 5.5]
            carb: [2.1, 2.7]
        'Saison':
            gu: [1.048, 1.065]
            fg: [1.002, 1.012]
            srm: [5, 14]
            ibu: [20, 35]
            abv: [5, 7]
            carb: [2.3, 2.9]
        'Bière de Garde':
            gu: [1.060, 1.080]
            fg: [1.008, 1.016]
            srm: [6, 19]
            ibu: [18, 28]
            abv: [6, 8.5]
            carb: [2.3, 2.9]
        'Belgian Specialty Ale':
            gu: [1.000, 1.120]
            fg: [1.000, 1.060]
            srm: [2, 40]
            ibu: [0, 120]
            abv: [0, 14]
            carb: [2.1, 2.9]
    'Sour Ale':
        'Berliner Weisse':
            gu: [1.028, 1.032]
            fg: [1.003, 1.006]
            srm: [2, 3]
            ibu: [3, 8]
            abv: [2.8, 3.8]
            carb: [2.4, 2.9]
        'Flanders Red Ale':
            gu: [1.048, 1.057]
            fg: [1.002, 1.012]
            srm: [10, 16]
            ibu: [10, 25]
            abv: [4.6, 6.5]
            carb: [2.2, 2.7]
        'Flanders Brown Ale / Oud Bruin':
            gu: [1.040, 1.074]
            fg: [1.008, 1.012]
            srm: [15, 22]
            ibu: [20, 25]
            abv: [4, 8]
            carb: [2.2, 2.8]
        'Straight (Unblended) Lambic':
            gu: [1.040, 1.054]
            fg: [1.001, 1.010]
            srm: [3, 7]
            ibu: [0, 10]
            abv: [5, 6.5]
            carb: [1.8, 2.6]
        'Gueuze':
            gu: [1.040, 1.060]
            fg: [1.000, 1.006]
            srm: [3, 7]
            ibu: [0, 10]
            abv: [5, 8]
            carb: [2.4, 3.1]
        'Fruit Lambic':
            gu: [1.040, 1.060]
            fg: [1.000, 1.010]
            srm: [3, 7]
            ibu: [0, 10]
            abv: [5, 7]
            carb: [2.4, 3.1]
    'Belgian Strong Ale':
        'Belgian Blond Ale':
            gu: [1.062, 1.075]
            fg: [1.008, 1.018]
            srm: [4, 7]
            ibu: [15, 30]
            abv: [6, 7.5]
            carb: [2.2, 2.8]
        'Belgian Dubbel':
            gu: [1.062, 1.075]
            fg: [1.008, 1.018]
            srm: [10, 17]
            ibu: [15, 25]
            abv: [6, 7.6]
            carb: [2.3, 2.9]
        'Belgian Tripel':
            gu: [1.075, 1.085]
            fg: [1.008, 1.014]
            srm: [4.5, 7]
            ibu: [20, 40]
            abv: [7.5, 9.5]
            carb: [2.4, 3.0]
        'Belgian Golden Strong Ale':
            gu: [1.070, 1.095]
            fg: [1.005, 1.016]
            srm: [3, 6]
            ibu: [22, 35]
            abv: [7.5, 10.5]
            carb: [2.3, 2.9]
        'Belgian Dark Strong Ale':
            gu: [1.075, 1.110]
            fg: [1.010, 1.024]
            srm: [12, 22]
            ibu: [20, 35]
            abv: [8, 11]
            carb: [2.3, 2.9]
    'Strong Ale':
        'Old Ale':
            gu: [1.060, 1.090]
            fg: [1.015, 1.022]
            srm: [10, 22]
            ibu: [30, 60]
            abv: [6, 9]
            carb: [1.8, 2.5]
        'English Barleywine':
            gu: [1.080, 1.120]
            fg: [1.018, 1.030]
            srm: [8, 22]
            ibu: [35, 70]
            abv: [8, 12]
            carb: [1.6, 2.5]
        'American Barleywine':
            gu: [1.080, 1.120]
            fg: [1.016, 1.030]
            srm: [10, 19]
            ibu: [50, 120]
            abv: [8, 12]
            carb: [1.8, 2.5]
    'Fruit Beer':
        'Fruit Beer':
            gu: [1.000, 1.120]
            fg: [1.000, 1.160]
            srm: [1, 40]
            ibu: [0, 120]
            abv: [0, 14]
            carb: [1.0, 4.0]
    'Spice / Herb / Vegetable Beer':
        'Spice, Herb, or Vegetable Beer':
            gu: [1.000, 1.120]
            fg: [1.000, 1.160]
            srm: [1, 40]
            ibu: [0, 120]
            abv: [0, 14]
            carb: [1.0, 4.0]
        'Christmas / Winter Specialty Spiced Beer':
            gu: [1.000, 1.120]
            fg: [1.000, 1.160]
            srm: [8, 40]
            ibu: [0, 120]
            abv: [6, 14]
            carb: [1.0, 4.0]
    'Smoke-Flavored and Wood-Aged Beer':
        'Classic Rauchbier':
            gu: [1.050, 1.056]
            fg: [1.012, 1.016]
            srm: [14, 22]
            ibu: [20, 30]
            abv: [4.8, 6]
            carb: [1.0, 4.0]
        'Other Smoked Beer':
            gu: [1.000, 1.120]
            fg: [1.000, 1.160]
            srm: [1, 40]
            ibu: [0, 120]
            abv: [0, 14]
            carb: [1.0, 4.0]
        'Wood-Aged Beer':
            gu: [1.000, 1.120]
            fg: [1.000, 1.160]
            srm: [1, 40]
            ibu: [0, 120]
            abv: [0, 14]
            carb: [1.0, 4.0]
    'Specialty Beer':
        'Specialty Beer':
            gu: [1.000, 1.120]
            fg: [1.000, 1.160]
            srm: [1, 40]
            ibu: [0, 120]
            abv: [0, 14]
            carb: [1.0, 4.0]

for own categoryName, categoryStyles of Brauhaus.STYLES
    for own styleName, style of categoryStyles
        style.name = styleName
        style.category = categoryName

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
Simple parsing functions -----------------------------------------------------
###

# Duration string to number of minutes. This will convert strings like
# '1 hour' into 60.0 or '35 min' into 35.0. Compound strings also work,
# for example '1 hour 5 minutes' will become 65.0.
Brauhaus.parseDuration = (value) ->
    duration = 0

    return value if not isNaN value

    weeks = value.match /(\d+)\s*w/i
    days = value.match /(\d+)\s*d/i
    hours = value.match /(\d+)\s*h/i
    min = value.match /(\d+)\s*m/i
    sec = value.match /(\d+)\s*s/i

    factors = [
        [weeks, 7 * 60 * 24],
        [days, 60 * 24],
        [hours, 60],
        [min, 1],
        [sec, 1.0 / 60]
    ]

    for [unit, factor] in factors
        duration += parseInt(unit[1]) * factor if unit

    return duration

# Return a human-friendly duration like '2 weeks' or '3 hours 12 minutes'
# from a number of minutes. If approximate is given, then only the two
# largest factors are included (e.g. weeks & days or days & hours) rather
# than all possible pieces. For example '1 day 2 hours 5 minutes' would
# become '1 day 2 hours'
Brauhaus.displayDuration = (minutes, approximate) ->
    durations = []

    factors = [
        ['month', 30 * 60 * 24],
        ['week', 7 * 60 * 24],
        ['day', 60 * 24],
        ['hour', 60],
        ['minute', 1]
    ]

    count = 0
    for [label, factor] in factors
        if approximate? and count is approximate - 1
            amount = Math.round minutes / factor
        else
            amount = Math.floor minutes / factor

        minutes = minutes % factor

        if amount > 0
            count++
            if approximate? and count > approximate
                break
            durations.push "#{amount} #{label}#{('s' if amount isnt 1) ? ''}"

    return durations.join ' '

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

Brauhaus.litersPerKgToQuartsPerLb = (litersPerKg) ->
    litersPerKg * 0.479305709

Brauhaus.quartsPerLbToLitersPerKg = (quartsPerLb) ->
    quartsPerLb / 0.479305709

# Celcius <=> Fahrenheit
Brauhaus.cToF = (celcius) ->
    celcius * 1.8 + 32

Brauhaus.fToC = (fahrenheit) ->
    (fahrenheit - 32) / 1.8

###
Color functions --------------------------------------------------------------
###

# Convert SRM to EBC
Brauhaus.srmToEbc = (srm) ->
    srm * 1.97

# Convert EBC to SRM
Brauhaus.ebcToSrm = (ebc) ->
    ebc * 0.508

# Convert SRM to Lovibond
Brauhaus.srmToLovibond = (srm) ->
    (srm + 0.76) / 1.3546

# Convert Lovibond to SRM
Brauhaus.lovibondToSrm = (lovibond) ->
    1.3546 * lovibond - 0.76

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
Mashing ----------------------------------------------------------------------
###

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

    # Generated description based on the type and parameters of this step
    # If siUnits is true, then use SI units (liters and kilograms), otherwise
    # use quarts per pound when describing the liquid amounts.
    description: (siUnits = true, totalGrainWeight) ->
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
                return "Infuse #{waterAmount} for #{@time} minutes at #{temp}"
            when 'Temperature'
                return "Heat to #{temp} over #{@rampTime or @time} minutes"
            when 'Decoction'
                return "Decoct and boil #{waterAmount} to reach #{temp}"
            else
                return "Unknown mash step type '#{@type}'!"

    # Water ratio in quarts / pound of grain
    waterRatioQtPerLb: ->
        Brauhaus.litersPerKgToQuartsPerLb @waterRatio

    # Step temperature in degrees F
    tempF: ->
        Brauhaus.cToF @temp

    # Step end temperature in degrees F
    endTempF: ->
        Brauhaus.cToF @endTemp

###
A mash profile, which contains information about a mash along with a list
of steps to be taken.
###
class Brauhaus.Mash extends Brauhaus.OptionConstructor
    constructor: (options) ->
        # Set default mash step list to a new empty list
        @steps = []

        super(options)

    # The mash name / description
    name: ''

    # Temperature of the grain in degrees C
    grainTemp: 23

    # Temperature of the sparge water in degrees C
    spargeTemp: 76

    # Target PH of the mash
    ph = null

    # Any notes useful for another brewer when mashing
    notes: ''

    # A list of steps to complete
    steps: null

    # Temperature of the grain in degrees F
    grainTempF: ->
        Brauhaus.cToF @grainTemp

    spargeTempF: ->
        Brauhaus.cToF @spargeTemp

    # Shortcut to add a step to the mash
    addStep: (options) ->
        @steps.push new Brauhaus.MashStep(options)

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

    style: null

    # The IBU calculation method (tinseth or rager)
    ibuMethod: 'tinseth'

    fermentables: null
    spices: null
    yeast: null

    mash: null

    og: 0.0
    fg: 0.0
    color: 0.0
    ibu: 0.0
    abv: 0.0
    price: 0.0

    # Bitterness to gravity ratio
    buToGu: 0.0
    # Balance value (http://klugscheisserbrauerei.wordpress.com/beer-balance/)
    bv: 0.0

    ogPlato: 0.0
    fgPlato: 0.0
    abw: 0.0
    realExtract: 0.0
    calories: 0.0

    bottlingTemp: 0.0
    bottlingPressure: 0.0

    primaryDays: 14.0
    primaryTemp: 20.0
    secondaryDays: 0.0
    secondaryTemp: 0.0
    tertiaryDays: 0.0
    tertiaryTemp: 0.0
    agingDays: 14
    agingTemp: 20.0

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
                    when 'primary_age'
                        recipe.primaryDays = parseFloat recipeProperty.textContent
                    when 'primary_temp'
                        recipe.primaryTemp = parseFloat recipeProperty.textContent
                    when 'secondary_age'
                        recipe.secondaryDays = parseFloat recipeProperty.textContent
                    when 'secondary_temp'
                        recipe.secondaryTemp = parseFloat recipeProperty.textContent
                    when 'tertiary_age'
                        recipe.tertiaryDays = parseFloat recipeProperty.textContent
                    when 'tertiary_temp'
                        recipe.tertiaryTemp = parseFloat recipeProperty.textContent
                    when 'carbonation'
                        recipe.bottlingPressure = parseFloat recipeProperty.textContent
                    when 'carbonation_temp'
                        recipe.bottlingTemp = parseFloat recipeProperty.textContent
                    when 'age'
                        recipe.agingDays = parseFloat recipeProperty.textContent
                    when 'age_temp'
                        recipe.agingTemp = parseFloat recipeProperty.textContent
                    when 'style'
                        recipe.style =
                            og: [1.000, 1.150]
                            fg: [1.000, 1.150]
                            ibu: [0, 150]
                            color: [0, 500]
                            abv: [0, 14]
                            carb: [1.0, 4.0]
                        for styleNode in recipeProperty.childNodes or []
                            switch styleNode.nodeName.toLowerCase()
                                when 'name'
                                    recipe.style.name = styleNode.textContent
                                when 'category'
                                    recipe.style.category = styleNode.textContent
                                when 'og_min'
                                    recipe.style.og[0] = parseFloat styleNode.textContent
                                when 'og_max'
                                    recipe.style.og[1] = parseFloat styleNode.textContent
                                when 'fg_min'
                                    recipe.style.fg[0] = parseFloat styleNode.textContent
                                when 'fg_max'
                                    recipe.style.fg[1] = parseFloat styleNode.textContent
                                when 'ibu_min'
                                    recipe.style.ibu[0] = parseFloat styleNode.textContent
                                when 'ibu_max'
                                    recipe.style.ibu[1] = parseFloat styleNode.textContent
                                when 'color_min'
                                    recipe.style.color[0] = parseFloat styleNode.textContent
                                when 'color_max'
                                    recipe.style.color[1] = parseFloat styleNode.textContent
                                when 'abv_min'
                                    recipe.style.abv[0] = parseFloat styleNode.textContent
                                when 'abv_max'
                                    recipe.style.abv[1] = parseFloat styleNode.textContent
                                when 'carb_min'
                                    recipe.style.carb[0] = parseFloat styleNode.textContent
                                when 'carb_max'
                                    recipe.style.carb[1] = parseFloat styleNode.textContent
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
                    when 'mash'
                        mash = recipe.mash = new Brauhaus.Mash()

                        for mashProperty in recipeProperty.childNodes or []
                            switch mashProperty.nodeName.toLowerCase()
                                when 'name'
                                    mash.name = mashProperty.textContent
                                when 'grain_temp'
                                    mash.grainTemp = parseFloat mashProperty.textContent
                                when 'sparge_temp'
                                    mash.spargeTemp = parseFloat mashProperty.textContent
                                when 'ph'
                                    mash.ph = parseFloat mashProperty.textContent
                                when 'notes'
                                    mash.notes = mashProperty.textContent
                                when 'mash_steps'
                                    for stepNode in mashProperty.childNodes or []
                                        if stepNode.nodeName.toLowerCase() isnt 'mash_step'
                                            continue

                                        step = new Brauhaus.MashStep()

                                        for stepProperty in stepNode.childNodes or []
                                            switch stepProperty.nodeName.toLowerCase()
                                                when 'name'
                                                    step.name = stepProperty.textContent
                                                when 'type'
                                                    step.type = stepProperty.textContent
                                                when 'infuse_amount'
                                                    step.waterRatio = parseFloat(stepProperty.textContent) / recipe.grainWeight()
                                                when 'step_temp'
                                                    step.temp = parseFloat stepProperty.textContent
                                                when 'end_temp'
                                                    step.endTemp = parseFloat stepProperty.textContent
                                                when 'step_time'
                                                    step.time = parseFloat stepProperty.textContent
                                                when 'decoction_amt'
                                                    step.waterRatio = parseFloat(stepProperty.textContent) / recipe.grainWeight()

                                        mash.steps.push step

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

    # Get the total weight of grains in kg
    grainWeight: ->
        weight = 0.0

        for fermentable in @fermentables
            weight += fermentable.weight if fermentable.type() is 'grain'

        weight

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
            if spice.aa and spice.use.toLowerCase() is 'boil'
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

        # Calculate bitterness to gravity ratios
        @buToGu = @ibu / (@og - 1.000) / 1000.0

        # http://klugscheisserbrauerei.wordpress.com/beer-balance/
        rte = (0.82 * (@fg - 1.000) + 0.18 * (@og - 1.000)) * 1000.0
        @bv = 0.8 * @ibu / rte

    toBeerXml: ->
        xml = '<?xml version="1.0" encoding="utf-8"?><recipes><recipe>'

        xml += '<version>1</version>'
        xml += "<name>#{@name}</name>"
        xml += "<brewer>#{@author}</brewer>"
        xml += "<batch_size>#{@batchSize}</batch_size>"
        xml += "<boil_size>#{@boilSize}</boil_size>"
        xml += "<efficiency>#{@mashEfficiency}</efficiency>"

        if @primaryDays
            xml += "<primary_age>#{@primaryDays}</primary_age>"
        if @primaryTemp
            xml += "<primary_temp>#{@primaryTemp}</primary_temp>"

        if @secondaryDays
            xml += "<secondary_age>#{@secondaryDays}</secondary_age>"
        if @secondaryTemp
            xml += "<secondary_temp>#{@secondaryTemp}</secondary_temp>"

        if @tertiaryDays
            xml += "<tertiary_age>#{@tertiaryDays}</tertiary_age>"
        if @tertiaryTemp
            xml += "<tertiary_temp>#{@tertiaryTemp}</tertiary_temp>"

        if @agingDays
            xml += "<age>#{@agingDays}</age>"
        if @agingTemp
            xml += "<age_temp>#{@agingTemp}</age_temp>"

        if @bottlingTemp
            xml += "<carbonation_temp>#{@bottlingTemp}</carbonation_temp>"
        if @bottlingPressure
            xml += "<carbonation>#{@bottlingPressure}</carbonation>"

        if @style
            xml += '<style><version>1</version>'
            
            xml += "<name>#{@style.name}</name>" if @style.name
            xml += "<category>#{@style.category}</category>" if @style.category
            xml += "<og_min>#{@style.og[0]}</og_min><og_max>#{@style.og[1]}</og_max>"
            xml += "<fg_min>#{@style.fg[0]}</fg_min><fg_max>#{@style.fg[1]}</fg_max>"
            xml += "<ibu_min>#{@style.ibu[0]}</ibu_min><ibu_max>#{@style.ibu[1]}</ibu_max>"
            xml += "<color_min>#{@style.color[0]}</color_min><color_max>#{@style.color[1]}</color_max>"
            xml += "<abv_min>#{@style.abv[0]}</abv_min><abv_max>#{@style.abv[1]}</abv_max>"
            xml += "<carb_min>#{@style.carb[0]}</carb_min><carb_max>#{@style.carb[1]}</carb_max>"
            xml += '</style>'

        xml += '<fermentables>'
        for fermentable in @fermentables
            xml += '<fermentable><version>1</version>'
            xml += "<name>#{ fermentable.name }</name>"
            xml += "<type>#{ fermentable.type() }</type>"
            xml += "<weight>#{ fermentable.weight.toFixed 1 }</weight>"
            xml += "<yield>#{ fermentable.yield.toFixed 1 }</yield>"
            xml += "<color>#{ fermentable.color.toFixed 1 }</color>"
            xml += '</fermentable>'
        xml += '</fermentables>'

        xml += '<hops>'
        for hop in @spices.filter((item) -> item.aa > 0)
            xml += '<hop><version>1</version>'
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
            xml += '<yeast><version>1</version>'
            xml += "<name>#{ yeast.name }</name>"
            xml += "<type>#{ yeast.type }</type>"
            xml += "<form>#{ yeast.form }</form>"
            xml += "<attenuation>#{ yeast.attenuation }</attenuation>"
            xml += '</yeast>'
        xml += '</yeasts>'

        xml += '<miscs>'
        for misc in @spices.filter((item) -> item.aa is 0)
            xml += '<misc><version>1</version>'
            xml += "<name>#{ misc.name }</name>"
            xml += "<time>#{ misc.time }</time>"
            xml += "<amount>#{ misc.weight }</amount>"
            xml += "<use>#{ misc.use }</use>"
            xml += '</misc>'
        xml += '</miscs>'

        if @mash
            xml += '<mash><version>1</version>'
            xml += "<name>#{@mash.name}</name>"
            xml += "<grain_temp>#{@mash.grainTemp}</grain_temp>"
            xml += "<sparge_temp>#{@mash.spargeTemp}</sparge_temp>"
            xml += "<ph>#{@mash.ph}</ph>"
            xml += "<notes>#{@mash.notes}</notes>"

            xml += '<mash_steps>'
            for step in @mash.steps
                xml += '<mash_step><version>1</version>'
                xml += "<name>#{step.name}</name>"
                xml += "<description>#{step.description(true, @grainWeight())}</description>"
                xml += "<step_time>#{step.time}</step_time>"
                xml += "<step_temp>#{step.temp}</step_temp>"
                xml += "<end_temp>#{step.endTemp}</end_temp>"
                xml += "<ramp_time>#{step.rampTime}</ramp_time>"

                if step.type is 'Decoction'
                    xml += "<decoction_amt>#{step.waterRatio * @grainWeight()}</decoction_amt>"
                else
                    xml += "<infuse_amount>#{step.waterRatio * @grainWeight()}</infuse_amount>"

                xml += '</mash_step>'
            xml += '</mash_steps>'

            xml += '</mash>'

        xml += '</recipe></recipes>'
