//
//  TaskViewCell.swift
//  todoManager
//
//  Created by van on 20.10.2023.
//

import UIKit

class TaskViewCell: UITableViewCell {
    
    @IBOutlet var symbol: UILabel!
    
    @IBOutlet var title: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
