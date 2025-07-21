//
//  CoreDataManager.swift
//  NewsEdge
//
//  Created by Arabaz Ahamad on 21/07/25.
//

import Foundation
import CoreData
import UIKit

class CoreDataManager {

    static let shared = CoreDataManager()
    private init() {}

    var context: NSManagedObjectContext {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Unable to access AppDelegate")
        }
        return appDelegate.persistentContainer.viewContext
    }

    func fetchAllArticles() -> [NSManagedObject] {
        let fetchRequest: NSFetchRequest<NSManagedObject> = NSFetchRequest(entityName: "CDArticle")
        return (try? context.fetch(fetchRequest)) ?? []
    }

    func fetchBookmarkedArticles() -> [NSManagedObject] {
        let fetchRequest: NSFetchRequest<NSManagedObject> = NSFetchRequest(entityName: "CDArticle")
        fetchRequest.predicate = NSPredicate(format: "isFavorite == %@", NSNumber(value: true))
        return (try? context.fetch(fetchRequest)) ?? []
    }

    func saveContext() {
        if context.hasChanges {
            try? context.save()
        }
    }

    func delete(_ object: NSManagedObject) {
        context.delete(object)
    }

    func findArticle(byTitle title: String) -> NSManagedObject? {
        let fetchRequest: NSFetchRequest<NSManagedObject> = NSFetchRequest(entityName: "CDArticle")
        fetchRequest.predicate = NSPredicate(format: "title == %@", title)
        return (try? context.fetch(fetchRequest))?.first
    }

    func clearNonBookmarkedArticles() {
        let articles = fetchAllArticles()
        for article in articles {
            if (article.value(forKey: "isFavorite") as? Bool) == false {
                delete(article)
            }
        }
        saveContext()
    }

    func insertOrUpdate(article: Article) {
        if let existing = findArticle(byTitle: article.title) {
            // Update existing if needed
            existing.setValue(article.author, forKey: "author")
            existing.setValue(article.publishedAt, forKey: "publishedAt")
            existing.setValue(article.urlToImage, forKey: "urlToImage")
            existing.setValue(article.url, forKey: "url")
            existing.setValue(article.description, forKey: "descriptions")
        } else {
            let newArticle = NSEntityDescription.insertNewObject(forEntityName: "CDArticle", into: context)
            newArticle.setValue(article.title, forKey: "title")
            newArticle.setValue(article.author, forKey: "author")
            newArticle.setValue(article.publishedAt, forKey: "publishedAt")
            newArticle.setValue(article.urlToImage, forKey: "urlToImage")
            newArticle.setValue(article.url, forKey: "url")
            newArticle.setValue(article.description, forKey: "descriptions")
            newArticle.setValue(false, forKey: "isFavorite")
        }
    }
}
