//
//  SearchResultsViewController.swift
//  Cinematrix
//
//  Created by  Mr.Ki on 13.04.2022.
//

import UIKit

protocol SearchResultsViewControllerDelegate: AnyObject {
    func searchResultsViewControllerDidTapItem(_ viewModel: MoviePreviewViewModel)

}

class SearchResultsViewController: UIViewController {
    
    public var movies: [Movie] = [Movie]()
    public weak var delegate: SearchResultsViewControllerDelegate?
    
    public let searchResultsCollectionView: UICollectionView = {
       
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 3 - 15, height: 200)
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: MovieCollectionViewCell.identifier)
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(searchResultsCollectionView)
        
        searchResultsCollectionView.delegate = self
        searchResultsCollectionView.dataSource = self

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchResultsCollectionView.frame = view.bounds
        
    }

}

extension SearchResultsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.identifier, for: indexPath)
                as? MovieCollectionViewCell else { return UICollectionViewCell() }
//        guard let cell = collectionView.cellForItem(at: indexPath)  as? MovieCollectionViewCell else { return UICollectionViewCell() }
       // cell.backgroundColor = .blue
        let movie = movies[indexPath.row]
        cell.configure(with: movie.poster_path ?? "")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let title = movies[indexPath.row ]
        let titleName = title.title ?? ""
        APICaller.shared.getMovie(with: titleName) { [weak self] result in
            switch result {
            case .success(let video):
//                DispatchQueue.main.async {
//                    let vc = MoviePreviewViewController()
//                    vc.titleForPreview = title
//                }
                self?.delegate?.searchResultsViewControllerDidTapItem(MoviePreviewViewModel(title: title.title ?? "", youtubeView: video , titleOverview: title.overview ?? ""))
           
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
      
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let config = UIContextMenuConfiguration(
            identifier: nil, previewProvider: nil) { [weak self] _ in
                let downloadAction = UIAction(title: "Add to list", image: nil, identifier: nil, discoverabilityTitle: nil, state: .off) { _ in
                    self?.downloadTitleAt(indexPath: indexPath)
                }
//                let downloadAction = UIAction(title: "Download", subtitle: nil, image: nil, identifier: nil, discoverabilityTitle: nil, state: .off) { _ in
//                    print("Download")
//                }
                return UIMenu(title: "", image: nil, identifier: nil, options: .displayInline, children: [downloadAction])
            }
        return config
    }
    
    
}

extension SearchResultsViewController {
    private func downloadTitleAt(indexPath: IndexPath) {
    //    let title = self.movies[indexPath.row]
        DataPersistentManager.shared.downloadMovieToDataBase(model: movies[indexPath.row]) { result in
            switch result {
            case .success():
               
//                DispatchQueue.main.async {
//                let vc = MoviePreviewViewController()
//                vc.titleForPreview = title
//                }
                
                print("Downloaded to DB")
                NotificationCenter.default.post(name: NSNotification.Name("loaded"), object: nil)
                
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        print("Downloading \(movies[indexPath.row].title)")
    }
}
