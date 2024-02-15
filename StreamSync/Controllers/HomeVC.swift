//
//  HomeVC.swift
//  StreamSync
//
//  Created by Deniz Dilbilir on 08/02/2024.
//

import UIKit

enum Sections: Int {
    
    case Trending = 0
    case Popular = 1
    case ComingSoon = 2
    case TopRated = 3
    case InTheaters = 4
    
}


class HomeVC: UIViewController {
    
    private var randomMovie: Movie?
    private var headerView: HeaderView?
    
    let sectionsForTitles: [String] = ["Trending", "Popular", "Coming Soon", "Top Rated", "In Theaters"]
    
    private let homeTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(CollectionViewTVC.self, forCellReuseIdentifier: CollectionViewTVC.identifier)
        return tableView
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        view.backgroundColor = .black
        homeTableView.backgroundColor = .black
        view.addSubview(homeTableView)
        homeTableView.delegate = self
        homeTableView.dataSource = self
        configureNavBar()
        headerView = HeaderView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 400))
        homeTableView.tableHeaderView = headerView
        configureHeaderView() 
    }
    
    private func configureHeaderView() {
        APICaller.shared.fetchTrendingMovies { [weak self] result in
            switch result {
                
            case .success(let model):
                let selectedMovie = model.randomElement()
                self?.randomMovie = selectedMovie
                self?.headerView?.configure(with: MovieVM(titleName: selectedMovie?.original_title ?? "", imageURL: selectedMovie?.poster_path ?? ""))
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func configureNavBar() {
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "person.crop.rectangle.fill"), style: .done, target: self, action: nil)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "play.rectangle.fill"), style: .done, target: self, action: nil)
        let myColor = UIColor(hex: "#a70000")
        navigationController?.navigationBar.tintColor = myColor
        
    }
    
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeTableView.frame = view.bounds
    }
    
}



// MARK: - Table View

extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionsForTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
   
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTVC.identifier, for: indexPath) as? CollectionViewTVC else {
            return UITableViewCell()
        }
        cell.delegate = self
        switch indexPath.section {
        
            
        case Sections.Trending.rawValue:
            
            APICaller.shared.fetchTrendingMovies { result in
                switch result {
                case .success(let model):
                    cell.configure(with: model)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
        case Sections.Popular.rawValue:
            
            APICaller.shared.fetchPopularMovies { result in
            switch result {
            case .success(let model):
                cell.configure(with: model)
            case .failure(let error):
                print(error.localizedDescription)
            }
            
        }
        case Sections.ComingSoon.rawValue:
            
            APICaller.shared.fetchUpcomingMovies { result in
                switch result {
                case .success(let model):
                    cell.configure(with: model)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
        case Sections.TopRated.rawValue:
            APICaller.shared.fetchTopRatedMovies { result in
                switch result {
                case .success(let model):
                    cell.configure(with: model)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
        case Sections.InTheaters.rawValue:
            
            APICaller.shared.fetchTrendingMovies { result in
                switch result {
                case .success(let model):
                    cell.configure(with: model)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        
            
        default:
            return UITableViewCell()
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
        
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else {
            return
        }
        header.textLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        header.textLabel?.frame = CGRect(x: header.bounds.origin.x + 20, y: header.bounds.origin.y, width: 100, height: header.bounds.height)
       
        header.textLabel?.textColor = .white
        
        header.textLabel?.text = header.textLabel?.text?.firstLetterCapitalized()

    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaultOffset = view.safeAreaInsets.top
        let offset = scrollView.contentOffset.y + defaultOffset
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionsForTitles[section]
    }
}

extension HomeVC: CollectionViewTableViewCellDelegate {
    func collectionViewTableViewCellTapped(_ cell: CollectionViewTVC, viewModel: PreviewVM) {
        DispatchQueue.main.async { [weak self] in 
            let vc = PreviewVC()
            vc.configure(with: viewModel)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
       
    }
}
