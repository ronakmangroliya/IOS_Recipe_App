//
//  CategoryCell.swift
//  IOS_API_Project
//
//  Created by user235740 on 12/7/23.
//

import UIKit

class CategoryCell: UITableViewCell {
    
    @IBOutlet weak var categoryName: UILabel!
    
    @IBOutlet weak var categoryImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
