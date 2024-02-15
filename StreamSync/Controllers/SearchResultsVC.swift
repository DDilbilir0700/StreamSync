//
//  SearchResultsVC.swift
//  StreamSync
//
//  Created by Deniz Dilbilir on 21/02/2024.
//

import UIKit

protocol SearchResultsVCDelegate: AnyObject {
    func searchResultsVCItemTapped(_ viewModel: PreviewVM)
}

class SearchResultsVC: UIViewController {
    
    
     var movie: [Movie] = [Movie]()
     weak var delegate: SearchResultsVCDelegate?
     let searchResultsCollectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 3 - 10, height: 180)
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(MoviesCollectionViewCell.self, forCellWithReuseIdentifier: MoviesCollectionViewCell.identifier)
        collectionView.backgroundColor = .black
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        view.addSubview(searchResultsCollectionView)
        searchResultsCollectionView.delegate = self
        searchResultsCollectionView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchResultsCollectionView.frame = view.bounds
    }
    
}

extension SearchResultsVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movie.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MoviesCollectionViewCell.identifier, for: indexPath) as? MoviesCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.backgroundColor = .black
        let title = movie[indexPath.row]
        cell.configure(with: title.poster_path ?? "")
       
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let title = movie[indexPath.row]
        APICaller.shared.fetchMovie(with: title.original_title ?? "") { [weak self] result in
            switch result {
                
            case .success(let model):
                self?.delegate?.searchResultsVCItemTapped(PreviewVM(title: title.original_title ?? "", youtubeView: model, overview: title.overview ?? ""))
              
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
