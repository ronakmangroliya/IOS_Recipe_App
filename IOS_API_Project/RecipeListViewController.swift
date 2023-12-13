//
//  ViewController.swift
//  IOS_API_Project
//
//  Created by user235740 on 11/30/23.
//



import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
        
    var recipes: [MealModel.Recipe] = []
    
    var recipeName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the delegate and data source for the table view
        tableView.delegate = self
        tableView.dataSource = self
        
        // Call the API and populate the categories array
        if let categoryName = recipeName {
            
            fetchRecipes(for: categoryName)
        }
    }
    
    func fetchRecipes(for categoryName: String) {
        NetworkManager.shared.fetchRecipes(for: categoryName) { result in
            switch result {
            case .success(let recipes):
                self.recipes = recipes
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print("Recipe Fetch Error:", error)
            }
        }
    }


    
    // MARK: - UITableViewDataSource and UITableViewDelegate methods
    
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 100
        }
    
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            // Return the number of rows based on the selected category
            return recipes.count
        }
    
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell", for: indexPath) as! RecipeCell
            
            // Configure the cell with recipe data based on the selected category
            let recipe = recipes[indexPath.row]
            
                cell.details?.text = recipe.strMeal
            
            //  Download and set the image asynchronously
            if let imageUrl = URL(string: recipe.strMealThumb) {
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
    
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            // Trigger the segue when a cell is selected
            performSegue(withIdentifier: "showDetailsSegue", sender: self)
    
        }
    
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
               if segue.identifier == "showDetailsSegue" {
                   if let detailsViewController = segue.destination as? DetailsViewController {
    
                       // Pass the selected recipe to the details view controller
                       if let selectedIndexPath = tableView.indexPathForSelectedRow {
                           let selectedRecipe = recipes[selectedIndexPath.row]
                           detailsViewController.recipeID = selectedRecipe.idMeal
                       }
                   }
               }
           }
    }
