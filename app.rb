require 'bundler'
Bundler.require

json = JSON.load(URI.open("https://raw.githubusercontent.com/QuentinBerard/BotRecettes-Ruby/main/recipes.json"))

def valid_recipes (json, ingredients_frigo)
  tabRecettes= []
  nomRecettes =[]
  json.each do |recette|
    ingredients_frigo.each do |ingredient|
      if recette["ingredients"].include?ingredient
        tabRecettes.push(recette["recipe_id"])
      end
    end
  end
  tabRecettes.uniq!
  tabRecettes.each do |num_recette|
    json.each do |recette|
      if num_recette == recette["recipe_id"]
        nomRecettes.push(recette["recipe_name"])
      end
    end
  end
  return nomRecettes
end

def cook_ingredients (json, recipe)
  tabIngredients = []
  json.each do |item|
    if recipe == item["recipe_name"]
      item["ingredients"].each do |key, value|
        tabIngredients.push(key+ " : " +value)
      end
      return tabIngredients
    end
  end
end

def cook_steps (json, recipe)
  tabSteps = []
  json.each do |item|
    if recipe == item["recipe_name"]
      item["steps"].each do |step|
        tabSteps.push(step)
      end
      return tabSteps
    end
  end
end



get '/' do
   erb:index
end

post '/' do
 @name = params[:name]
 erb:ingredientQuery
end

post '/ingredient' do
  @ingredients_frigo = params[:ingredient].split(",").map(&:strip).map(&:capitalize)
  @nomRecettes = valid_recipes(json, @ingredients_frigo)
  erb:recettes
end

post '/recipe' do
 @recipe = params[:recipe]
 @cook_ingredients = cook_ingredients(json, @recipe)
 @cook_steps = cook_steps(json, @recipe)
 erb:cook
end

get '/ingredientQuery.erb' do
   erb:ingredientQuery
end
