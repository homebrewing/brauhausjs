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
