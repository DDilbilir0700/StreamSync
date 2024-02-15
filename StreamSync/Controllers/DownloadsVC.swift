//
//  DownloadsVC.swift
//  StreamSync
//
//  Created by Deniz Dilbilir on 09/02/2024.
//

import UIKit

class DownloadsVC: UIViewController {
    
    
    private var movie: [MovieItem] = []
    
    private let downloadTableView: UITableView = {
        
        let table = UITableView()
        table.register(MoviesTableViewCell.self, forCellReuseIdentifier: MoviesTableViewCell.identifier)
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Downloads"
        view.addSubview(downloadTableView)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        downloadTableView.delegate = self
        downloadTableView.dataSource = self
        downloadTableView.backgroundColor = .black
        let myColor = UIColor(hex: "#a70000")
        navigationController?.navigationBar.tintColor = myColor
        fetchDownloadStorage()
        NotificationCenter.default.addObserver(forName: NSNotification.Name("Downloaded"), object: nil, queue: nil) { _ in
            self.fetchDownloadStorage()
        }
    }
    
    
    private func fetchDownloadStorage() {
        PersistenceManager.shared.fetchMoviesFromData { [weak self] result in
            switch result {
            case .success(let model):
                self?.movie = model
                DispatchQueue.main.async {
                    self?.downloadTableView.reloadData()
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        downloadTableView.frame = view.bounds
    }
    
}

extension DownloadsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movie.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MoviesTableViewCell.identifier, for: indexPath) as? MoviesTableViewCell else {
            return UITableViewCell()
        }
        
        let title = movie[indexPath.row]
        cell.configure(with: MovieVM(titleName: (title.original_title ?? title.original_title) ?? "Unknown title name", imageURL: title.poster_path ?? ""))
        cell.backgroundColor = .black
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            
            PersistenceManager.shared.removeMovieWith(model: movie[indexPath.row]) { [weak self] result in
             
           
                switch result {
                case .success():
                    print("Item deleted.")
                case .failure(let error):
                    print(error.localizedDescription)
                }
                self?.movie.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        default:
            break;
        }
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
