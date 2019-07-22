//
//  ReadItemCell.swift
//  Diary
//
//  Created by 冯才凡 on 2019/7/21.
//  Copyright © 2019 冯才凡. All rights reserved.
//

import UIKit

class ReadItemCell: UICollectionViewCell {
    @IBOutlet weak var bgImag: UIImageView!
    @IBOutlet weak var nameL: UILabel!
    @IBOutlet weak var detailL: UILabel!
    @IBOutlet weak var desL: UILabel!
    @IBOutlet weak var timeL: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bgImag.backgroundColor = UIColor.randomColor().withAlphaComponent(0.6)
        contentView.backgroundColor = UIColor.white
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
    }

}
