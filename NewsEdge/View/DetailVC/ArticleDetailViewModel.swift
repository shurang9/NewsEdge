//
//  ArticleDetailViewModel.swift
//  NewsEdge
//
//  Created by Arabaz Ahamad on 21/07/25.
//

import Foundation

class ArticleDetailViewModel {
    private let article: Article

    init(article: Article) {
        self.article = article
    }

    var titleText: String {
        return article.title
    }

    var authorText: String {
        return article.author ?? "Unknown Author"
    }

    var dateText: String {
        return article.publishedAt ?? "Unknown Date"
    }

    var descriptionText: String {
        return article.description ?? "No Description Available"
    }

    var imageURL: URL? {
        guard let urlStr = article.urlToImage else { return nil }
        return URL(string: urlStr)
    }
}
