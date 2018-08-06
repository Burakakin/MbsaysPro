//
//  MainPageCustomTableViewCell.swift
//  MbsaysProject
//
//  Created by Burak Akin on 31.07.2018.
//  Copyright © 2018 Burak Akin. All rights reserved.
//

import UIKit

class MainPageCustomTableViewCell: UITableViewCell {

    @IBOutlet weak var mainPageTitle: UILabel!
    @IBOutlet weak var mainPageDescription: UILabel!
    @IBOutlet weak var mainPageImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
