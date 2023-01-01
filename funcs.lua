function recipe_remove_first_ingredient(recipe_name, ingredient_name)
    local recipe = data.raw.recipe[recipe_name]
    if (recipe == nil) then
        error("Can't find recipe \""..recipe_name.."\"")
    end
    local ingredients = recipe.ingredients
    for i = #ingredients, 1, -1 do
        if ingredients[i].name == ingredient_name then
            table.remove(ingredients, i)
            return
        end
    end
    error("In recipe \""..recipe_name.." can't find ingredient \""..ingredient_name.."\"")
end

function table_keys_to_table(t)
    local res = {}
    for k, _ in pairs(t) do
        table.insert(res, k)
    end
    return res
end

function tech_remove_prerequisite(tech_name, prerequisite_name)
    local tech = data.raw["technology"][tech_name]
    if (tech == nil) then
        error("Can't find tech \""..tech_name.."\"")
    end
    local prerequisites = tech.prerequisites
    if (prerequisites == nil) then
        error("Tech \""..tech_name.."\" doesn't have any prerequisites")
    end
    if not table_remove_string(prerequisites, prerequisite_name) then
        error("Tech \""..tech_name.." doesn't have prerequisite \""..prerequisite_name.."\"")
    end
end

function tech_remove_unlock(tech_name, unlock_name)
    local tech = data.raw["technology"][tech_name]
    if (tech == nil) then
        error("Can't find tech \""..tech_name.."\"")
    end
    for key, unlock in pairs(tech.effects) do
        if unlock.type == "unlock-recipe" and unlock.recipe == unlock_name then
            tech.effects[key] = nil
            return
        end
    end
    error("Tech \""..tech_name.." doesn't have unlock \""..unlock_name.."\"")
end

function table_copy(t)
  local t2 = {}
  if t == nil then
      return nil
  end
  for k,v in pairs(t) do
    t2[k] = v
  end
  return t2
end

function table_remove_string(t, str)
   for i = #t, 1, -1 do
        if t[i] == str then
            table.remove(t, i)
            return true
        end
    end
    return false
end

function table_empty(t)
    return rawequal(next(t), nil)
end

function tech_find_loop_remove(techs, req)
    for k, v in pairs(req) do
        if techs[v] == nil then
            req[k] = nil
        end
    end
end

function tech_find_loop()
    local techs = {}
    for k, v in pairs(data.raw.technology) do
        local req = table_copy(v.prerequisites)
        if req ~= nil then
            techs[k] = {}
            techs[k].req = req
        end
    end
    for counter = 0, 1000 do
        for k, v in pairs(techs) do
            tech_find_loop_remove(techs, v.req)
            if table_empty(v.req) then
                techs[k] = nil
             end
        end
    end
    if not table_empty(techs) then
        error("Tech loop: "..serpent.block(techs))
    end
end
