//
//  NewsCell.swift
//  WPBrowser
//
//  Created by ymgn on 2018/11/15.
//  Copyright © 2018 ymgn. All rights reserved.
//

import UIKit

class NewsCell: UITableViewCell {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
