//
//  DetailsViewController.swift
//  IOS_API_Project
//
//  Created by user235740 on 12/4/23.
//

import UIKit

class DetailsViewController: UIViewController {
    
    var mealModel = MealModel()
    
    var recipeID: String?
    var isFavorite: Bool = false
    var favoriteRecipes: [String] = []
    
    var selectedCategoryDetails: MealModel.Category?
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var categoryLabel: UILabel!
    
    @IBOutlet weak var areaLabel: UILabel!
    
    @IBOutlet weak var instructionsText: UITextView!
    
    @IBOutlet weak var recipeImageView: UIImageView!
    
    @IBOutlet weak var favoriteButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load favorite recipes from UserDefaults
        loadFavoriteRecipes()
        
        // Fetch recipe details using the recipeID
        if let recipeID = recipeID {
            fetchRecipeDetails(for: recipeID)
        }
        
        // Set the initial state of the favorite button
        isFavorite = favoriteRecipes.contains(recipeID ?? "")
        favoriteButton.isSelected = isFavorite
        
    }
    
    
    @IBAction func favoriteButton(_ sender: UIButton) {
        
        isFavorite.toggle()
        
        // Update the button state
        favoriteButton.isSelected = isFavorite
        
        if isFavorite {
            favoriteButton.setTitle("Remove Favorite", for: .normal)
            showAlert(message: "You have successfully added recipe to Favorites! ❤️")
        } else {
            favoriteButton.setTitle("Add Favorite", for: .normal)
            showAlert(message: "You have successfully removed recipe from Favorites! 💔")
        }
        
        // Save or update the favorite status in model
        updateFavoriteStatus()
    }
    
    
    // Function to show an alert
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Favorites", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func showFavItem(_ sender: Any) {
        let storyboard = UIStoryboard(name: "DetailsViewController", bundle: nil)
        
        if let favoritesViewController = storyboard.instantiateViewController(withIdentifier: "FavoritesViewController") as? FavListViewController {
            navigationController?.pushViewController(favoritesViewController, animated: true)
        }
    }
    
    
    func fetchRecipeDetails(for recipeID: String) {
        NetworkManager.shared.fetchRecipeDetails(for: recipeID) { result in
            switch result {
            case .success(let recipe):
                
                // Update UI on the main thread
                DispatchQueue.main.async {
                    self.updateUI(with: recipe)
                }
            case .failure(let error):
                print("Details Fetch Error:", error)
            }
        }
    }
    
    
    
    func updateUI(with recipe: MealModel.DetailsRecipe) {
        nameLabel.text = "Name: \(recipe.strMeal)"
        categoryLabel.text = "Category: \(recipe.strCategory)"
        areaLabel.text = "Country: \(recipe.strArea)"
        instructionsText.text = recipe.strInstructions
        
        //  Download and set the image asynchronously
        if let imageUrl = URL(string: recipe.strMealThumb) {
            URLSession.shared.dataTask(with: imageUrl) { data, _, error in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.recipeImageView.image = image
                    }
                } else {
                    print("Error downloading image: \(error?.localizedDescription ?? "error")")
                }
            }.resume()
        }
        
    }
  
    
    func updateFavoriteStatus() {
        
            // Update the favorite status in the array
            if isFavorite, let recipeID = recipeID {
                favoriteRecipes.append(recipeID)
                print("array: ", favoriteRecipes)
                print("ID: ", recipeID)
            } else if let recipeID = recipeID,
                      let index = favoriteRecipes.firstIndex(of: recipeID) {
                favoriteRecipes.remove(at: index)
            }

            // Save the updated favorite status in UserDefaults
            saveFavoriteRecipes()
        }

        func saveFavoriteRecipes() {
            UserDefaults.standard.set(favoriteRecipes, forKey: "FavoriteRecipes")
        }

        func loadFavoriteRecipes() {
            if let loadedFavorites = UserDefaults.standard.stringArray(forKey: "FavoriteRecipes") {
                favoriteRecipes = loadedFavorites
            }
        }
}
