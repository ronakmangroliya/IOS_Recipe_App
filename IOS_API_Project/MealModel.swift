//
//  MealModel.swift
//  IOS_API_Project
//
//  Created by user235740 on 12/4/23.
//


import Foundation

class MealModel {

    // Model for recipe data
    struct Recipe: Codable {
        let strMeal: String
        let strMealThumb: String
        let idMeal: String
    }

    struct Category: Codable {
        let idCategory: String
        let strCategory: String
        let strCategoryThumb: String
        let strCategoryDescription: String
        var recipes: [Recipe] = []
        
        private enum CodingKeys: String, CodingKey {
            case idCategory, strCategory, strCategoryThumb, strCategoryDescription
        }
    }
    
    struct DetailsRecipe: Codable {
        let idMeal: String
        let strMeal: String
        let strDrinkAlternate: String?
        let strCategory: String
        let strArea: String
        let strInstructions: String
        let strMealThumb: String
        
    }

    struct CategoriesResponse: Codable {
        let categories: [Category]
    }


    struct RecipesResponse: Codable {
        let meals: [Recipe]
    }
    

    struct DetailsResponse: Codable {
        let meals: [DetailsRecipe]
    }

}

