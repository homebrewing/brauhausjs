Brauhaus = Brauhaus ? require '../lib/brauhaus'
assert = assert ? require 'assert'

describe 'Style', ->
    it 'Should get a list of categories', ->
        assert.ok Brauhaus.getStyleCategories()

    it 'Should get a list of styles for a category', ->
        assert.ok Brauhaus.getStyles('India Pale Ale')

    it 'Should supply style category information on a style object', ->
        style = Brauhaus.getStyle('India Pale Ale', 'American IPA')
        assert.equal style.category, 'India Pale Ale'
  
    it 'Should supply style name information on a style object', ->
        style = Brauhaus.getStyle('Light Hybrid Beer', 'Kölsch');
        assert.equal style.name, 'Kölsch'
