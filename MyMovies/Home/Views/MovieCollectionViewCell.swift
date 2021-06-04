//
//  MovieCollectionViewCell.swift
//  MyMovies
//
//  Created by Ernesto Sánchez Kuri on 02/06/21.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {
    static var cellIdentifier: String = "MovieCollectionViewCell"
    
    lazy var nameLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = UIColor.white
        return label
    }()
    
    lazy var dateLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.white
        return label
    }()
    
    lazy var image: UIImageView = {
        let image = UIImageView(frame: .zero)
        image.image = UIImage(systemName: "film")
        image.tintColor = UIColor.lightGray
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    lazy var overlay: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .black
        view.alpha = 0.7
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.systemBackground
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 12
        self.addSubview(image)
        self.addSubview(overlay)
        self.addSubview(nameLabel)
        self.addSubview(dateLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        image.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            nameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            dateLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            dateLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            dateLabel.topAnchor.constraint(equalTo: self.nameLabel.bottomAnchor, constant: 10),
            dateLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            nameLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -30),
            image.topAnchor.constraint(equalTo: self.topAnchor),
            image.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            image.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            image.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            overlay.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            overlay.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            overlay.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            overlay.heightAnchor.constraint(equalToConstant: 60)
        ])
        
    }
    
    func configure(movie: Movie) {
        nameLabel.text = movie.originalTitle
        dateLabel.text = movie.releaseDate
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
