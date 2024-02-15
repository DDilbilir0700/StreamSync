//
//  PersistenceManager.swift
//  StreamSync
//
//  Created by Deniz Dilbilir on 29/02/2024.
//

import Foundation
import UIKit
import CoreData

class PersistenceManager {
    static let shared = PersistenceManager()
    
    func download(model : Movie, completion: @escaping(Result<Void, Error>) -> Void) {
        
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let viewContext = delegate.persistentContainer.viewContext
        let item = MovieItem(context: viewContext)
        
        item.original_title = model.original_title
        item.id             = Int64(model.id)
        item.overview       = model.overview
        item.media_type     = model.media_type
        item.poster_path    = model.poster_path
        item.release_date   = model.release_date
        item.vote_average   = model.vote_average
        item.vote_count     = Int64(model.vote_count)
        
        do {
           try viewContext.save()
            completion(.success(()))
        } catch {
            completion(.failure(error))
        }
    }
    func fetchMoviesFromData(completion: @escaping (Result<[MovieItem], Error>) -> Void) {
        
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let viewContext = delegate.persistentContainer.viewContext
        let request: NSFetchRequest<MovieItem>
        request = MovieItem.fetchRequest()
        
        do {
            
            let title = try viewContext.fetch(request)
            completion(.success(title))
            
        } catch {
            completion(.failure(error))
        }
    }
    func removeMovieWith(model: MovieItem, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let viewContext = delegate.persistentContainer.viewContext
        viewContext.delete(model)
        
        do {
            try viewContext.save()
            completion(.success(()))
        } catch {
            completion(.failure(error))
        }
    }
}
