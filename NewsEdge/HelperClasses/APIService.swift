//
//  APIService.swift
//  NewsEdge
//
//  Created by Arabaz Ahamad on 20/07/25.
//

// MARK: - API Service
import Alamofire

class APIService {
    static let shared = APIService()
    private let url = "https://newsapi.org/v2/everything?q=apple&from=2025-07-19&to=2025-07-19&sortBy=popularity&apiKey=8c54ed99d0ab4dd5af42ee9f2cf9ba37"

    func fetchArticles(completion: @escaping (Result<[Article], Error>) -> Void) {
        AF.request(url).responseDecodable(of: NewsResponse.self) { response in
            switch response.result {
            case .success(let news):
                var articlesWithFavorites = news.articles
                for i in 0..<articlesWithFavorites.count {
                    articlesWithFavorites[i].isFavorite = false
                }
                completion(.success(articlesWithFavorites))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
