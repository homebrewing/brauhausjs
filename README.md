Spalt.js
========
A library for homebrew beer calculations using Node.js or a web browser. Features:

 * BeerXML import / export
 * Calculate OG, FG, IBU, ABV, and color
 * Automatically generated recipe instructions
 * Color to RGB conversions, CSS color support, etc

[![Build Status](https://travis-ci.org/danielgtaylor/spaltjs.png?branch=master)](https://travis-ci.org/danielgtaylor/spaltjs)

Installation
------------
You can install Spalt.js using `npm`:

```bash
npm install spalt
```

Quick Example (CoffeeScript)
----------------------------
Here is an example of how to use the library from CoffeeScript:

```coffeescript
{Recipe} = require 'spalt'

r = new Recipe
    name: 'My test brew'
    description: 'A new test beer using Spalt.js!'
    batchSize: 20.0
    boilSize: 10.0

r.add 'fermentable',
    name: 'Extra pale liquid extract'
    color: 2.5
    weight: 4.2
    yield: 78.0

r.calculate()

console.log "Original Gravity: #{ r.og.toFixed 3 }"
console.log "Alcohol: #{ r.abv }% by volume"
```

Quick Example (Javascript)
--------------------------
Coming soon...

Reference
---------
Coming soon...

License
-------
Copyright (c) 2012 Daniel G. Taylor

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
