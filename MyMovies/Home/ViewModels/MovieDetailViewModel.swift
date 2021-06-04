//
//  MovieDetailViewModel.swift
//  MyMovies
//
//  Created by Ernesto Sánchez Kuri on 04/06/21.
//

import UIKit

class MovieDetailViewModel: NSObject {
    var movie: Movie
    
    init(movie: Movie) {
        self.movie = movie
    }
}
