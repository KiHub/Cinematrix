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
    
        guard let url = URL(string: "\(Constants.baseUrl)/3/trending/movie/day?api_key=\(Constants.key)") else { return }
        //MARK: - Receiving data
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else { return }
            //MARK: - Convert data to json
            do {
                let results = try JSONDecoder().decode(TrendyMoviesResponse.self, from: data)
                completion(.success(results.results))
            //    print(results.results[1].title)
            } catch {
                completion(.failure(APIError.failedGetData))
            }
        }
        task.resume()
    }
    
    func getUpcomingMovies (completion: @escaping (Result<[Movie], Error>) -> Void ) {
        guard let url = URL(string: "\(Constants.baseUrl)/3/movie/upcoming?api_key=\(Constants.key)&language=en-US&page=1") else { return }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else { return }
            do {
                let results = try JSONDecoder().decode(TrendyMoviesResponse.self, from: data)
                completion(.success(results.results))
            } catch {
                completion(.failure(APIError.failedGetData))
            }
        }
        task.resume()
    }
    
    func getPopular (completion: @escaping (Result<[Movie], Error>) -> Void ) {
        guard let url = URL(string: "\(Constants.baseUrl)/3/movie/popular?api_key=\(Constants.key)&language=en-US&page=1") else { return }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else { return }
            do {
                let results = try JSONDecoder().decode(TrendyMoviesResponse.self, from: data)
                completion(.success(results.results))
            } catch {
                completion(.failure(APIError.failedGetData))
            }
        }
        task.resume()
    }
    
    func getTopratedMovies (completion: @escaping (Result<[Movie], Error>) -> Void ) {
        guard let url = URL(string: "\(Constants.baseUrl)/3/movie/top_rated?api_key=\(Constants.key)&language=en-US&page=1") else { return }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else { return }
            do {
                let results = try JSONDecoder().decode(TrendyMoviesResponse.self, from: data)
                completion(.success(results.results))
            } catch {
                completion(.failure(APIError.failedGetData))
            }
        }
        task.resume()
    }
    
    func getSearchTopMovies (completion: @escaping (Result<[Movie], Error>) -> Void ) {
        
        guard let url = URL(string: "\(Constants.baseUrl)/3/discover/movie?api_key=\(Constants.key)&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&with_watch_monetization_types=flatrate") else { return }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else { return }
            do {
                let results = try JSONDecoder().decode(TrendyMoviesResponse.self, from: data)
                completion(.success(results.results))
            } catch {
                completion(.failure(APIError.failedGetData))
            }
        }
        task.resume()
    }
        
    func search(with query: String, completion: @escaping (Result<[Movie], Error>) -> Void ) {
        
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        guard let url = URL(string: "\(Constants.baseUrl)/3/search/movie?api_key=\(Constants.key)&query=\(query)") else { return }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else { return }
            do {
                let results = try JSONDecoder().decode(TrendyMoviesResponse.self, from: data)
                completion(.success(results.results))
            } catch {
                completion(.failure(APIError.failedGetData))
            }
        }
        task.resume()
    }

    func getMovie(with query: String, completion: @escaping (Result<Video, Error>) -> Void) {
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        guard let url = URL(string: "\(Constants.youtubeUrl)q=\(query)&key=\(Constants.youKey)") else { return }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else { return }
            do {
                let results = try JSONDecoder().decode(YoutubeSearchResponce.self , from: data)
                completion(.success(results.items[0]))
            } catch {
                completion(.failure(error))
                print(error.localizedDescription)
            }
        }
        task.resume()
        
    }
}
