//
//  TitleCollectionViewCell.swift
//  StreamSync
//
//  Created by Deniz Dilbilir on 19/02/2024.
//

import UIKit
import SDWebImage

class MoviesCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "MoviesCollectionViewCell"
    
    private let poster: UIImageView = {
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(poster)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        poster.frame = contentView.bounds
    }
     func configure(with model: String) {
        guard let url = URL(string: "\(Constants.imageBaseURL)\(model)") else {
            return
        }
        poster.sd_setImage(with: url, completed: nil)
    }
}
