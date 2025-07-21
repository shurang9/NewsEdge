//
//  BookmarksViewController.swift
//  NewsEdge
//
//  Created by Arabaz Ahamad on 19/07/25.
//

import UIKit

class BookmarksViewController: UIViewController {
    
    @IBOutlet weak var bookmarksNewsTblVw: UITableView!
    @IBOutlet weak var noBookmarksVw: UIView!
    
    let viewModel = BookmarkViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchBookmarks()
    }

    func setupUI(){
        self.title = "Bookmarks"
        
        let nib = UINib(nibName: "NewsTableViewCell", bundle: nil)
        bookmarksNewsTblVw.register(nib, forCellReuseIdentifier: "NewsTableViewCell")
        bookmarksNewsTblVw.delegate = self
        bookmarksNewsTblVw.dataSource = self
        
        bindViewModel()
        viewModel.fetchBookmarks()
        noBookmarksVw.layer.cornerRadius = 20.0
    }
    
    func bindViewModel() {
        viewModel.onUpdate = { [weak self] in
            DispatchQueue.main.async {
                if self?.viewModel.bookmarks.count == 0{
                    self?.noBookmarksVw.isHidden = false
                }else{
                    self?.noBookmarksVw.isHidden = true
                }
                self?.bookmarksNewsTblVw.reloadData()
            }
        }
    }
}

extension BookmarksViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.bookmarks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let article = viewModel.bookmarks[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTableViewCell", for: indexPath) as! NewsTableViewCell
        cell.articleTitleLbl.text = article.title
        cell.autherLbl.text = article.author
        cell.dateLbl.text = article.publishedAt
        if let urlStr = article.urlToImage, let url = URL(string: urlStr) {
            cell.imgVw.sd_setImage(with: url, placeholderImage: UIImage(systemName: "photo"))
        } else {
            cell.imgVw.image = UIImage(systemName: "photo")
        }
        
        cell.bookmarkBtn.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
        cell.bookmarkBtn.tag = indexPath.row
        cell.bookmarkBtn.addTarget(self, action: #selector(removeBookmark(_:)), for: .touchUpInside)
        cell.selectionStyle = .none
        return cell
    }
    
    @objc func removeBookmark(_ sender: UIButton) {
        viewModel.removeBookmark(at: sender.tag)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let NewsDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "NewsDetailViewController") as! NewsDetailViewController
        NewsDetailVC.viewModel = ArticleDetailViewModel(article: viewModel.bookmarks[indexPath.row])
        self.navigationController?.pushViewController(NewsDetailVC, animated: true)
    }
}
