//
//  HeaderView.swift
//  StreamSync
//
//  Created by Deniz Dilbilir on 13/02/2024.
//

import UIKit

class HeaderView: UIView {
    
    private let downloadButton: UIButton = {
        let myColor = UIColor(hex: "#a70000")
        let button = UIButton()
             
        let image = UIImage(systemName: "arrowshape.down.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 40, weight: .thin))?.withTintColor(myColor, renderingMode: .alwaysOriginal)
              button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
              return button
          }()
    
    private let playButton: UIButton = {
        let myColor = UIColor(hex: "#a70000")
        let button = UIButton()
             
        let image = UIImage(systemName: "play.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 40, weight: .thin))?.withTintColor(myColor, renderingMode: .alwaysOriginal)
              button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
              return button
          }()
    
    private let headerImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "image")
        return imageView
    }()
    
    private func addGradient() {
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.clear.cgColor, UIColor.black.withAlphaComponent(1).cgColor]
        gradient.frame = bounds
        layer.addSublayer(gradient)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(headerImageView)
        addGradient()
        addSubview(playButton)
        addSubview(downloadButton)
        configureConstraints()
    }
    
    private func configureConstraints() {
        NSLayoutConstraint.activate([
            playButton.centerYAnchor.constraint(equalTo: headerImageView.bottomAnchor, constant: -30),
            playButton.widthAnchor.constraint(equalToConstant: 120),
            playButton.heightAnchor.constraint(equalToConstant: 120),
            playButton.trailingAnchor.constraint(equalTo: centerXAnchor, constant: -10),
            
            downloadButton.centerYAnchor.constraint(equalTo: headerImageView.bottomAnchor, constant: -30),
            downloadButton.widthAnchor.constraint(equalToConstant: 120),
            downloadButton.heightAnchor.constraint(equalToConstant: 120),
            downloadButton.leadingAnchor.constraint(equalTo: centerXAnchor, constant: 10),
        ])
    }
    
    func configure(with model: MovieVM) {
        guard let url = URL(string: "\(Constants.imageBaseURL)\(model.imageURL)") else {
            return
        }
        headerImageView.sd_setImage(with: url, completed: nil)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        headerImageView.frame = bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
