//
//  MovieDetailViewController.swift
//  MyMovies
//
//  Created by Ernesto Sánchez Kuri on 04/06/21.
//

import UIKit
import SwiftUI

class MovieDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}

struct MovieDetailView: View {
    var viewModel: MovieDetailViewModel
    var dismissAction: () -> ()
        
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    if let imageData = viewModel.movie.imageData {
                        HStack {
                            Image(uiImage: UIImage(data: imageData) ?? UIImage(systemName: "film") ?? UIImage())
                                .resizable()
                                .frame(width: 200, height: 300)
                                .padding()
                                .cornerRadius(12)
                            VStack(alignment: .leading) {
                                Text("Language: \(viewModel.movie.originalLanguage)")
                                Text("Release: \(viewModel.movie.releaseDate)")
                                Text("Popularity: \(viewModel.movie.popularity)")
                                Spacer()
                            }
                        }
                        
                    }
                    Text(viewModel.movie.overview).padding()
                }
            }
            .navigationBarTitle(Text(viewModel.movie.title), displayMode: .inline)
            .navigationBarItems(leading:
                Button {
                    dismissAction()
                } label: {
                    Text("Cerrar")
                }
            )
        }
    }
}
