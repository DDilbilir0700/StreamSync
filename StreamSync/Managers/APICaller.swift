//
//  APICaller.swift
//  StreamSync
//
//  Created by Deniz Dilbilir on 16/02/2024.
//

import Foundation

enum APIError: Error {
    case failedToFetchData
}

class APICaller {
    static let shared = APICaller()
    
    func fetchTrendingMovies(completion: @escaping (Result<[Movie], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/3/trending/movie/day?language=en-US&api_key=\(Constants.API_KEY)") else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let results = try JSONDecoder().decode(Movies.self, from: data)
                completion(.success(results.results))
            } catch {
                completion(.failure(APIError.failedToFetchData))
            }
        }
        task.resume()
    }
    func fetchDiscoverMovies(completion: @escaping (Result<[Movie], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/3/discover/movie?include_adult=false&include_video=false&language=en-US&page=1&sort_by=popularity.desc&api_key=\(Constants.API_KEY)") else {
            return
        }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let results = try JSONDecoder().decode(Movies.self, from: data)
                completion(.success(results.results))
                
            }
            catch {
                completion(.failure(APIError.failedToFetchData))
                
            }
        }
        task.resume()
    }
    
    
    func fetchUpcomingMovies(completion: @escaping (Result<[Movie], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/3/movie/upcoming?language=en-US&page=1&api_key=\(Constants.API_KEY)") else {
            return
        }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let results = try JSONDecoder().decode(Movies.self, from: data)
                completion(.success(results.results))
            }
            catch {
                completion(.failure(APIError.failedToFetchData))
            }
        }
        task.resume()
    }
    func fetchPopularMovies(completion: @escaping (Result<[Movie], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/3/movie/popular?language=en-US&page=1&api_key=\(Constants.API_KEY)") else {
            return
        }
        let task  = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let results = try JSONDecoder().decode(Movies.self, from: data)
                completion(.success(results.results))
            }
            catch {
                completion(.failure(APIError.failedToFetchData))
            }
        }
        task.resume()
    }
    func fetchTopRatedMovies(completion: @escaping (Result<[Movie], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/3/movie/top_rated?language=en-US&page=1&api_key=\(Constants.API_KEY)") else {
            return
        }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let results = try JSONDecoder().decode(Movies.self, from: data)
                completion(.success(results.results))
            }
            catch {
                completion(.failure(APIError.failedToFetchData))
            }
        }
        task.resume()
    }
    
    func fetchMoviesInTheatres(completion: @escaping (Result<[Movie], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/3/movie/now_playing?language=en-US&page=1&api_key=\(Constants.API_KEY)") else {
            return
        }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let results = try JSONDecoder().decode(Movies.self, from: data)
                completion(.success(results.results))
            }
            catch {
                completion(.failure(APIError.failedToFetchData))
            }
        }
        task.resume()
    }
    func search(with query: String, completion: @escaping (Result<[Movie], Error>) -> Void) {
        
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else  {
            return
        }
        guard let url = URL(string: "\(Constants.baseURL)/3/search/movie?query=\(query)&api_key=\(Constants.API_KEY)") else {
            return
        }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let results = try JSONDecoder().decode(Movies.self, from: data)
                completion(.success(results.results))
            }
            catch {
                completion(.failure(APIError.failedToFetchData))
            }
        }
        task.resume()
    }
    func fetchMovie(with query: String, completion: @escaping (Result<YoutubeVideos, Error>) -> Void) {
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else  {
            return
        }
        guard let url = URL(string: "\(Constants.youtubeBaseURL)q=\(query)&key=\(Constants.YoutubeAPI_Key)") else {
            return
        }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let results = try JSONDecoder().decode(Youtube.self, from: data)
                completion(.success(results.items[0]))
            }
            catch {
                completion(.failure(error))
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    }

