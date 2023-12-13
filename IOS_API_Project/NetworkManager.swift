//
//  NetworkManager.swift
//  IOS_API_Project
//
//  Created by user235740 on 12/4/23.
//

import Foundation

class NetworkManager {
    
    // Singleton instance
       static let shared = NetworkManager()

       private let baseURL = "https://www.themealdb.com/api/json/v1/1/"

       private init() {}
    
    // MARK: - Fetch Categories

       func fetchCategories(completionHandler: @escaping (Result<[MealModel.Category], Error>) -> Void) {
           let url = URL(string: baseURL + "categories.php")!

           URLSession.shared.dataTask(with: url) { data, response, error in
               if let error = error {
                   completionHandler(.failure(error))
                   return
               }

               guard let data = data else {
                   let error = NSError(domain: "", code: 500, userInfo: [NSLocalizedDescriptionKey: "No data received"])
                   completionHandler(.failure(error))
                   return
               }

               do {
                   let result = try JSONDecoder().decode(MealModel.CategoriesResponse.self, from: data)
                   completionHandler(.success(result.categories))
               } catch {
                   completionHandler(.failure(error))
               }
           }.resume()
       }

       // MARK: - Fetch Recipes Names

       func fetchRecipes(for categoryName: String, completionHandler: @escaping (Result<[MealModel.Recipe], Error>) -> Void) {
           let url = URL(string: baseURL + "filter.php?c=\(categoryName)")!

           URLSession.shared.dataTask(with: url) { data, response, error in
               if let error = error {
                   completionHandler(.failure(error))
                   return
               }

               guard let data = data else {
                   let error = NSError(domain: "", code: 500, userInfo: [NSLocalizedDescriptionKey: "No data received"])
                   completionHandler(.failure(error))
                   return
               }

               do {
                   let result = try JSONDecoder().decode(MealModel.RecipesResponse.self, from: data)
                   completionHandler(.success(result.meals))
               } catch {
                   completionHandler(.failure(error))
               }
           }.resume()
       }

       // MARK: - Fetch Recipe Details

       func fetchRecipeDetails(for recipeID: String, completionHandler: @escaping (Result<MealModel.DetailsRecipe, Error>) -> Void) {
           let url = URL(string: baseURL + "lookup.php?i=\(recipeID)")!

           URLSession.shared.dataTask(with: url) { data, response, error in
               if let error = error {
                   completionHandler(.failure(error))
                   return
               }

               guard let data = data else {
                   let error = NSError(domain: "", code: 500, userInfo: [NSLocalizedDescriptionKey: "No data received"])
                   completionHandler(.failure(error))
                   return
               }

               do {
                   let result = try JSONDecoder().decode(MealModel.DetailsResponse.self, from: data)

                   if let recipe = result.meals.first {
                       completionHandler(.success(recipe))
                   } else {
                       let error = NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "Recipe not found"])
                       completionHandler(.failure(error))
                   }
               } catch {
                   completionHandler(.failure(error))
               }
           }.resume()
       }
   }
