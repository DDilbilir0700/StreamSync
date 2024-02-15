//
//  CollectionViewTVC.swift
//  StreamSync
//
//  Created by Deniz Dilbilir on 12/02/2024.
//

import UIKit


protocol CollectionViewTableViewCellDelegate: AnyObject {
    func collectionViewTableViewCellTapped(_ cell: CollectionViewTVC, viewModel: PreviewVM)
}

class CollectionViewTVC: UITableViewCell {

static let identifier = "CollectionViewTVC"
    
    weak var delegate: CollectionViewTableViewCellDelegate?

    private var movie: [Movie] = [Movie]()

    
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 140, height: 200)
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(MoviesCollectionViewCell.self, forCellWithReuseIdentifier: MoviesCollectionViewCell.identifier)
        return collectionView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .black
        contentView.addSubview(collectionView)
       
        collectionView.delegate = self
        collectionView.dataSource = self
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = contentView.bounds
    }
    
    func configure(with movie: [Movie]) {
        self.movie = movie
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    private func download(indexPath: IndexPath) {
        PersistenceManager.shared.download(model: movie[indexPath.row]) { result in
            switch result {
                
            case .success():
                NotificationCenter.default.post(name: NSNotification.Name ("Downloaded"), object: nil)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension CollectionViewTVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        collectionView.backgroundColor = .black
        return movie.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MoviesCollectionViewCell.identifier, for: indexPath) as? MoviesCollectionViewCell else {
            return UICollectionViewCell()
        }
        guard let model = movie[indexPath.row].poster_path else {
            return UICollectionViewCell()
        }
        cell.configure(with: model)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let title = movie[indexPath.row]
        guard let name = title.original_title ?? title.media_type else {
            return
        }
        APICaller.shared.fetchMovie(with: name + "trailer") { [weak self] result in
            switch result {
            case .success(let model):
                let title = self?.movie[indexPath.row]
                guard let titleOverview = title?.overview else {
                    return
                }
                
                guard let sself = self else {
                    return
                }
                self?.delegate?.collectionViewTableViewCellTapped(sself, viewModel: PreviewVM(title: name, youtubeView: model, overview: titleOverview))
            case .failure(let error):
                print(error.localizedDescription)
            }
            
        }
    }

    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        let configuration = UIContextMenuConfiguration(
            identifier: nil,
            previewProvider: nil) {[weak self] _ in
                let downloadAction = UIAction(title: "Download", subtitle: nil, image: nil, identifier: nil, discoverabilityTitle: nil, state: .off) { _ in
                    self?.download(indexPath: indexPath)
                }
                return UIMenu(title: "", image: nil, identifier: nil, options: .displayInline, children: [downloadAction])
            }
        
        return configuration
    }
    
}
