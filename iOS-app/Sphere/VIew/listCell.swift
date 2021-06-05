//
//  listCell.swift
//  Sphere
//
//  Created by Deepak on 23/03/19.
//  Copyright © 2019 D Developer. All rights reserved.
//

import UIKit

class listCell: UITableViewCell {

    @IBOutlet weak var taskTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
