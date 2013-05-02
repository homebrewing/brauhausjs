![Brauhaus.js](https://raw.github.com/danielgtaylor/brauhausjs/master/img/logo.png)

[![Dependency Status](https://gemnasium.com/danielgtaylor/brauhausjs.png)](https://gemnasium.com/danielgtaylor/brauhausjs) [![Build Status](https://travis-ci.org/danielgtaylor/brauhausjs.png)](https://travis-ci.org/danielgtaylor/brauhausjs)

A javascript library for homebrew beer calculations both in the browser and on the server. Features include:

 * Support for multiple Javascript runtimes
   * Node.js 0.6.x, 0.8.x, 0.10.x
   * Chrome, Firefox, Internet Explorer 9+, Safari, Opera, etc
 * BeerXML import / export
 * Calculate estimated OG, FG, IBU, ABV, SRM color, calories, and more
 * Tinseth and Rager IBU calculation formula support
   * Pellets vs. whole hops support
   * Late addition boil support
   * Dry hopping support
 * Automatically generated recipe instructions and timeline
 * Estimate monetary recipe cost in USD based on ingredients
 * Built-in unit conversions (kg <-> lb/oz, liter <-> gallon, temps, etc)
 * Color in &deg;SRM to name, RGB conversions, CSS color support, etc

Brauhaus.js was developed with and for [Malt.io](http://www.malt.io/), a community website for homebrewers to create recipes and share their love of homebrewing beer.

Installation
------------
There are two ways to use Brauhaus.js - either in a web browser (client-side) or on e.g. Node.js (server-side).

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
Brauhaus = Brauhaus ? require 'brauhaus'

# Create a recipe
r = new Brauhaus.Recipe
    name: 'My test brew'
    description: 'A new test beer using Brauhaus.js!'
    batchSize: 20.0
    boilSize: 10.0

# Add ingredients
r.add 'fermentable',
    name: 'Extra pale malt'
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

# Set up a simple infusion mash
r.mash = new Brauhaus.Mash
    name: 'My mash'
    ph: 5.4

r.mash.addStep
    name: 'Saccharification'
    type: 'Infusion'
    time: 60
    temp: 68
    waterRatio: 2.75

# Calculate values
r.calculate()

# Print out calculated values
console.log "Original Gravity: #{ r.og.toFixed 3 }"
console.log "Final Gravity: #{ r.fg.toFixed 3 }"
console.log "Color: #{ r.color.toFixed 1 }&deg; SRM (#{ r.colorName() })"
console.log "IBU: #{ r.ibu.toFixed 1 }"
console.log "Alcohol: #{ r.abv.toFixed 1 }% by volume"
console.log "Calories: #{ Math.round r.calories } kcal"
```

Quick Example (Javascript)
--------------------------
Here is an example of how to use the library form Javascript:

```javascript
// The following line is NOT required for web browser use
var Brauhaus = Brauhaus || require('brauhaus');

// Create a recipe
var r = new Brauhaus.Recipe({
    name: 'My test brew',
    description: 'A new test beer using Brauhaus.js!',
    batchSize: 20.0,
    boilSize: 10.0
});

// Add ingredients
r.add('fermentable', {
    name: 'Extra pale malt',
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

// Set up a simple infusion mash
r.mash = new Brauhaus.Mash({
    name: 'My mash',
    ph: 5.4
});

r.mash.addStep({
    name: 'Saccharification',
    type: 'Infusion',
    time: 60,
    temp: 68,
    waterRatio: 2.75
});

// Calculate values
r.calculate();

// Print out calculated values
console.log('Original Gravity: ' + r.og.toFixed(3));
console.log('Final Gravity: ' + r.fg.toFixed(3));
console.log('Color: ' + r.color.toFixed(1) + '&deg; SRM (' + r.colorName() + ')');
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

### Brauhaus.litersPerKgToQuartsPerLb (number)
Convert l/kg to qt/lb.

```javascript
>>> Brauhaus.litersPerKgToQuartsPerLb(5.0)
2.3965285450000002
```

### Brauhaus.quartsPerLbToLitersPerKg (number)
Convert qt/lb to l/kg.

```javascript
>>> Brauhaus.quartsPerLbToLitersPerKg(2.3965285450000002)
5.0
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
[208, 88, 13]
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

Beer Styles
-----------
Brauhaus ships with many pre-defined beer styles from BJCP.

### Brauhaus.getStyleCategories ()
Get a list of BJCP style categories supported by Brauhaus.

```javascript
>>> Brauhaus.getStyleCategories()
['Light Lager', 'Pilsner', 'Bock', ...]
```

### Brauhaus.getStyles (string)
Get a list of styles for a particular category

```javascript
>>> Brauhaus.getStyles('Bock')
['Maibock / Helles Bock', 'DoppelBock', ...]
```

### Brauhaus.getStyle (category, style)
Get an object representing a particular style.

```javascript
>>> Brauhaus.getStyle('Bock', 'Doppelbock')
{
    name: 'Doppelbock',
    category: 'Bock',
    gu: [1.072, 1.112],
    fg: [1.016, 1.024],
    srm: [6, 25],
    ibu: [16, 26],
    abv: [7, 10],
    carb: [1.6, 2.4]
}
```

Brauhaus Objects
----------------
The following list of objects are available within Brauhaus:

 * Fermentable
 * Spice
 * Yeast
 * MashStep
 * Mash
 * Recipe

Brauhaus.Fermentable
--------------------
A fermentable is some kind of a sugar that yeast can metabolize into CO2 and alcohol. Fermentables can be malts, malt extracts, honey, sugar, etc. Each fermentable can have the following properties:

| Property | Type   | Default         | Description             |
| -------- | ------ | --------------- | ----------------------- |
| color    | number | 2.0             | Color in &deg;SRM       |
| late     | bool   | false           | Late addition           |
| name     | string | New fermentable | Name of the fermentable |
| weight   | number | 1.0             | Weight in kilograms     |
| yield    | number | 75.0            | Percentage yield        |

### Fermentable.prototype.addition ()
Get the addition type of fermentable, one of `mash`, `steep`, or `boil`.

```javascript
>>> f.addition()
'steep'
```

### Fermentable.prototype.colorRgb ()
Get the color triplet for this fermentable. Shortcut for `Brauhaus.srmToRgb(f.color)`.

```javascript
>>> f.colorRgb()
[233, 157, 63]
```

### Fermentable.prototype.colorCss ()
Get the CSS-friendly color string for this fermentable. Shortcut for `Brauhaus.srmToCss(f.color)`.

```javascript
>>> f.colorCss()
'rgb(233, 157, 63)'
```

### Fermentable.prototype.colorName ()
Get the human-readable name for the color of this fermentable. Shortcut for `Brauhaus.srmToName(f.color)`.

```javascript
>>> f.colorName()
'deep gold'
```

### Fermentable.prototype.gu (number)
Get the gravity units of this fermentable for a number of liters, based on the weight and yield. These units make the original gravity when divided by 1000 and added to one.

```javascript
>>> f.gu(20.0)
32
```

### Fermentable.prototype.plato (number)
Get the gravity in degrees plato for this fermentable for a number of liters, based on the weight and yield.

```javascript
>>> f.plato(20.0)
7.5301
```

### Fermentable.prototype.ppg ()
Get the parts per gallon from the yield percentage.

```javascript
>>> f.ppg()
36
```

### Fermentable.prototype.price ()
Guess the price in USD per kilogram of this fermentable, based on the name. Prices are an approximation based on multiple online homebrew supply store prices. You should use `toFixed(2)` to display these.

```javascript
>>> f.price()
13.5025
```

### Fermentable.prototype.type ()
Get the type of fermentable, either `extract` or `grain`.

```javascript
>>> f.type()
'grain'
```

### Fermentable.prototype.weightLb ()
A shortcut for `Brauhaus.kgToLb(f.weight)` to get the weight in pounds.

```javascript
>>> f.weightLb()
2.2
```

### Fermentable.prototype.weightLbOz ()
A shortcut for `Brauhaus.kgToLbOz(f.weight)` to get the weight in pounds and ounces.

```javascript
>>> f.weightLbOz()
{
    lb: 2,
    oz: 4.3
}
```

Brauhaus.Spice
--------------
A spice is some kind of substance added to flavor or protect a brew. Spices can be hops, coriander, orange peel, cinnamon, whirlfloc, Irish moss, rose hips, etc. Each spice can have the following properties:

| Property | Type   | Default   | Description                                      |
| -------- | ------ | --------- | ------------------------------------------------ |
| aa       | number | 0.0       | Alpha-acid percentage (0 - 100)                  |
| form     | string | pellet    | Form, like pellet, whole, ground, crushed, etc   |
| name     | string | New spice | Name of the spice                                |
| time     | number | 60        | Time in minutes to add the spice                 |
| use      | string | boil      | When to use the spice (mash, boil, primary, etc) |
| weight   | number | 1.0       | Weight in kilograms                              |

### Spice.prototype.price ()
Guess the price in USD per kilogram of this spice, based on the name. Prices are an approximation based on multiple online homebrew supply store prices. You should use `toFixed(2)` to display these.

```javascript
>>> s.price()
2.5318
```

### Spice.prototype.weightLb ()
A shortcut for `Brauhaus.kgToLb(s.weight)` to get the weight in pounds.

```javascript
>>> s.weightLb()
0.0625
```

### Spice.prototype.weightLbOz ()
A shortcut for `Brauhaus.kgToLbOz(s.weight)` to get the weight in pounds and ounces.

```javascript
>>> s.weightLbOz()
{
    lb: 0,
    oz: 1
}
```

Brauhaus.Yeast
--------------
Yeast are the biological workhorse that transform sugars into alcohol. Yeast can be professional strains like Wyeast 3068, harvested from bottles, harvested from the air, or other bugs like bacteria that produce acid.

| Property    | Type   | Default   | Description                                |
| ----------- | ------ | --------- | ------------------------------------------ |
| attenuation | number | 75.0      | Percentage of sugars the yeast can convert |
| form        | string | liquid    | Liquid or dry                              |
| name        | string | New yeast | Name of the yeast                          |
| type        | string | ale       | Ale, lager, or other                       |

### Yeast.prototype.price ()
Guess the price in USD per packet of this yeast, based on the name. Prices are an approximation based on multiple online homebrew supply store prices. You should use `toFixed(2)` to display these.

```javascript
>>> y.price()
7
```

Brauhaus.MashStep
-----------------
A single step in a multi-step mash, such as infusing water, changing the temperature, or decocting mash to boil.

| Property    | Type   | Default          | Description                                                  |
| ----------- | ------ | ---------------- | ------------------------------------------------------------ |
| endTemp     | number | unset            | Temperature in degrees C after this step                     |
| name        | string | Saccharification | A name to give this step                                     |
| rampTime    | number | unset            | Time in minutes to ramp to the given temperature             |
| temp        | number | 68               | Temperature in degrees C to hold the mash                    |
| time        | number | 60               | Duration of this step in minutes                             |
| type        | string | Infusion         | Type of mash step: `Infusion`, `Temperature`, or `Decoction` |
| waterRatio  | number | 3.0              | Ratio in liters per kg of water to infuse or decoct          |

### MashStep.types
An array of available mash step types: `Infusion`, `Temperature`, and `Decoction`. They can generally be broken down as follows:

 * `Infusion`: adding hot water to the mash to raise its overall temperature
 * `Temperature`: usually adding heat via some source, like a stovetop or gas burner
 * `Decoction`: removing and boiling some of the mash, then adding it back to raise the overall temperature

---

### MashStep.prototype.description ([boolean], [number])
An automatically generated description of the step. If the first argument is `true`, then use SI units (liters, kilograms, celcius). If it is `false`, then use quarts, pounds and fahrenheit. If a second argument is passed, then it is used as the total grain weight of the recipe to determine the exact amount of water or mash to add/remove.

```javascript
>>> mashStep.description()
'Infuse 3.0l per kg of grain for 60 minutes at 68C'
>>> mashStep.description(false)
'Infuse 1.44qt per lb of grain for 60 minutes at 154.4F'
>>> mashStep.description(true, 3.3)
'Infuse 10.0l for 60 minutes at 68C'
>>> mashStep.description(false, 3.3)
'Infuse 10.57qt for 60 minutes at 154.4F'
```

### MashStep.prototype.endTempF ()
Get the step end temperature in degrees F. Shortcut for `Brauhaus.cToF(mashStep.endTemp)`.

```javascript
>>> mashStep.endTempF()
150.0
```

### MashStep.prototype.tempF ()
Get the step temperature in degrees F. Shortcut for `Brauhaus.cToF(mashStep.temp)`.

```javascript
>>> mashStep.tempF()
154.0
```

### MashStep.prototype.waterRatioQtPerLb ()
Get the water ratio in quarts per pound of grain. Shortcut for `Brauhaus.litersPerKgToQtPerLb(mashStep.waterRatio)`.

```javascript
>>> mashStep.waterRatioQtPerLb()
1.5
```

Brauhaus.Mash
-------------
A recipe mash description for all-grain or partial-mash recipes. The mash includes information like a name, notes for the brewer, grain temperature, PH, etc.

| Property   | Type   | Default | Description                                        |
| ---------- | ------ | ------- | -------------------------------------------------- |
| grainTemp  | number | 23      | Grain temperature in degrees C                     |
| name       | string | unset   | Name of the mash, e.g. `Single step infusion @68C` |
| notes      | string | unset   | Notes for the brewer                               |
| ph         | number | unset   | Target PH of the mash                              |
| spargeTemp | number | 76      | Sparge temperature in degrees C                    |
| steps      | array  | []      | A list of `Brauhaus.MashStep` objects              |

### Mash.prototype.addStep (object)
Add a new mash step with the passed options.

```javascript
>>> mash.prototype.addStep({
    name: 'Test step',
    type: 'Infusion',
    waterRatio: 3.0,
    temp: 68,
    time: 60
})
```

### Mash.prototype.grainTempF ()
Get the grain temperature in degrees F. Shortcut for `Brauhaus.cToF(mash.grainTemp)`.

```javascript
>>> mash.grainTempF()
75.0
```

### Mash.prototype.spargeTempF ()
Get the sparge temperature in degrees F. Shortcut for `Brauhaus.cToF(mash.spargeTemp)`.

```javascript
>>> mash.spargeTempF()
170.0
```

Brauhaus.Recipe
---------------
A beer recipe, containing ingredients like fermentables, spices, and yeast. Calculations can be made for bitterness, alcohol content, color, and more. Many values are unset by default and will be calculated when the `Recipe.prototype.calculate()` method is called.

| Property        | Type   | Default            | Description                                  |
| --------------- | ------ | ------------------ | -------------------------------------------- |
| abv             | number | unset              | Alcohol percentage by volume                 |
| abw             | number | unset              | Alcohol percentage by weight                 |
| author          | string | Anonymous Brewer   | Recipe author                                |
| batchSize       | number | 20.0               | Total size of batch in liters                |
| bv              | number | unset              | Balance value (bitterness / sweetness ratio) |
| boilSize        | number | 10.0               | Size of wort that will be boiled in liters   |
| buToGu          | number | unset              | Bitterness units to gravity units ratio      |
| calories        | number | unset              | Calories per serving (kcal)                  |
| color           | number | unset              | Color in &deg;SRM                            |
| description     | string | Recipe description | Recipe description text                      |
| fermentables    | array  | []                 | Array of `Brauhaus.Fermentable` objects      |
| fg              | number | unset              | Final gravity (e.g. 1.012)                   |
| fgPlato         | number | unset              | Final gravity in &deg;Plato                  |
| ibu             | number | unset              | Bitterness in IBU                            |
| ibuMethod       | string | tinseth            | IBU calculation method, `tinseth` or `rager` |
| mashEfficiency  | number | 75.0               | Efficiency percentage for the mash           |
| name            | number | New recipe         | Recipe name text                             |
| og              | number | unset              | Original gravity (e.g. 1.048)                |
| ogPlato         | number | unset              | Original gravity in &deg;Plato               |
| price           | number | unset              | Approximate price in USD                     |
| realExtract     | number | unset              | Real extract of the recipe                   |
| servingSize     | number | 0.355              | Serving size in liters                       |
| spices          | array  | []                 | Array of `Brauhaus.Spice` objects            |
| steepEfficiency | number | 50.0               | Efficiency percentage for steeping           |
| style           | object | null               | Recipe style (see `Brauhaus.STYLES`)         |
| yeast           | array  | []                 | Array of `Brauhaus.Yeast` objects            |

### Recipe.fromBeerXml (xml)
Get a list of recipes from BeerXML loaded as a string.

```javascript
>>> xml = '<recipes><recipe><name>Test Recipe</name>...</recipe></recipes>'
>>> recipe = Brauhaus.Recipe.fromBeerXml(xml)[0]
<Brauhaus.Recipe object 'Test Recipe'>
```

---

### Recipe.prototype.add (type, data)
Add a new ingredient to the recipe. `type` can be one of `fermentable`, `spice`, or `yeast`. The data is what will be sent to the constructor of the ingredient defined by `type`.

```javascript
>>> r.add('fermentable', {
    name: 'Pale malt'
    weight: 4.0
    yield: 75
    color: 3.5
});
>>> r.fermentables
[<Brauhaus.Fermentable object 'Pale malt'>]
```

### Recipe.prototype.batchSizeGallons ()
Get the recipe batch size in gallons. Shortcut for `Brauhaus.litersToGallons(r.batchSize)`.

```javascript
>>> r.batchSizeGallons()
5.025
```

### Recipe.prototype.boilSizeGallons ()
Get the recipe boil size in gallons. Shortcut for `Brauhaus.litersToGallons(r.boilSize)`.

```javascript
>>> r.boilSizeGallons()
3.125
```

### Recipe.prototype.calculate ()
Calculate alcohol, bitterness, color, gravities, etc. This method must be called before trying to access those values. See the quick examples above for a more complete example of `calculate()` usage.

```javascript
>>> r.calculate()
>>> r.ibu
28.5
```

### Recipe.prototype.grainWeight ()
Get the total grain weight in kg. Note that this only includes fermentables that are mashed or steeped. Things like malt extract syrup are excluded.

```javascript
>>> r.grainWeight()
4.0
```

### Recipe.prototype.toBeerXml ()
Convert this recipe into BeerXML for export. Returns a BeerXML string.

```javascript
>>> r.toBeerXml()
'<?xml version="1.0"><recipes><recipe>...</recipe></recipes>'
```

Contributing
------------
Contributions are welcome - just fork the project and submit a pull request when you are ready!

### Getting Started
First, create a fork on GitHub. Then:

```bash
git clone ...
cd brauhausjs
npm install
```

### Unit Tests
Before submitting a pull request, please add any relevant tests and run them via:

```bash
npm test
```

If you have PhantomJS installed and on your path then you can use:

```bash
CI=true npm test
```

Pull requests will automatically be tested by Travis CI both in Node.js 0.6/0.8/0.10 and in a headless webkit environment (PhantomJS). Changes that cause tests to fail will not be accepted. New features should be tested to be accepted.

New tests can be added in the `test` directory. If you add a new file there, please don't forget to update the `test.html` to include it!

Please note that all contributions will be licensed under the MIT license in the following section.

License
-------
Copyright (c) 2013 Daniel G. Taylor

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
