//
//  MoviesTableViewCell.swift
//  StreamSync
//
//  Created by Deniz Dilbilir on 19/02/2024.
//

import UIKit

class MoviesTableViewCell: UITableViewCell {

  static let identifier = "MoviesTableViewCell"
    
//    private let playButton: UIButton = {
//        let button = UIButton()
//        let sdImage = UIImage(systemName: "play.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
//        button.setImage(sdImage, for: .normal)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        let myColor = UIColor(hex: "#a70000")
//        button.tintColor = myColor
//        return button
//    }()
//    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        return label
    }()
    
    private let poster: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(poster)
        contentView.addSubview(titleLabel)
//        contentView.addSubview(playButton)
        setUpConstraints()
       
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            poster.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            poster.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            poster.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15),
            poster.widthAnchor.constraint(equalToConstant: 100),
            
            titleLabel.leadingAnchor.constraint(equalTo: poster.trailingAnchor, constant: 20),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
//            playButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
//            playButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
            
        
        ])
    }
    
    func configure(with model: MovieVM) {
      
        guard let url = URL(string: "\(Constants.imageBaseURL)\(model.imageURL)") else {
            return
        }
        
        poster.sd_setImage(with: url, completed: nil)
        titleLabel.text = model.titleName 
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
