//
//  FavListViewController.swift
//  IOS_API_Project
//
//  Created by user235740 on 12/8/23.
//

import UIKit

class FavListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var favoriteRecipes: [MealModel.DetailsRecipe] = []

        override func viewDidLoad() {
            super.viewDidLoad()

            // Load favorite recipes from UserDefaults
            loadFavoriteRecipes()

            // Set up the table view
            tableView.dataSource = self
            tableView.delegate = self
            tableView.reloadData()
        }

        // MARK: - UITableViewDataSource methods
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           return 90
       }
   

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return favoriteRecipes.count
            
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FavListCell", for: indexPath) as! FavListTableViewCell
            
            let favoriteRecipes = favoriteRecipes[indexPath.row]
            
            // Configure the cell as needed using the recipe details
            cell.RecipeName?.text = favoriteRecipes.strMeal
            
            //  Download and set the image asynchronously
            if let imageUrl = URL(string: favoriteRecipes.strMealThumb) {
                URLSession.shared.dataTask(with: imageUrl) { data, _, error in
                    if let data = data, let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            cell.recipeImageView?.image = image
                        }
                    } else {
                        print("Error downloading image: \(error?.localizedDescription ?? "error")")
                    }
                }.resume()
            }
            
            return cell
        }


      //   Load favorite recipes from UserDefaults
        func loadFavoriteRecipes() {
            if let loadedFavorites = UserDefaults.standard.stringArray(forKey: "FavoriteRecipes") {
                
                fetchDetailsForFavoriteRecipes(loadedFavorites)
               
            }
        }
    
    func fetchDetailsForFavoriteRecipes(_ recipeIDs: [String]) {
            for recipeID in recipeIDs {
                NetworkManager.shared.fetchRecipeDetails(for: recipeID) { result in
                    switch result {
                    case .success(let recipe):
                        self.favoriteRecipes.append(recipe)
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    case .failure(let error):
                        print("Details Fetch Error:", error)
                    }
                }
            }
        }

    }
