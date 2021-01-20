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
