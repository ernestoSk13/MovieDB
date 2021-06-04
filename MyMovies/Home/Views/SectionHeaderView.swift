//
//  SectionHeaderView.swift
//  MyMovies
//
//  Created by Ernesto Sánchez Kuri on 02/06/21.
//

import UIKit

class SectionHeaderView: UICollectionReusableView {
    static let identifier: String = "SectionHeaderView"
    
    lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(headerLabel)
        NSLayoutConstraint.activate([
            headerLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            headerLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
