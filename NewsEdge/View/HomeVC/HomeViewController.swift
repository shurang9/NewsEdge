//
//  HomeViewController.swift
//  NewsEdge
//
//  Created by Arabaz Ahamad on 19/07/25.
//

import UIKit
import SDWebImage

class HomeViewController: UIViewController {
    
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var newsTblVw: UITableView!
    @IBOutlet weak var searhTextField: UITextField!
    @IBOutlet weak var searchBackBtn: UIButton!
    
    
    var isSearch : Bool = false
    let viewModel = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        bindViewModel()
        viewModel.fetch()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchFromCoreData()
    }
    
    func bindViewModel() {
        viewModel.onUpdate = { [weak self] in
            self?.newsTblVw.reloadData()
        }
    }
    
    func setUpUI(){
        
        searhTextField.delegate = self
        searhTextField.placeholder = "Search here..."
        searhTextField.returnKeyType = .search
        searhTextField.clearButtonMode = .whileEditing
        searhTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        let nib = UINib(nibName: "NewsTableViewCell", bundle: nil)
        newsTblVw.register(nib, forCellReuseIdentifier: "NewsTableViewCell")
        newsTblVw.delegate = self
        newsTblVw.dataSource = self

    }
    
    
    @IBAction func didTapSearchBackBtn(_ sender: UIButton) {
        if isSearch{
            titleLbl.isHidden = false
            searchBackBtn.isHidden = true
            isSearch = false
            searhTextField.text = ""
            searhTextField.isHidden = true
        }
    }
    
    @IBAction func didTapSearchBtn(_ sender: UIButton) {
        if !isSearch{
            titleLbl.isHidden = true
            searchBackBtn.isHidden = false
            isSearch = true
            searhTextField.isHidden = false
            searhTextField.becomeFirstResponder()
        }
        
    }
    
    
}

extension HomeViewController: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        let query = textField.text ?? ""
        viewModel.search(with: query)
        
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filteredArticles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let article = viewModel.filteredArticles[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTableViewCell", for: indexPath) as! NewsTableViewCell
        cell.articleTitleLbl.text = article.title
        cell.autherLbl.text = article.author
        cell.dateLbl.text = article.publishedAt
        if let imgUrl = article.urlToImage, let url = URL(string: imgUrl) {
            cell.imgVw.sd_setImage(with: url, placeholderImage: UIImage(named: "img"))
        } else {
            cell.imgVw.image = UIImage(named: "img")
        }
        let bookmarkImage = article.isFavorite ? UIImage(systemName: "bookmark.fill") : UIImage(systemName: "bookmark")
        cell.bookmarkBtn.setImage(bookmarkImage, for: .normal)
        cell.bookmarkBtn.tag = indexPath.row
        cell.bookmarkBtn.addTarget(self, action: #selector(bookmarkTapped(_:)), for: .touchUpInside)
        cell.selectionStyle = .none
        return cell
    }
    @objc func bookmarkTapped(_ sender: UIButton) {
        viewModel.toggleBookmark(for: sender.tag)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let NewsDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "NewsDetailViewController") as! NewsDetailViewController
        NewsDetailVC.viewModel = ArticleDetailViewModel(article: viewModel.filteredArticles[indexPath.row])
        self.navigationController?.pushViewController(NewsDetailVC, animated: true)
    }
    
    
    
}
