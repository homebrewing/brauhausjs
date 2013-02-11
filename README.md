Brauhaus.js [![Build Status](https://travis-ci.org/danielgtaylor/brauhausjs.png)](https://travis-ci.org/danielgtaylor/brauhausjs)
===========
A library for homebrew beer calculations both in the browser and on the server. Features:

 * Supports multiple Javascript runtimes (web browsers, Node.js, etc)
 * BeerXML import / export
 * Calculate estimated OG, FG, IBU, ABV, SRM color, calories, and more
 * Tinseth and Rager IBU calculation formula support
   * Pellets vs. whole hops support
   * Late addition boil support
   * Dry hopping support
 * Automatically generated recipe instructions and timeline
 * Estimate monetary recipe cost based on ingredients
 * Built-in unit conversions (kg -> lb/oz, liter -> gallon, temps, etc)
 * Color to RGB conversions, CSS color support, etc

Brauhaus.js was developed with and for [Malt.io](https://github.com/danielgtaylor/malt.io), a community website for homebrewers.

Installation
------------
There are two ways to use Brauhaus.js - either in a web browser (client-side) or on Node.js (server-side).

### Web Browser (client-side use)
To use Brauhaus.js in a web browser, simply download the following file and include it as you would any other script:

 * [Download the latest brauhaus.min.js](https://raw.github.com/danielgtaylor/brauhausjs/master/dist/brauhaus.min.js)

```html
<script type="text/javascript" src="/scripts/brauhaus.min.js"></script>
<script type="text/javascript">
    // Your code goes here!
    // See below for an example...
</script>
```

### Node.js (server-side use)
For Node.js, you can easily install Brauhaus.js using `npm`:

```bash
npm install brauhaus
```

Quick Example (CoffeeScript)
----------------------------
Here is an example of how to use the library from CoffeeScript:

```coffeescript
# The following line is NOT required for web browser use
Brauhaus = require 'brauhaus'

# Create a recipe
r = new Brauhaus.Recipe
    name: 'My test brew'
    description: 'A new test beer using Brauhaus.js!'
    batchSize: 20.0
    boilSize: 10.0

# Add ingredients
r.add 'fermentable',
    name: 'Extra pale liquid extract'
    color: 2.5
    weight: 4.2
    yield: 78.0

r.add 'spice',
    name: 'Cascade hops'
    weight: 0.028
    aa: 5.0
    use: 'boil'
    form: 'pellet'

r.add 'yeast'
    name: 'Wyeast 3724 - Belgian Saison'
    type: 'ale'
    form: 'liquid'
    attenuation: 80

# Calculate values
r.calculate()

# Print out calculated values
console.log "Original Gravity: #{ r.og.toFixed 3 }"
console.log "Final Gravity: #{ r.fg.toFixed 3 }"
console.log "Color: #{ r.color.toFixed 1 }&deg; SRM }"
console.log "IBU: #{ r.ibu.toFixed 1 }"
console.log "Alcohol: #{ r.abv.toFixed 1 }% by volume"
console.log "Calories: #{ Math.round r.calories } kcal"
```

Quick Example (Javascript)
--------------------------
Here is an example of how to use the library form Javascript:

```javascript
// The following line is NOT required for web browser use
Brauhaus = require('brauhaus')

// Create a recipe
var r = new Brauhaus.Recipe({
    name: 'My test brew',
    description: 'A new test beer using Brauhaus.js!',
    batchSize: 20.0,
    boilSize: 10.0
});

// Add ingredients
r.add('fermentable', {
    name: 'Extra pale liquid extract',
    color: 2.5,
    weight: 4.2,
    yield: 78.0
});

r.add('spice', {
    name: 'Cascade hops',
    weight: 0.028,
    aa: 5.0,
    use: 'boil',
    form: 'pellet'
});

r.add('yeast', {
    name: 'Wyeast 3724 - Belgian Saison',
    type: 'ale',
    form: 'liquid',
    attenuation: 80
});

// Calculate values
r.calculate();

// Print out calculated values
console.log('Original Gravity: ' + r.og.toFixed(3));
console.log('Final Gravity: ' + r.fg.toFixed(3));
console.log('Color: ' + r.color.toFixed(1) + '&deg; SRM');
console.log('IBU: ' + r.ibu.toFixed(1));
console.log('Alcohol: ' + r.abv.toFixed(1) + '% by volume');
console.log('Calories: ' + Math.round(r.calories) + ' kcal');
```

Conversion Functions
--------------------
The following functions are available to convert between various forms:

### Brauhaus.kgToLb (number)
Convert kilograms to pounds.

```javascript
>>> Brauhaus.kgToLb(2.5)
5.51155
```

### Brauhaus.lbToKg (number)
Convert pounds to kilograms.

```javascript
>>> Brauhaus.lbToKg(5.51155)
2.5
```

### Brauhaus.kgToLbOz (number)
Convert kilograms to pounds and ounces.

```javascript
>>> Brauhaus.kgToLbOz(2.5)
{
    lb: 5,
    oz: 8.184799999999996
}
```

### Brauhaus.lbOzToKg (numberLbs, numberOz)
Convert pounds and ounces to kilograms.

```javascript
>>> Brauhaus.lbOzToKg(5, 8.184799999999996)
2.5
```

### Brauhaus.litersToGallons (number)
Convert liters to gallons.

```javascript
>>> Brauhaus.litersToGallons(20.0)
5.283440000000001
```

### Brauhaus.gallonsToLiters (number)
Convert gallons to liters.

```javascript
>>> Brauhaus.gallonsToLiters(5.283440000000001)
20.0
```

### Brauhaus.cToF (number)
Convert a temperature from celcius to fahrenheit.

```javascript
>>> Brauhaus.cToF(20.0)
68.0
```

### Brauhaus.fToC (number)
Convert a temperature from fahrenheit to celcius.

```javascript
>>> Brauhaus.fToC(68.0)
20.0
```

Color Conversions
-----------------
Colors can be easily converted into various useful formats for the screen and web.

### Brauhaus.srmToRgb (number)
Convert a color in &deg;SRM to a RGB triplet.

```javascript
>>> Brauhaus.srmToRgb(8)
[ 208, 88, 13 ]
```

### Brauhaus.srmToCss (number)
Convert a color in &deg;SRM to a form usable in a CSS color string.

```javascript
>>> Brauhaus.srmToCss(8)
'rgb(208, 88, 14)'
```

### Brauhaus.srmToName (number)
Convert a color in &deg;SRM to a human-readable color.

```javascript
>>> Brauhaus.srmToName(8)
'deep gold'
```

Brauhaus Objects
----------------
The following list of objects are available within Brauhaus:

 * Fermentable
 * Spice
 * Yeast
 * Recipe

Brauhaus.Fermentable
--------------------
A fermentable is some kind of a sugar that yeast can metabolize into CO2 and alcohol. Fermentables can be malts, malt extracts, honey, sugar, etc. Each fermentable can have the following properties:

| Property | Type   | Default         | Description             |
| -------- | ------ | --------------- | ----------------------- |
| name     | string | New fermentable | Name of the fermentable |
| weight   | number | 1.0             | Weight in kilograms     |
| yield    | number | 75.0            | Percentage yield        |
| color    | number | 2.0             | Color in &deg;SRM       |
| late     | bool   | false           | Late addition           |

### Fermentable.type ()
Get the type of fermentable, either `extract` or `grain`.

```javascript
>>> f.type()
'grain'
```

### Fermentable.addition ()
Get the addition type of fermentable, one of `mash`, `steep`, or `boil`.

```javascript
>>> f.addition()
'steep'
```

### Fermentable.weightLb ()
A shortcut for `Brauhaus.kgToLb(f.weight)` to get the weight in pounds.

```javascript
>>> f.weightLb()
2.2
```

### Fermentable.weightLbOz ()
A shortcut for `Brauhaus.kgToLbOz(f.weight)` to get the weight in pounds and ounces.

```javascript
>>> f.weightLbOz()
{
    lb: 2,
    oz: 4.3
}
```

### Fermentable.ppg ()
Get the parts per gallon from the yield percentage.

```javascript
>>> f.ppg()
36
```

### Fermentable.plato (number)
Get the gravity in degrees plato for this fermentable for a number of liters, based on the weight and yield.

```javascript
>>> f.plato(20.0)
7.5301
```

### Fermentable.gu (number)
Get the gravity units of this fermentable for a number of liters, based on the weight and yield. These units make the original gravity when divided by 1000 and added to one.

```javascript
>>> f.gu(20.0)
32
```

### Fermentable.price ()
Guess the price in USD per kilogram of this fermentable, based on the name. Prices are an approximation based on multiple online homebrew supply store prices. You should use `toFixed(2)` to display these.

```javascript
>>> f.price()
13.5025
```

Brauhaus.Spice
--------------
Coming soon!

Brauhaus.Yeast
--------------
Coming soon!

Brauhaus.Recipe
---------------
Coming soon!

License
-------
Copyright (c) 2013 Daniel G. Taylor

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
