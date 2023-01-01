require("funcs")

local tech_unlock_ingredients = {}

for _, tech in pairs(data.raw.technology) do
	if tech.effects then
		local map = {}
		for _, unlock in pairs(tech.effects) do
			if unlock.type == "unlock-recipe" then
				local recipe = data.raw.recipe[unlock.recipe]
                recipe = recipe.normal or recipe
				if recipe.ingredients then
					for _,ingredient in pairs(recipe.ingredients) do
						local name = ingredient.name or ingredient[1]
						local item = {}
                        item.name = name
                        item.recipe = recipe
                        table.insert(map, item)
					end
				end
			end
		end
		tech_unlock_ingredients[tech.name] = map
	end
end

local item_unlocked_by_techs = {}

for _, tech in pairs(data.raw.technology) do
	if tech.effects then
		for _, unlock in pairs(tech.effects) do
			if unlock.type == "unlock-recipe" then
				local recipe = data.raw.recipe[unlock.recipe]
                recipe = recipe.normal or recipe
                local results = {}
                if recipe.results then
                    results = recipe.results
                else
                    local sub = {}
                    sub.name = recipe.result
                    table.insert(results, sub)
                end
				for _, result in pairs(results) do
                    local name = result.name or result[1]
                    item_unlocked_by_techs[name] = item_unlocked_by_techs[name] or {}
                    table.insert(item_unlocked_by_techs[name], tech.name)
                end
			end
		end
	end
end

for tech_name, ingredients in pairs(tech_unlock_ingredients) do
	local tech = data.raw.technology[tech_name]
	for _, ingredient in pairs(ingredients) do
		local unlocked_by = item_unlocked_by_techs[ingredient.name]
		if unlocked_by then
			for _, unlock_tech in pairs(unlocked_by) do
				if tech_name == "ir-electronics-3" and unlock_tech == "fusion-reactor-equipment" then
                    error("Item causes cycle: "..ingredient.name.. " Recipe: "..serpent.block(ingredient.recipe).." Unlocked by :"..serpent.block(unlocked_by))
                end
			end
		end
	end
end

tech_find_loop()
