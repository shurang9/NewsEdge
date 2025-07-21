//
//  BookmarkViewModel.swift
//  NewsEdge
//
//  Created by Arabaz Ahamad on 20/07/25.
//

import Foundation
import CoreData
import UIKit

class BookmarkViewModel {
    var bookmarks: [Article] = [] {
        didSet {
            onUpdate?()
        }
    }
    
    var onUpdate: (() -> Void)?

    func fetchBookmarks() {
        let cdArticles = CoreDataManager.shared.fetchBookmarkedArticles()
        self.bookmarks = cdArticles.map { obj in
            Article(
                title: obj.value(forKey: "title") as? String ?? "",
                author: obj.value(forKey: "author") as? String,
                publishedAt: obj.value(forKey: "publishedAt") as? String,
                urlToImage: obj.value(forKey: "urlToImage") as? String,
                url: obj.value(forKey: "url") as? String,
                description: obj.value(forKey: "descriptions") as? String,
                isFavorite: true
            )
        }
    }


    func removeBookmark(at index: Int) {
        let article = bookmarks[index]
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        let request: NSFetchRequest<NSManagedObject> = NSFetchRequest(entityName: "CDArticle")
        request.predicate = NSPredicate(format: "title == %@", article.title)
        
        if let result = try? context.fetch(request), let obj = result.first {
            obj.setValue(false, forKey: "isFavorite")
            try? context.save()
        }
        fetchBookmarks()
    }
}
