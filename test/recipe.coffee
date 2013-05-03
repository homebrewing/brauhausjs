Brauhaus = Brauhaus ? require '../lib/brauhaus'
assert = assert ? require 'assert'

describe 'Recipe', ->
    describe 'Extract', ->
        recipe = new Brauhaus.Recipe
            batchSize: 20.0
            boilSize: 10.0

        recipe.style =
            name: 'Saison'
            category: 'Belgian and French Ale'
            og: [1.060, 1.080]
            fg: [1.010, 1.016]
            ibu: [32, 38]
            color: [3.5, 8.5]
            abv: [4.5, 6.0]
            carb: [1.6, 2.4]

        # Add some ingredients
        recipe.add 'fermentable',
            name: 'Pale liquid extract'
            weight: 3.5
            yield: 75.0
            color: 3.5

        recipe.add 'spice',
            name: 'Cascade hops'
            weight: 0.02835
            aa: 5.0
            use: 'boil'
            time: 60
            form: 'pellet'

        recipe.add 'spice',
            name: 'Cascade hops'
            weight: 0.014
            aa: 5.0
            use: 'boil'
            time: 10
            form: 'pellet'

        recipe.add 'yeast',
            name: 'Wyeast 3724 - Belgian Saison'
            type: 'ale'
            form: 'liquid'
            attenuation: 80

        recipe.mash = new Brauhaus.Mash
            name: 'My Mash'
            ph: 5.4

        recipe.mash.addStep
            name: 'Saccharification'
            time: 60
            temp: 68
            endTemp: 60

        # Calculate recipe values like og, fg, ibu
        recipe.calculate()

        # Run tests
        it 'Should calculate OG as 1.051', ->
            assert.equal 1.051, recipe.og.toFixed(3)

        it 'Should calculate FG as 1.010', ->
            assert.equal 1.010, recipe.fg.toFixed(3)

        it 'Should calculate ABV as 5.3 %', ->
            assert.equal 5.3, recipe.abv.toFixed(1)

        it 'Should calculate color as 4.6 SRM', ->
            assert.equal 4.6, recipe.color.toFixed(1)

        it 'Should calculate calories as 165 kcal', ->
            assert.equal 165, Math.round(recipe.calories)

        it 'Should calculate IBU (tinseth) as 22.0', ->
            assert.equal 22.0, recipe.ibu.toFixed(1)

        it 'Should calculate BU:GU as 0.44', ->
            assert.equal 0.44, recipe.buToGu.toFixed(2)

        it 'Should calculate BV as 1.01', ->
            assert.equal 1.01, recipe.bv.toFixed(2)

        it 'Should cost $30.85', ->
            assert.equal 30.85, recipe.price.toFixed(2)

        it 'Should convert to BeerXML', ->
            assert.equal '<?xml version="1.0" encoding="utf-8"?><recipes><recipe><version>1</version><name>New Recipe</name><brewer>Anonymous Brewer</brewer><batch_size>20</batch_size><boil_size>10</boil_size><efficiency>75</efficiency><primary_age>14</primary_age><primary_temp>20</primary_temp><age>14</age><age_temp>20</age_temp><style><version>1</version><name>Saison</name><category>Belgian and French Ale</category><og_min>1.06</og_min><og_max>1.08</og_max><fg_min>1.01</fg_min><fg_max>1.016</fg_max><ibu_min>32</ibu_min><ibu_max>38</ibu_max><color_min>3.5</color_min><color_max>8.5</color_max><abv_min>4.5</abv_min><abv_max>6</abv_max><carb_min>1.6</carb_min><carb_max>2.4</carb_max></style><fermentables><fermentable><version>1</version><name>Pale liquid extract</name><type>extract</type><weight>3.5</weight><yield>75.0</yield><color>3.5</color></fermentable></fermentables><hops><hop><version>1</version><name>Cascade hops</name><time>60</time><amount>0.02835</amount><alpha>5.00</alpha><use>boil</use><form>pellet</form></hop><hop><version>1</version><name>Cascade hops</name><time>10</time><amount>0.014</amount><alpha>5.00</alpha><use>boil</use><form>pellet</form></hop></hops><yeasts><yeast><version>1</version><name>Wyeast 3724 - Belgian Saison</name><type>ale</type><form>liquid</form><attenuation>80</attenuation></yeast></yeasts><miscs></miscs><mash><version>1</version><name>My Mash</name><grain_temp>23</grain_temp><sparge_temp>76</sparge_temp><ph>5.4</ph><notes></notes><mash_steps><mash_step><version>1</version><name>Saccharification</name><description>Infuse 0.0l for 60 minutes at 68C</description><step_time>60</step_time><step_temp>68</step_temp><end_temp>60</end_temp><ramp_time>null</ramp_time><infuse_amount>0</infuse_amount></mash_step></mash_steps></mash></recipe></recipes>', recipe.toBeerXml()

    describe 'Steep', ->
        recipe = new Brauhaus.Recipe
            batchSize: 20.0
            boilSize: 10.0
            ibuMethod: 'rager'

        # Add some ingredients
        recipe.add 'fermentable',
            name: 'Extra pale LME'
            weight: 2.5
            yield: 75.0
            color: 2.0

        recipe.add 'fermentable',
            name: 'Caramel 60L'
            weight: 0.5
            yield: 73.0
            color: 60.0

        recipe.add 'spice',
            name: 'Cascade hops'
            weight: 0.02835
            aa: 5.0
            use: 'boil'
            time: 60
            form: 'pellet'

        recipe.add 'spice',
            name: 'Cascade hops'
            weight: 0.014
            aa: 5.0
            use: 'boil'
            time: 20
            form: 'pellet'

        recipe.add 'spice',
            name: 'Cascade hops'
            weight: 0.014
            aa: 5.0
            use: 'boil'
            time: 5
            form: 'pellet'

        recipe.add 'yeast',
            name: 'Wyeast 1214 - Belgian Abbey'
            type: 'ale'
            form: 'liquid'
            attenuation: 78

        recipe.calculate()

        it 'Should calculate OG as 1.040', ->
            assert.equal 1.040, recipe.og.toFixed(3)

        it 'Should calculate FG as 1.009', ->
            assert.equal 1.009, recipe.fg.toFixed(3)

        it 'Should calculate ABV as 4.1 %', ->
            assert.equal 4.1, recipe.abv.toFixed(1)

        it 'Should calculate color as 9.4 SRM', ->
            assert.equal 9.4, recipe.color.toFixed(1)

        it 'Should calculate calories as 129 kcal', ->
            assert.equal 129, Math.round(recipe.calories)

        it 'Should calculate IBU (rager) as 31.6', ->
            assert.equal 31.6, recipe.ibu.toFixed(1)

        it 'Should calculate BU:GU as 0.80', ->
            assert.equal 0.80, recipe.buToGu.toFixed(2)

        it 'Should calculate BV as 1.77', ->
            assert.equal 1.77, recipe.bv.toFixed(2)

        it 'Should cost $26.69', ->
            assert.equal 26.69, recipe.price.toFixed(2)

    describe 'Mash', ->
        recipe = new Brauhaus.Recipe
            batchSize: 20.0
            boilSize: 10.0

        # Add some ingredients
        recipe.add 'fermentable',
            name: 'Pilsner malt'
            weight: 4.5
            yield: 74.0
            color: 1.5

        recipe.add 'spice',
            name: 'Cascade hops'
            weight: 0.02835
            aa: 5.0
            use: 'boil'
            time: 45
            form: 'pellet'

        recipe.add 'yeast',
            name: 'Wyeast 1728 - Scottish Ale'
            type: 'ale'
            form: 'liquid'
            attenuation: 73

        recipe.mash = new Brauhaus.Mash
            name: 'Test mash'
            ph: 5.4

        recipe.mash.addStep
            name: 'Saccharification'
            type: 'Infusion'
            temp: 70
            time: 60
            waterRatio: 2.75

        recipe.calculate()

        it 'Should calculate OG as 1.048', ->
            assert.equal 1.048, recipe.og.toFixed(3)

        it 'Should calculate FG as 1.013', ->
            assert.equal 1.013, recipe.fg.toFixed(3)

        it 'Should calculate ABV as 4.6 %', ->
            assert.equal 4.6, recipe.abv.toFixed(1)

        it 'Should calculate color as 3.0 SRM', ->
            assert.equal 3.0, recipe.color.toFixed(1)

        it 'Should calculate calories as 158 kcal', ->
            assert.equal 158, Math.round(recipe.calories)

        it 'Should calculate IBU (tinseth) as 17.5', ->
            assert.equal 17.5, recipe.ibu.toFixed(1)

        it 'Should calculate BU:GU as 0.36', ->
            assert.equal 0.36, recipe.buToGu.toFixed(2)

        it 'Should calculate BV as 0.73', ->
            assert.equal 0.73, recipe.bv.toFixed(2)

        it 'Should cost $27.30', ->
            assert.equal 27.30, recipe.price.toFixed(2)

    describe 'BeerXML', ->
        recipe =  Brauhaus.Recipe.fromBeerXml('<?xml version="1.0" encoding="ISO-8859-1"?>
<RECIPES>
  <RECIPE>
  <NAME>Dry Stout</NAME>
  <VERSION>1</VERSION>
   <TYPE>All Grain</TYPE>
   <BREWER>Brad Smith</BREWER>
   <BATCH_SIZE>18.93</BATCH_SIZE>
    <BOIL_SIZE>20.82</BOIL_SIZE>
    <BOIL_TIME>60.0</BOIL_TIME>
    <EFFICIENCY>72.0</EFFICIENCY>
   <TASTE_NOTES>Nice dry Irish stout with a warm body but low starting gravity much like the famous drafts.</TASTE_NOTES>
   <RATING>41</RATING>
    <DATE>3 Jan 04</DATE>
    <OG>1.036</OG>
    <FG>1.012</FG>
    <CARBONATION>2.1</CARBONATION>
    <CARBONATION_TEMP>20.0</CARBONATION_TEMP>
    <CARBONATION_USED>Kegged</CARBONATION_USED>
    <PRIMARY_AGE>14</PRIMARY_AGE>
    <PRIMARY_TEMP>20.0</PRIMARY_TEMP>
    <AGE>24.0</AGE>
    <AGE_TEMP>17.0</AGE_TEMP>
    <FERMENTATION_STAGES>2</FERMENTATION_STAGES>
   <STYLE>
 <NAME>Dry Stout</NAME>
 <CATEGORY>Stout</CATEGORY>
 <CATEGORY_NUMBER>16</CATEGORY_NUMBER>
 <STYLE_LETTER>A</STYLE_LETTER>
 <STYLE_GUIDE>BJCP</STYLE_GUIDE>
 <VERSION>1</VERSION>
 <TYPE>Ale</TYPE>
 <OG_MIN>1.035</OG_MIN>
 <OG_MAX>1.050</OG_MAX>
 <FG_MIN>1.007</FG_MIN>
 <FG_MAX>1.011</FG_MAX>
 <IBU_MIN>30.0</IBU_MIN>
 <IBU_MAX>50.0</IBU_MAX>
 <COLOR_MIN>35.0</COLOR_MIN>
 <COLOR_MAX>200.0</COLOR_MAX>
 <ABV_MIN>3.2</ABV_MIN>
 <ABV_MAX>5.5</ABV_MAX>
 <CARB_MIN>1.6</CARB_MIN>
 <CARB_MAX>2.1</CARB_MAX>
              <NOTES>Famous Irish Stout.  Dry, roasted, almost coffee like flavor.  Often soured with pasteurized sour beer.  Full body perception due to flaked barley, though starting gravity may be low.  Dry roasted flavor.</NOTES>
  </STYLE>
  <HOPS>
  <HOP>
 <NAME>Goldings, East Kent</NAME>
 <VERSION>1</VERSION>
 <ALPHA>5.0</ALPHA>
 <AMOUNT>0.0638</AMOUNT>
<USE>Boil</USE>
 <TIME>60.0</TIME>
 <NOTES>Great all purpose UK hop for ales, stouts, porters</NOTES>
</HOP>
    </HOPS>
    <FERMENTABLES>
<FERMENTABLE>
 <NAME>Pale Malt (2 row) UK</NAME>
 <VERSION>1</VERSION>
 <AMOUNT>2.27</AMOUNT>
 <TYPE>Grain</TYPE>
<YIELD>78.0</YIELD>
 <COLOR>3.0</COLOR>
 <ORIGIN>United Kingdom</ORIGIN>
 <SUPPLIER>Fussybrewer Malting</SUPPLIER>
 <NOTES>All purpose base malt for English styles</NOTES>
 <COARSE_FINE_DIFF>1.5</COARSE_FINE_DIFF>
 <MOISTURE>4.0</MOISTURE>
 <DIASTATIC_POWER>45.0</DIASTATIC_POWER>
 <PROTEIN>10.2</PROTEIN>
 <MAX_IN_BATCH>100.0</MAX_IN_BATCH>
</FERMENTABLE>
<FERMENTABLE>
 <NAME>Barley, Flaked</NAME>
 <VERSION>1</VERSION>
 <AMOUNT>0.91</AMOUNT>
 <TYPE>Grain</TYPE>
<YIELD>70.0</YIELD>
 <COLOR>2.0</COLOR>
 <ORIGIN>United Kingdom</ORIGIN>
 <SUPPLIER>Fussybrewer Malting</SUPPLIER>
 <NOTES>Adds body to porters and stouts, must be mashed</NOTES>
 <COARSE_FINE_DIFF>1.5</COARSE_FINE_DIFF>
 <MOISTURE>9.0</MOISTURE>
 <DIASTATIC_POWER>0.0</DIASTATIC_POWER>
 <PROTEIN>13.2</PROTEIN>
 <MAX_IN_BATCH>20.0</MAX_IN_BATCH>
 <RECOMMEND_MASH>TRUE</RECOMMEND_MASH>
</FERMENTABLE>
<FERMENTABLE>
 <NAME>Black Barley</NAME>
 <VERSION>1</VERSION>
 <AMOUNT>0.45</AMOUNT>
 <TYPE>Grain</TYPE>
<YIELD>78.0</YIELD>
 <COLOR>500.0</COLOR>
 <ORIGIN>United Kingdom</ORIGIN>
 <SUPPLIER>Fussybrewer Malting</SUPPLIER>
 <NOTES>Unmalted roasted barley for stouts, porters</NOTES>
 <COARSE_FINE_DIFF>1.5</COARSE_FINE_DIFF>
 <MOISTURE>5.0</MOISTURE>
 <DIASTATIC_POWER>0.0</DIASTATIC_POWER>
 <PROTEIN>13.2</PROTEIN>
 <MAX_IN_BATCH>10.0</MAX_IN_BATCH>
</FERMENTABLE>
 </FERMENTABLES>
 <MISCS>
 <MISC>
 <NAME>Irish Moss</NAME>
 <VERSION>1</VERSION>
 <TYPE>Fining</TYPE>
 <USE>Boil</USE>
 <TIME>15.0</TIME>
 <AMOUNT>0.010</AMOUNT>
 <NOTES>Used as a clarifying agent during the last few minutes of the boil</NOTES>
</MISC>
 </MISCS>
 <WATERS>
<WATER>
 <NAME>Burton on Trent, UK</NAME>
 <VERSION>1</VERSION>
 <AMOUNT>20.0</AMOUNT>
 <CALCIUM>295.0</CALCIUM>
 <MAGNESIUM>45.0</MAGNESIUM>
 <SODIUM>55.0</SODIUM>
 <SULFATE>725.0</SULFATE>
 <CHLORIDE>25.0</CHLORIDE>
 <BICARBONATE>300.0</BICARBONATE>
 <PH>8.0</PH>
 <NOTES> Use for distinctive pale ales strongly hopped.  Very hard water accentuates the hops flavor. Example: Bass Ale
</NOTES>
</WATER>
  </WATERS>
 <YEASTS>
<YEAST>
 <NAME>Irish Ale</NAME>
 <TYPE>Ale</TYPE>
<VERSION>1</VERSION>
 <FORM>Liquid</FORM>
 <AMOUNT>0.250</AMOUNT>
<LABORATORY>Wyeast Labs</LABORATORY>
 <PRODUCT_ID>1084</PRODUCT_ID>
 <MIN_TEMPERATURE>16.7</MIN_TEMPERATURE>
<MAX_TEMPERATURE>22.2</MAX_TEMPERATURE>
<ATTENUATION>73.0</ATTENUATION>
<NOTES>Dry, fruity flavor characteristic of stouts.  Full bodied, dry, clean flavor. </NOTES>
 <BEST_FOR>Irish Dry Stouts</BEST_FOR>
 <FLOCCULATION>Medium</FLOCCULATION>
</YEAST>
 </YEASTS>
<MASH>
 <NAME>Single Step Infusion, 68 C</NAME>
 <VERSION>1</VERSION>
 <GRAIN_TEMP>22.0</GRAIN_TEMP>
<MASH_STEPS>
    <MASH_STEP>
            <NAME>Conversion Step, 68C </NAME>
            <VERSION>1</VERSION>
            <TYPE>Infusion</TYPE>
            <STEP_TEMP>68.0</STEP_TEMP>
            <STEP_TIME>60.0</STEP_TIME>
<INFUSE_AMOUNT>10.0</INFUSE_AMOUNT>
      </MASH_STEP>
 </MASH_STEPS>
</MASH>
</RECIPE>
</RECIPES>')[0]

        recipe.calculate()

        it 'Should have a name of Dry Stout', ->
            assert.equal 'Dry Stout', recipe.name

        it 'Should have an author of Brad Smith', ->
            assert.equal 'Brad Smith', recipe.author

        it 'Should have a mash efficiency of 72%', ->
            assert.equal 72, recipe.mashEfficiency

        it 'Should have a style OG of [1.035, 1.050]', ->
            assert.equal 1.035, recipe.style.og[0]
            assert.equal 1.050, recipe.style.og[1]

        it 'Should have a style FG of [1.007, 1.011]', ->
            assert.equal 1.007, recipe.style.fg[0]
            assert.equal 1.011, recipe.style.fg[1]

        it 'Should have a style IBU of [30, 50]', ->
            assert.equal 30, recipe.style.ibu[0]
            assert.equal 50, recipe.style.ibu[1]

        it 'Should have a style color of [35, 200]', ->
            assert.equal 35, recipe.style.color[0]
            assert.equal 200, recipe.style.color[1]

        it 'Should have a style ABV of [3.2, 5.5]', ->
            assert.equal 3.2, recipe.style.abv[0]
            assert.equal 5.5, recipe.style.abv[1]

        it 'Should load aging & temp information', ->
            assert.equal 14.0, recipe.primaryDays
            assert.equal 20.0, recipe.primaryTemp
            assert.equal 20.0, recipe.bottlingTemp
            assert.equal 2.1, recipe.bottlingPressure

        it 'Should load style name', ->
            assert.equal 'Dry Stout', recipe.style.name

        it 'Should load style category', ->
            assert.equal 'Stout', recipe.style.category

        it 'Should contain 3 fermentables', ->
            assert.equal 3, recipe.fermentables.length

        it 'Should contain 2 spices', ->
            assert.equal 2, recipe.spices.length

        it 'Should contain 1 yeast', ->
            assert.equal 1, recipe.yeast.length

        it 'Should have an OG of 1.039', ->
            assert.equal 1.039, recipe.og.toFixed 3

        it 'Should have a FG of 1.011', ->
            assert.equal 1.011, recipe.fg.toFixed 3

        it 'Should have an IBU of 49.4', ->
            assert.equal 49.4, recipe.ibu.toFixed 1

        it 'Should have a mash object', ->
            assert.ok recipe.mash.steps

        it 'Should have one mash step (60 min @ 68C / 10l)', ->
            assert.equal 1, recipe.mash.steps.length
            assert.equal 60, recipe.mash.steps[0].time
            assert.equal 68, recipe.mash.steps[0].temp

        it 'Should have converted absolute volume to water ratio of 2.75', ->
            assert.equal 2.75, recipe.mash.steps[0].waterRatio.toFixed 2

        it 'Should auto-generate a mash step description (si)', ->
            assert.equal 'Infuse 10.0l for 60 minutes at 68C', recipe.mash.steps[0].description(true, recipe.grainWeight())

        it 'Should auto-generate a mash step description (imperial)', ->
            assert.equal 'Infuse 10.6qt for 60 minutes at 154.4F', recipe.mash.steps[0].description(false, recipe.grainWeight())
