//
//  SearchVC.swift
//  StreamSync
//
//  Created by Deniz Dilbilir on 08/02/2024.
//

import UIKit

class SearchVC: UIViewController {
    
    private var movie: [Movie] = [Movie]()
    
    private let searchTableView: UITableView = {
        
        let tableView = UITableView()
        tableView.register(MoviesTableViewCell.self, forCellReuseIdentifier: MoviesTableViewCell.identifier)
        return tableView
    }()
    
    private let searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: SearchResultsVC())
        controller.searchBar.searchBarStyle = .minimal
        controller.searchBar.tintColor = .darkGray
        

        
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.darkGray
        ]
        let attributedPlaceholder = NSAttributedString(string: "Search for a movie", attributes: attributes)
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).attributedPlaceholder = attributedPlaceholder
        
        return controller
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        view.addSubview(searchTableView)
        searchTableView.delegate = self
        searchTableView.dataSource = self
        navigationItem.searchController = searchController
        
        navigationItem.hidesSearchBarWhenScrolling = false
       
        let myColor = UIColor(hex: "#a70000")
        navigationController?.navigationBar.tintColor = myColor
        if let textField = searchController.searchBar.value(forKey: "searchField") as? UITextField {
            textField.textColor = .white
        }

        
        fetchDiscoverMovies()
        searchController.searchResultsUpdater = self
        
    }
    
    func fetchDiscoverMovies() {
        APICaller.shared.fetchDiscoverMovies { [weak self] result in
            switch result {
            case .success(let model):
                self?.movie = model
                DispatchQueue.main.async {
                    self?.searchTableView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchTableView.frame = view.bounds
        searchTableView.backgroundColor = .black
    }
}

extension SearchVC: UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, SearchResultsVCDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        
        guard let query = searchBar.text,
        !query.trimmingCharacters(in: .whitespaces).isEmpty,
        query.trimmingCharacters(in: .whitespaces).count >= 3,
              let searchResults = searchController.searchResultsController as? SearchResultsVC else {
            return
        }
        searchResults.delegate = self
        APICaller.shared.search(with: query) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    searchResults.movie = model
                    searchResults.searchResultsCollectionView.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func searchResultsVCItemTapped(_ viewModel: PreviewVM) {
        DispatchQueue.main.async { [weak self] in
            let vc = PreviewVC()
            vc.configure(with: viewModel)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
      
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movie.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MoviesTableViewCell.identifier, for: indexPath) as? MoviesTableViewCell else {
            return UITableViewCell()
        }
        let title = movie[indexPath.row]
        let model = MovieVM(titleName: title.original_title ?? "NA", imageURL: title.poster_path ?? "")
        cell.configure(with: model)
        cell.textLabel?.textColor = .white
        cell.backgroundColor = .black
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
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


