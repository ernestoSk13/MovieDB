//
//  ViewController.swift
//  MyMovies
//
//  Created by Ernesto Sánchez Kuri on 02/06/21.
//

import UIKit
import SwiftUI

enum HomeSection {
    case popular
    case topRated
    case upcoming
}

class HomeViewController: UIViewController {
    lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: configureLayout())
        collection.backgroundColor = UIColor.systemGroupedBackground
        collection.delegate = self
        return collection
    }()
    
    private let viewModel = HomeViewModel()
    private var searchController = UISearchController(searchResultsController: nil)
    var sections: [Section] = []
    var currentQuery: String?
    var segmentedSections = ["All", "Popular", "Upcoming", "Top Rated"]
    
    func configureLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (section: Int, environment: NSCollectionLayoutEnvironment)
            -> NSCollectionLayoutSection? in
            return self.makeHorizontalLayout()
        }
        
        return layout
    }
    
    func makeHorizontalLayout() -> NSCollectionLayoutSection? {
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                                             heightDimension: .fractionalHeight(1.0)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 0.0,
                                                     leading: 10.0,
                                                     bottom: 0.0,
                                                     trailing: 10.0)
        let group = NSCollectionLayoutGroup
            .vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalHeight(0.25),
                                                        heightDimension: .fractionalHeight(0.25)),
                                                        subitem: item,
                                                        count: 1)
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 10.0,
                                                        leading: 0.0,
                                                        bottom: 10.0,
                                                        trailing: 0.0)
        
        let headerFooterSize = NSCollectionLayoutSize(
          widthDimension: .fractionalWidth(1.0),
          heightDimension: .estimated(30)
        )
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
          layoutSize: headerFooterSize,
          elementKind: UICollectionView.elementKindSectionHeader,
          alignment: .top
        )
        section.boundarySupplementaryItems = [sectionHeader]
        
        section.orthogonalScrollingBehavior = .continuous
        return section
    }
    
    func configureCollectionView() {
        self.view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: self.view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        collectionView.register(MovieCollectionViewCell.self,
                                forCellWithReuseIdentifier: MovieCollectionViewCell.cellIdentifier)
        collectionView.register(SectionHeaderView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: SectionHeaderView.identifier)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        collectionView.dataSource = self
        viewModel.downloadMovies { finished in
            if finished {
                DispatchQueue.main.async {
                    self.sections = self.viewModel.sections
                    self.collectionView.reloadData()
                }
            }
        }
        
        viewModel.downloadTopRatedMovies { finished in
            if finished {
                DispatchQueue.main.async {
                    self.sections = self.viewModel.sections
                    self.collectionView.reloadData()
                }
            }
        }
        
        viewModel.downloadUpcomingMovies { finished in
            if finished {
                DispatchQueue.main.async {
                    self.sections = self.viewModel.sections
                    self.collectionView.reloadData()
                }
            }
        }
        configureSearchController()
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let filterQuery = viewModel.currentQuery ?? ""
        let movie = sections[indexPath.section].movies.filter {
            guard !filterQuery.isEmpty else { return true }
            return $0.title.lowercased().contains(filterQuery.lowercased())
        }[indexPath.row]
        
        let view = MovieDetailView(viewModel: MovieDetailViewModel(movie: movie), dismissAction: {
            self.dismiss(animated: true, completion: nil)
        })
        let controller = UIHostingController(rootView: view)
        self.navigationController?.present(controller, animated: true)
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView(frame: .zero)
        }
        
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                               withReuseIdentifier: SectionHeaderView.identifier,
                                                               for: indexPath) as? SectionHeaderView
        
        //let section = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]
        view?.headerLabel.text = sections[indexPath.section].title
        return view ?? UICollectionReusableView(frame: .zero)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let query = viewModel.currentQuery, !query.isEmpty {
            return viewModel.sections[section].movies.filter {
                $0.title.lowercased().contains(query.lowercased())
            }.count
        }
        
        return viewModel.sections[section].movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.cellIdentifier,
                                                            for: indexPath) as? MovieCollectionViewCell else {
            fatalError("Couldnt find Album cell")
        }
        
        let filterQuery = viewModel.currentQuery ?? ""
        let movie = sections[indexPath.section].movies.filter {
            guard !filterQuery.isEmpty else { return true }
            return $0.title.lowercased().contains(filterQuery.lowercased())
        }[indexPath.row]
        
        
        cell.configure(movie: movie)
        
        if let imageData = movie.imageData {
            cell.image.contentMode = .scaleToFill
            cell.image.image = UIImage(data: imageData)
        } else {
            self.viewModel.downloadImageFrom(movie: movie) { [weak self] data in
                if let imageData = self?.viewModel.imageCache.object(forKey: movie.posterPath as AnyObject) as? Data {
                    DispatchQueue.main.async {
                        movie.imageData = imageData
                        cell.image.contentMode = .scaleToFill
                        cell.image.image = UIImage(data: imageData)
                    }
                }
            }
        }
        
        
        return cell
    }
}

// MARK: - SearchBar Controller

extension HomeViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        sections = viewModel.filterSections(forSearchQuery: searchController.searchBar.text,
                                  inSection: segmentedSections[searchController.searchBar.selectedScopeButtonIndex])
        collectionView.reloadData()
    }
    
    func configureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Buscar Película"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        searchController.searchBar.scopeButtonTitles = ["All", "Popular", "Upcoming", "Top Rated"]
        searchController.searchBar.delegate = self
        
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        switch selectedScope {
        case 0://All
            sections = viewModel.filterSections(forSearchQuery: viewModel.currentQuery, inSection: "")
        case 1: //Popular
            sections = viewModel.filterSections(forSearchQuery: viewModel.currentQuery, inSection: "Popular")
        case 2://Upcoming
            sections = viewModel.filterSections(forSearchQuery: viewModel.currentQuery, inSection: "Upcoming")
        case 3://Top Rated
            sections = viewModel.filterSections(forSearchQuery: viewModel.currentQuery, inSection: "Top Rated")
        default:
            break
        }
        collectionView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.selectedScopeButtonIndex = 0
    }
}
