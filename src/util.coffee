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
        if factor is 1 or (approximate? and count is approximate - 1)
            # Round the last item
            amount = Math.round minutes / factor
        else
            # Get the biggest whole number (e.g. 1 day)
            amount = Math.floor minutes / factor

        # Set the remaining minutes
        minutes = minutes % factor

        # Increment count of factors seen
        count++ if amount > 0 or count > 0

        if approximate? and count > approximate
            break

        if amount > 0
            durations.push "#{amount} #{label}#{('s' if amount isnt 1) ? ''}"

    durations = ['start'] if not durations.length

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

# Yield <=> Parts per gallon
Brauhaus.yieldToPpg = (yieldPercentage) ->
    yieldPercentage * 0.46214

Brauhaus.ppgToYield = (ppg) ->
    ppg * 2.16385

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
Other Utilities --------------------------------------------------------------
###

# Get the approximate time to change a volume of liquid in liters by a
# number of degrees celcius. Degrees defaults to 80 which is about
# the temperature difference between tap water and boiling.
# Input energy is set via `Brauhaus.BURNER_ENERGY` and is measured in
# kilojoules per hour. It defaults to an average stovetop burner.
Brauhaus.timeToHeat = (liters, degrees = 80) ->
    kj = 4.19 * liters * degrees
    minutes = kj / Brauhaus.BURNER_ENERGY * 60
