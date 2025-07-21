//
//  Model.swift
//  NewsEdge
//
//  Created by Arabaz Ahamad on 19/07/25.
//

import Foundation



// MARK: - Models
struct Article: Codable {
    let title: String
    let author: String?
    let publishedAt: String?
    let urlToImage: String?
    let url: String?
    let description: String?
    var isFavorite: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case title, author, publishedAt, urlToImage, url, description
        // exclude isFavorite so it's ignored in JSON decoding
    }
    
}

struct NewsResponse: Codable {
    let articles: [Article]
}

//struct ArticleResponse: Codable {
//    let status: String
//    let totalResults: Int
//    let articles: [Article]
//}
//
//struct Article: Codable {
//    let source: Source
//    let author: String?
//    let title: String?
//    let description: String?
//    let url: String?
//    let urlToImage: String?
//    let publishedAt: String?
//    let content: String?
//}
//
//struct Source: Codable {
//    let id: String?
//    let name: String?
//}
//
//
//let mockArticles: [Article] = [
//    Article(
//        source: Source(id: "cnn", name: "CNN"),
//        author: "John Doe",
//        title: "Swift 6 Will Revolutionize iOS Development",
//        description: "Swift 6 is expected to bring major improvements...",
//        url: "https://www.cnn.com/swift-6",
//        urlToImage: "https://via.placeholder.com/150",
//        publishedAt: "2024-07-18T10:00:00Z",
//        content: "Apple is preparing to release Swift 6 with exciting new features..."
//    ),
//    Article(
//        source: Source(id: "bbc", name: "BBC News"),
//        author: "Jane Smith",
//        title: "iOS 18 Launches with AI Features",
//        description: "The newest version of iOS introduces on-device AI...",
//        url: "https://www.bbc.com/ios-18-launch",
//        urlToImage: "https://via.placeholder.com/150",
//        publishedAt: "2024-07-17T08:30:00Z",
//        content: "Apple has officially released iOS 18 which integrates ChatGPT-like capabilities..."
//    ),
//    Article(
//        source: Source(id: "techcrunch", name: "TechCrunch"),
//        author: "Alex Johnson",
//        title: "Understanding MVVM in UIKit Apps",
//        description: "MVVM architecture is widely used in iOS apps...",
//        url: "https://www.techcrunch.com/mvvm-ios",
//        urlToImage: "https://via.placeholder.com/150",
//        publishedAt: "2024-07-16T12:45:00Z",
//        content: "MVVM (Model-View-ViewModel) helps in separating concerns in UIKit apps..."
//    )
//]
