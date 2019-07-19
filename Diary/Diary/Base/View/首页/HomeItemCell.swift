//
//  HomeItemCell.swift
//  Tally
//
//  Created by 冯才凡 on 2019/6/24.
//  Copyright © 2019 冯才凡. All rights reserved.
//

import UIKit

class HomeItemCell: UICollectionViewCell {

    @IBOutlet weak var cardBg: UIView!
    @IBOutlet weak var moneyL: UILabel!
    @IBOutlet weak var timeL: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cardBg.backgroundColor = UIColor.randomColor()
        
        self.layer.cornerRadius = 4
        self.layer.masksToBounds = true
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.hex("dbdbdb").cgColor
    }

}
