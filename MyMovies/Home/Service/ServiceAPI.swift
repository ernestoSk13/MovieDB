//
//  ServiceAPI.swift
//  MyMovies
//
//  Created by Ernesto Sánchez Kuri on 02/06/21.
//

import Foundation

let API_KEY = "28781bfcc2653c0245241d12de53fc13"
let HOST_URL = "https://api.themoviedb.org/3/"
let IMAGE_URL = "https://image.tmdb.org/t/p/w300"

protocol EndPoint {
    var urlString: String { get }
    var method: String { get }
}

enum NetworkError: Error {
    case badResponse
    case badRequest
    case other(error: Error)
}

struct PopularEndPoint: EndPoint {
    var urlString: String = "movie/popular?api_key=\(API_KEY)&language=en-US&page=1"
    var method: String = "GET"
}

struct TopRatedEndPoint: EndPoint {
    var urlString: String = "movie/top_rated?api_key=\(API_KEY)&language=en-US&page=1"
    var method: String = "GET"
}

struct UpcomingEndPoint: EndPoint {
    var urlString: String = "movie/upcoming?api_key=\(API_KEY)&language=en-US&page=1"
    var method: String = "GET"
}

class ServiceAPI {
    func getMovies(endPoint: EndPoint, completion: @escaping ([Movie]) -> (), failure: @escaping (NetworkError) -> ()) {
        guard let url = URL(string: "\(HOST_URL)\(endPoint.urlString)") else {
            failure(NetworkError.badRequest)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endPoint.method
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                failure(NetworkError.other(error: error))
                return
            }
            
            guard let data = data else {
                failure(NetworkError.badResponse)
                return
            }
            
            do {
                let result: SearchResult = try JSONDecoder().decode(SearchResult.self, from: data)
                completion(result.results)
                
            } catch let decodeError {
                failure(NetworkError.other(error: decodeError))
            }
            
        }.resume()
    }
    
    func downloadImage(_ path: String, completion: @escaping (Data) -> (), failure: @escaping (NetworkError) -> ()) {
        let imagePath = "\(IMAGE_URL)\(path)"
        guard let url = URL(string: imagePath) else {
            failure(NetworkError.badRequest)
            return
        }
        
        let request = URLRequest(url: url)
        
        URLSession.shared.downloadTask(with: request) { storePath, response, error in
            if let error = error {
                failure(NetworkError.other(error: error))
            }
            
            guard let imageUrl = storePath, let data = try? Data(contentsOf: imageUrl) else {
                failure(NetworkError.badResponse)
                return
            }
            
            completion(data)
        }.resume()
    }
}
