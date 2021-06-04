//
//  HomeViewModel.swift
//  MyMovies
//
//  Created by Ernesto Sánchez Kuri on 02/06/21.
//

import Foundation

class HomeViewModel: NSObject {
    let service = ServiceAPI()
    var movies: [Movie] = []
    var hasError = false
    var currentQuery: String?
    
    var imageCache: NSCache<AnyObject, AnyObject> = {
        let cache = NSCache<AnyObject, AnyObject>()
        cache.countLimit = 100
        return cache
    }()
    
    var sections: [Section] = []
    
    /// Descarga el feed de películas populares.
    /// - Parameter completed: un bloque de código a ejecutarse una vez terminada la tarea asíncrona
    func downloadMovies(completed: @escaping (Bool) -> ()) {
        service.getMovies(endPoint: PopularEndPoint()) { downloadedMovies in
            self.sections.append(Section(title: "Popular", movies: downloadedMovies))
            completed(true)
        } failure: { error in
            self.hasError = true
            print(error.localizedDescription)
            completed(true)
        }
    }
    
    /// Descarga el feed de películas "TopRated".
    /// - Parameter completed: un bloque de código a ejecutarse una vez terminada la tarea asíncrona
    func downloadTopRatedMovies(completed: @escaping (Bool) -> ()) {
        service.getMovies(endPoint: TopRatedEndPoint()) { downloadedMovies in
            self.sections.append(Section(title: "Top Rated", movies: downloadedMovies))
            completed(true)
        } failure: { error in
            self.hasError = true
            print(error.localizedDescription)
            completed(true)
        }
    }
    
    /// Descarga el feed de películas "Upcoming".
    /// - Parameter completed: un bloque de código a ejecutarse una vez terminada la tarea asíncrona
    func downloadUpcomingMovies(completed: @escaping (Bool) -> ()) {
        service.getMovies(endPoint: UpcomingEndPoint()) { downloadedMovies in
            self.sections.append(Section(title: "Upcoming", movies: downloadedMovies))
            completed(true)
        } failure: { error in
            self.hasError = true
            print(error.localizedDescription)
            completed(true)
        }
    }
    
    /// Descarga la imagen para una película seleccionada
    /// - Parameters:
    ///   - movie: la película seleccionada que contiene un imagepath
    ///   - completed: un bloque que regresa un image data
    func downloadImageFrom(movie: Movie, completed: @escaping (Data?) -> ()) {
        if let image = imageCache.object(forKey: movie.posterPath as AnyObject) as? Data {
            completed(image)
            return
        }
        
        if let posterPath = movie.posterPath {
            service.downloadImage(posterPath) { data in
                self.imageCache.setObject(data as AnyObject, forKey: movie.posterPath as AnyObject)
                completed(data)
            } failure: { error in
                completed(nil)
            }
        }
    }
    
    /// Filtra secciones en base al query entregado desde la barra de búsqueda
    /// - Parameters:
    ///   - query: el texto escrito en la barra de búsqueda
    ///   - section: la sección en la que se va a buscar. Si el string es vació entonces es búsqueda global
    func filterSections(forSearchQuery query: String?, inSection section: String = "") -> [Section] {
        let sections = sections.filter {
            guard !section.isEmpty && section != "All" else { return true }
            
            return $0.title.lowercased() == section.lowercased()
        }
        currentQuery = query
        guard let query = query, !query.isEmpty else {
            return sections
        }
        
        let filteredSections = sections.filter { section in
            var found = section.title.lowercased().contains(query.lowercased())
            
            for movie in section.movies {
                if movie.title.lowercased().contains(query.lowercased()) {
                    found = true
                    break
                }
            }
            
            return found
        }
        
        return filteredSections
    }
}
