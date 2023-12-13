//
//  CategoryViewController.swift
//  IOS_API_Project
//
//  Created by user235740 on 12/6/23.
//

import UIKit

class CategoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var categories = [MealModel.Category]()
    
    var categoryName : String?
    
    var selectedCategoryDetails: MealModel.Category?
    
    var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        // Add an activity indicator to the view
        activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        showActivityIndicator()
        
        // Call the API and populate the categories array
        fetchCategories()
    }
    
    
    func fetchCategories() {
        NetworkManager.shared.fetchCategories { result in
            switch result {
            case .success(let categories):
                self.hideActivityIndicator()
                self.categories = categories
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print("Category Fetch Error:", error)
            }
        }
    }
    
    func showActivityIndicator() {
           DispatchQueue.main.async {
               self.activityIndicator.startAnimating()
           }
       }

       func hideActivityIndicator() {
           DispatchQueue.main.async {
               self.activityIndicator.stopAnimating()
           }
       }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
        
        let category = categories[indexPath.row]
        cell.categoryName?.text = category.strCategory
        
        //  Download and set the image asynchronously
        if let imageUrl = URL(string: category.strCategoryThumb) {
            URLSession.shared.dataTask(with: imageUrl) { data, _, error in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        cell.categoryImage?.image = image
                    }
                } else {
                    print("Error downloading image: \(error?.localizedDescription ?? "error")")
                }
            }.resume()
        }
        
        return cell
    }
    

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            performSegue(withIdentifier: "showRecipes", sender: indexPath)
        }

        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "showRecipes" {
                if let viewController = segue.destination as? ViewController,
                   let selectedIndexPath = sender as? IndexPath {
                    
                    // Pass the selected category name to ViewController
                    viewController.recipeName = categories[selectedIndexPath.row].strCategory
                }
            }
        }
}
