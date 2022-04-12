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
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    func getTrendyTv(completion: @escaping (Result<[Tv], Error>) -> Void ) {
        guard let url = URL(string: "\(Constants.baseUrl)/3/trending/tv/day?api_key=\(Constants.key)") else { return }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else { return}
            do {
                let results = try JSONDecoder().decode(TrendyTvResponse.self, from: data)
                print(results)
           //     completion(.success(results.results))
            } catch {
                print(error.localizedDescription)
            //    completion(.failure(error))
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
                print(results)
            } catch {
                print(error.localizedDescription)
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
                print(results)
            } catch {
                print(error.localizedDescription)
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
                print(results)
            } catch {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
            
}
            