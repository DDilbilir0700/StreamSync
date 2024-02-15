//
//  ComingSoonVC.swift
//  StreamSync
//
//  Created by Deniz Dilbilir on 08/02/2024.
//

import UIKit

class ComingSoonVC: UIViewController {
    
    private var movie: [Movie] = [Movie]()
    
    lazy var comingSoonCollectionView: UICollectionView = {
        let layout = CustomFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(MoviesCollectionViewCell.self, forCellWithReuseIdentifier: MoviesCollectionViewCell.identifier)
        collectionView.backgroundColor = .black
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        title = "Coming Soon"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        view.addSubview(comingSoonCollectionView)
        let myColor = UIColor(hex: "#a70000")
        navigationController?.navigationBar.tintColor = myColor
        fetchComingSoon()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        comingSoonCollectionView.frame = view.bounds
    }
    
    private func fetchComingSoon() {
        APICaller.shared.fetchUpcomingMovies { [weak self] result in
            switch result {
            case .success(let movie):
                self?.movie = movie
                DispatchQueue.main.async {
                    self?.comingSoonCollectionView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension ComingSoonVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movie.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MoviesCollectionViewCell.identifier, for: indexPath) as? MoviesCollectionViewCell else {
            return UICollectionViewCell()
        }
        let movieData = movie[indexPath.row]
        cell.configure(with: movieData.poster_path ?? "")
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        collectionView.deselectItem(at: indexPath, animated: true)
        
        let title = movie[indexPath.row]
        guard let name = title.original_title ?? title.original_title else {
            return
        }
        APICaller.shared.fetchMovie(with: name) { [weak self] result in
            switch result {
                
            case .success(let model):
                DispatchQueue.main.async {
                    let vc = PreviewVC()
                    vc.configure(with: PreviewVM(title: name, youtubeView: model, overview: title.overview ?? ""))
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
              
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    }


class CustomFlowLayout: UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()
        
        guard let collectionView = collectionView else { return }
        
        let padding: CGFloat = 20
        let availableWidth = collectionView.bounds.width - (padding * 3)
        let itemWidth = availableWidth / 2
        
        self.itemSize = CGSize(width: itemWidth, height: itemWidth * 1.5) 
        self.minimumInteritemSpacing = padding
        self.minimumLineSpacing = padding
        self.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
    }
}
