//
//  FavContentPageTableViewCell.swift
//  MbsaysProject
//
//  Created by Burak Akin on 14.08.2018.
//  Copyright © 2018 Burak Akin. All rights reserved.
//

import UIKit

class FavContentPageTableViewCell: UITableViewCell {

    @IBOutlet weak var favContentImageView: UIImageView!
    @IBOutlet weak var favContentTitleLabel: UILabel!
    @IBOutlet weak var favContentDescriptionlbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
