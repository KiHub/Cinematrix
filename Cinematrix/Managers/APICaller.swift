//
//  APICaller.swift
//  Cinematrix
//
//  Created by  Mr.Ki on 12.04.2022.
//

import Foundation

enum APIError: Error {
    case failedGetData
}

class APICaller {
    static let shared = APICaller()
    
    
    func getTrendyMovies(completion: @escaping (Result<[Movie], Error>) -> Void ) {
    
        guard let url = URL(string: "\(Constants.baseUrl)/3/trending/all/day?api_key=\(Constants.key)") else {return}
        //MARK: - Receiving data
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else { return }
            //MARK: - Convert data to json
            do {
                let results = try JSONDecoder().decode(TrendyMoviesResponse.self, from: data)
                completion(.success(results.results))
            //    print(results.results[1].title)
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
              
}
            
