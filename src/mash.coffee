###
A mash profile, which contains information about a mash along with a list
of steps to be taken.
###
class Brauhaus.Mash extends Brauhaus.OptionConstructor
    # A mapping of parameter names to object constructors
    _paramMap:
        steps: Brauhaus.MashStep

    constructor: (options) ->
        # Set default mash step list to a new empty list
        @steps = []

        super(options)

    # The mash name / description
    name: ''

    # Temperature of the grain in degrees C
    grainTemp: Brauhaus.ROOM_TEMP

    # Temperature of the sparge water in degrees C
    spargeTemp: 76

    # Target PH of the mash
    ph: null

    # Any notes useful for another brewer when mashing
    notes: ''

    # A list of steps to complete
    steps: null

    # Convert to JSON, storing only values that cannot be easily computed
    toJSON: ->
        json = {@name, @grainTemp, @spargeTemp, @ph, @notes, @steps}

    # Temperature of the grain in degrees F
    grainTempF: ->
        Brauhaus.cToF @grainTemp

    spargeTempF: ->
        Brauhaus.cToF @spargeTemp

    # Shortcut to add a step to the mash
    addStep: (options) ->
        @steps.push new Brauhaus.MashStep(options)
