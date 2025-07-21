//
//  NewsDetailViewController.swift
//  NewsEdge
//
//  Created by Arabaz Ahamad on 20/07/25.
//

import UIKit

class NewsDetailViewController: UIViewController {
    
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var articleTitle: UILabel!
    @IBOutlet weak var authorLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var newsDescriptionLbl: UILabel!
    
    var viewModel: ArticleDetailViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    private func setUpUI() {
        articleTitle.text = viewModel.titleText
        authorLbl.text = viewModel.authorText
        dateLbl.text = viewModel.dateText
        newsDescriptionLbl.text = viewModel.descriptionText
        
        if let url = viewModel.imageURL {
            img.sd_setImage(with: url, placeholderImage: UIImage(named: "img"))
        } else {
            img.image = UIImage(named: "img")
        }
    }
}
