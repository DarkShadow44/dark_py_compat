require("funcs")

-- Disable IR3 scrap calucation, takes way too long for all py items
DIR.calculate_scraps = function() end
-- Scraps also compute explosion, need to remove that as well
data.raw["simple-entity-with-owner"]["fake-transmat"].dying_explosion = nil

-- Prevent looping tech tree
tech_remove_unlock("fast-inserter-2", "fast-inserter-2")
tech_remove_unlock("stack-inserter-2", "stack-filter-inserter-2")
tech_remove_unlock("nuclear-power", "plutonium-peroxide")
tech_remove_unlock("uranium-processing", "plutonium-seperation")
tech_remove_unlock("uranium-processing", "plutonium")
tech_remove_unlock("nuclear-power", "plutonium-fuel-cell")
recipe_remove_first_ingredient("utility-science-pack", "fusion-reactor-equipment")

-- Work around chemical science pack tech tree loop, part 1
local empty_ingredients = {{"wood", 1}}
original_chemical_science_ingredients = data.raw.recipe["chemical-science-pack"].ingredients
data.raw.recipe["chemical-science-pack"].ingredients = empty_ingredients

data.raw.lab["copper-lab"].next_upgrade = nil
