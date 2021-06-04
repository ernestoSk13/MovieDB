//
//  Section.swift
//  MyMovies
//
//  Created by Ernesto Sánchez Kuri on 02/06/21.
//

import UIKit

class Section: Hashable {
    var id = UUID()
    var title: String
    var movies: [Movie]
    
    init(title: String, movies: [Movie]) {
        self.title = title
        self.movies = movies
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Section, rhs: Section) -> Bool {
        lhs.id == rhs.id
    }
}
