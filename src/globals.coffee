###
@preserve
Brauhaus.js Beer Calculator
Copyright 2013 Daniel G. Taylor <danielgtaylor@gmail.com>
https://github.com/homebrewing/brauhausjs
###

# Hyperbolic tangent approximation
tanh = (number) ->
    (Math.exp(number) - Math.exp(-number)) / (Math.exp(number) + Math.exp(-number))

# Create the base module so it works in both node.js and in browsers
Brauhaus = exports? and exports or @Brauhaus = {}

###
Global constants -------------------------------------------------------------
###

# Room temperature in degrees C
Brauhaus.ROOM_TEMP = 23

# Energy output of the stovetop or gas burner in kilojoules per hour. Default
# is based on a large stovetop burner that would put out 2,500 watts.
Brauhaus.BURNER_ENERGY = 9000

# Average mash heat loss per hour in degrees C
Brauhaus.MASH_HEAT_LOSS = 5.0

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

# Relative sugar densities used to calculate volume from weights
Brauhaus.RELATIVE_SUGAR_DENSITY =
    cornSugar: 1.0
    dme: 1.62
    honey: 0.71
    sugar: 0.88
