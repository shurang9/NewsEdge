//
//  HomeViewModel.swift
//  NewsEdge
//
//  Created by Arabaz Ahamad on 20/07/25.
//

import Foundation
import UIKit
import CoreData

class HomeViewModel {

    var articles: [Article] = [] {
            didSet {
                filteredArticles = articles
                onUpdate?()
            }
        }
        var filteredArticles: [Article] = []
        var onUpdate: (() -> Void)?

        func fetch() {
            APIService.shared.fetchArticles { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let articles):
                        self?.saveToCoreData(articles: articles)
                        //self?.articles = self?.loadFromCoreData() ?? []
                        self?.fetchFromCoreData()
                    case .failure(let error):
                        print("Error fetching: \(error)")
                        //self?.articles = self?.loadFromCoreData() ?? []
                        self?.fetchFromCoreData()
                    }
                }
            }
        }
    
    func fetchFromCoreData() {
        self.articles = self.loadFromCoreData()
    }

        func search(with query: String) {
            if query.isEmpty {
                filteredArticles = articles
            } else {
                filteredArticles = articles.filter {
                    $0.title.lowercased().contains(query.lowercased())
                }
            }
            onUpdate?()
        }
    
    // MARK: - Core Data Caching
    private func saveToCoreData(articles: [Article]) {
        let coreData = CoreDataManager.shared

        // Remove all non-bookmarked
        coreData.clearNonBookmarkedArticles()

        for article in articles {
            coreData.insertOrUpdate(article: article)
        }

        coreData.saveContext()
    }
    
    private func loadFromCoreData() -> [Article] {
        let cdArticles = CoreDataManager.shared.fetchAllArticles()
        return cdArticles.map { obj in
            Article(
                title: obj.value(forKey: "title") as? String ?? "",
                author: obj.value(forKey: "author") as? String,
                publishedAt: obj.value(forKey: "publishedAt") as? String,
                urlToImage: obj.value(forKey: "urlToImage") as? String,
                url: obj.value(forKey: "url") as? String,
                description: obj.value(forKey: "descriptions") as? String,
                isFavorite: obj.value(forKey: "isFavorite") as? Bool ?? false
            )
        }
    }

    func toggleBookmark(for index: Int) {
        guard index < filteredArticles.count else { return }
        let article = filteredArticles[index]
        let newStatus = !article.isFavorite

        if let mainIndex = articles.firstIndex(where: { $0.title == article.title }) {
            articles[mainIndex].isFavorite = newStatus
        }
        filteredArticles[index].isFavorite = newStatus
        onUpdate?()

        if let cdArticle = CoreDataManager.shared.findArticle(byTitle: article.title) {
            cdArticle.setValue(newStatus, forKey: "isFavorite")
            CoreDataManager.shared.saveContext()
        }
    }

    
}
