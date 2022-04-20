//
//  DataPersistentManager.swift
//  Cinematrix
//
//  Created by  Mr.Ki on 15.04.2022.
//

import Foundation
import UIKit
import CoreData

class DataPersistentManager {
    
    enum CoreDataErrors: Error {
        case failedToSave
        case failedToFetchData
        case failedToDelete
    }
    
    static let shared = DataPersistentManager()
    
    func downloadMovieToDataBase(model: Movie, completion: @escaping (Result<Void, Error>) -> Void) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let context = appDelegate.persistentContainer.viewContext
        
        let item = MovieItem(context: context)

        item.title = model.title
        item.id = Int64(model.id)
        item.original_title = model.original_title
        item.overview = model.overview
        item.media_type = model.media_type
        item.poster_path = model.poster_path
        item.release_date = model.release_date
        item.vote_count = Int64(model.vote_count)
        item.vote_average = model.vote_average
        
        do {
            try context.save()
            completion(.success(()))
            print("Saved")
        } catch {
                completion(.failure(CoreDataErrors.failedToSave))
            print(error.localizedDescription)
        }
    }
    
    func fetchMoviesFromDataBase(completion : @escaping (Result<[MovieItem], Error>) -> Void) {
   
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
            let context = appDelegate.persistentContainer.viewContext
        
            let request: NSFetchRequest<MovieItem>
            request = MovieItem.fetchRequest()
        
        do {
           let movies = try context.fetch(request)
            completion(.success(movies))
        } catch {
            completion(.failure(CoreDataErrors.failedToFetchData))
        }
        
    }
    
    func deleteMoviesFromDataBase(model: MovieItem, completion: @escaping (Result<Void, Error>) -> Void) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let context = appDelegate.persistentContainer.viewContext
        context.delete(model)
        
        do {
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(CoreDataErrors.failedToDelete))
        }
        
    }
    
}
