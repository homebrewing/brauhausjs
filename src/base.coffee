###
Base objects -----------------------------------------------------------------
###

# A base class which sets passed options as properties on itself.
class Brauhaus.OptionConstructor
    # A mapping of parameter names to objects. When an option is encountered
    # with a matching param name, it is instantiated as that object if it
    # is not already an instance of the object. If it is an array, then each
    # item in the array is instantiated or copied.
    _paramMap: {}

    constructor: (options) ->
        # Convert JSON strings to objects
        if typeof options is 'string'
            options = JSON.parse options

        # Set any properties passed in
        keys = Object.keys(@_paramMap)
        for own property of options
            # Is this a property that requires a constructor?
            if property in keys
                # Don't construct null values
                if options[property] is null then continue

                # Is the property an arrary or a single object?
                if options[property] instanceof Array
                    # Set the property to a mapped array, calling the
                    # constructor method to instantiate new objects
                    # if they are not already instances
                    @[property] = for item in options[property]
                        if item instanceof @_paramMap[property]
                            item
                        else
                            new @_paramMap[property](item)
                else
                    # Set the property to an instance of the constructor
                    if options[property] instanceof @_paramMap[property]
                        @[property] = options[property]
                    else
                        @[property] = new @_paramMap[property](options[property])
            else
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
                    throw new Error('Invalid regex input!')

        result
