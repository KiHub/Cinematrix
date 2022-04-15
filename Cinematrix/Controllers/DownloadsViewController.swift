//
//  DownloadsViewController.swift
//  Cinematrix
//
//  Created by  Mr.Ki on 11.04.2022.
//

import UIKit

class DownloadsViewController: UIViewController {
    
    private var movies: [MovieItem] = [MovieItem]()
    
    private let downloadTable: UITableView = {
        let table = UITableView()
        table.register(MovieTableViewCell.self, forCellReuseIdentifier: MovieTableViewCell.identifier)
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Downloads"
        view.addSubview(downloadTable)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        downloadTable.delegate = self
        downloadTable.dataSource = self
        fetchLocalDataForDownload()
        NotificationCenter.default.addObserver(forName: NSNotification.Name("loaded"), object: nil, queue: nil) { _ in
            self.fetchLocalDataForDownload()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        downloadTable.frame = view.bounds
    }
    
    private func fetchLocalDataForDownload() {
        DataPersistentManager.shared.fetchMoviesFromDataBase { [weak self] result in
            switch result {
            case .success(let movies):
                self?.movies = movies
                self?.downloadTable.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    

}

extension DownloadsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.identifier, for: indexPath)
        as? MovieTableViewCell else { return UITableViewCell() }
        
        let title = movies[indexPath.row]
        cell.configure(with: MovieViewModel(titleName: title.title ?? title.original_title ?? "No data", posterUrl: title.poster_path ?? "/abPQVYyNfVuGoFUfGVhlNecu0QG.jpg"))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
           
            DataPersistentManager.shared.deleteMoviesFromDataBase(model: movies[indexPath.row]) { [weak self] result in
                switch result {
                case .success():
                    print("Deleted from database")
                case .failure(let error):
                    print(error.localizedDescription)
                }
                
                self?.movies.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
             
            }
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let title = movies[indexPath.row]
        guard let titleName = title.title else {return}
        
        APICaller.shared.getMovie(with: titleName) { [weak self] result in
            switch result {
            case .success(let video):
                DispatchQueue.main.async {
                let vc = MoviePreviewViewController()
                vc.configure(with: MoviePreviewViewModel(title: titleName, youtubeView: video, titleOverview: title.overview ?? "No data"))
                self?.navigationController?.pushViewController(vc, animated: true)
            }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
}
