//
//  NewsTableViewCell.swift
//  NewsEdge
//
//  Created by Arabaz Ahamad on 20/07/25.
//

import UIKit

class NewsTableViewCell: UITableViewCell {

    @IBOutlet weak var imgVw: UIImageView!
    @IBOutlet weak var articleTitleLbl: UILabel!
    @IBOutlet weak var autherLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var bookmarkBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
