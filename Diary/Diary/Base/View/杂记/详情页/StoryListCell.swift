//
//  StoryListCell.swift
//  Diary
//
//  Created by 冯才凡 on 2019/7/21.
//  Copyright © 2019 冯才凡. All rights reserved.
//

import UIKit

class StoryListCell: UITableViewCell {
    @IBOutlet weak var cardBg: UIView!
    @IBOutlet weak var titleL: UILabel!
    @IBOutlet weak var timeL: UILabel!
    @IBOutlet weak var detailL: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.cardBg.backgroundColor = UIColor.randomColor().withAlphaComponent(0.1)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
