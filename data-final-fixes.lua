require("funcs")

-- Remove duplicate ingredients
recipe_remove_first_ingredient("landfill", "gravel")
recipe_remove_first_ingredient("locomotive", "small-parts-01")
recipe_remove_first_ingredient("piercing-shotgun-shell", "plastic-bar")

-- Work around chemical science pack tech tree loop, part 2
tech_remove_unlock("ir-steel-milestone", "chemical-science-pack")
data.raw.recipe["chemical-science-pack"].ingredients = original_chemical_science_ingredients
