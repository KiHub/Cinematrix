//
//  HomeViewController.swift
//  Cinematrix
//
//  Created by  Mr.Ki on 11.04.2022.
//

import UIKit

enum Sections: Int {
    case TrendyMovies = 0
    case Popular = 1
    case Upcoming = 2
    case TopRated = 3
}

class HomeViewController: UIViewController {
    
    private var randomTrendyMovie: Movie?
    private var headerView: HeroHeaderUIView?
 //  private var heroHeader = HeroHeaderUIView()
    private let refreshControl = UIRefreshControl()
    private let sectionTitles: [String] = ["Trendy", "Popular", "Upcoming", "Top rated"]
    
    private let homeTable: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(CollectionTableViewCell.self, forCellReuseIdentifier: CollectionTableViewCell.identifier)
        return table
    }()
    
    //    override func viewWillAppear(_ animated: Bool) {
    //        super.viewWillAppear(animated)
    //        if UITraitCollection.current.userInterfaceStyle == .dark {
    //                print("Dark mode")
    //            heroHeader.basicColor = UIColor.black
    //            heroHeader.addGradient()
    //            }
    //            else {
    //                print("Light mode")
    //                heroHeader.basicColor = UIColor.white
    //                heroHeader.addGradient()
    //            }
    //
    //
    //    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(homeTable)
        homeTable.delegate = self
        homeTable.dataSource = self
        headerView = HeroHeaderUIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 450))
        homeTable.separatorStyle = .none
        homeTable.backgroundColor = .systemBackground
        homeTable.tableHeaderView = headerView
        configureNavBar()
        configureHeaderView()
        setupRefreshControl()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeTable.frame = view.bounds
    }
    

}

extension HomeViewController {
    private func configureHeaderView() {
        
        APICaller.shared.getTrendyMovies { [weak self] result in
            switch result {
            case .success(let movies):
                let selectedTitle = movies.randomElement()
                
                self?.randomTrendyMovie = selectedTitle
                DispatchQueue.main.async {
                    self?.headerView?.configureHeaderImage(with: MovieViewModel(titleName: selectedTitle?.title ?? "", posterUrl: selectedTitle?.poster_path ?? ""))
                    self?.homeTable.refreshControl?.endRefreshing()
                    
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func setupRefreshControl() {
        
        refreshControl.addTarget(self, action: #selector(refreshContent), for: .valueChanged)
        homeTable.refreshControl = refreshControl
    }
    
    private func configureNavBar() {
        var image = UIImage(named: "miniLogo")
        image = image?.withRenderingMode(.alwaysOriginal)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: #selector(aboutAction))
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationItem.leftBarButtonItems =
        [
            // UIBarButtonItem(image: UIImage(systemName: "info"), style: .done, target: self, action:  #selector(aboutAction)),
            UIBarButtonItem(image: UIImage(systemName: "film"), style: .done, target: self, action:  #selector(selectedAction))
        ]
        navigationController?.navigationBar.tintColor = .systemGray
    }
    
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionTableViewCell.identifier, for: indexPath) as? CollectionTableViewCell else { return UITableViewCell() }
        
        cell.delegate = self
        cell.backgroundColor = .systemBackground
        switch indexPath.section {
        case Sections.TrendyMovies.rawValue:
            APICaller.shared.getTrendyMovies { result in
                switch result {
                case .success(let movies):
                    cell.configure(with: movies)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
        case Sections.Popular.rawValue:
            APICaller.shared.getPopular { result in
                switch result {
                case .success(let movies):
                    cell.configure(with: movies)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
        case Sections.Upcoming.rawValue:
            APICaller.shared.getUpcomingMovies { result in
                switch result {
                case .success(let movies):
                    //   print(movies[0].poster_path)
                    cell.configure(with: movies)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
        case Sections.TopRated.rawValue:
            APICaller.shared.getTopratedMovies { result in
                switch result {
                case .success(let movies):
                    cell.configure(with: movies)
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
        guard let header = view as? UITableViewHeaderFooterView else {return}
        let background = UIView(frame: view.bounds)
        background.backgroundColor = .systemBackground
        header.backgroundView = background
        header.textLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
        header.textLabel?.frame = CGRect(x: header.bounds.origin.x, y: header.bounds.origin.y, width: 100, height: header.bounds.height)
        header.textLabel?.text = header.textLabel?.text?.capitlizeFirstLetter()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    //MARK: - Hide navigation bar
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaultOffset = view.safeAreaInsets.top
        let ofset = scrollView.contentOffset.y + defaultOffset
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -ofset))
    }
    
    
}

extension HomeViewController: CollectionTableViewCellDelegate {
    func collectionTableViewCellDidTapCell(_ cell: CollectionTableViewCell, viewModel: MoviePreviewViewModel) {
        DispatchQueue.main.async { [weak self] in
            let vc = MoviePreviewViewController()
            vc.configure(with: viewModel)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension HomeViewController {
    //MARK: - Animation
    private func shakeLabel() {
        let animation = CAKeyframeAnimation()
        animation.keyPath = "position.x"
        animation.values = [0, 15, -10, 15, 0]
        animation.keyTimes = [0, 0.16, 0.5, 0.83, 1]
        animation.duration = 0.4
        animation.isAdditive = true
        headerView?.layer.add(animation, forKey: "shake")
    }
}

extension HomeViewController {
    @objc func refreshContent() {
        configureHeaderView()
        shakeLabel()
        print("refresh")
    }
    @objc func selectedAction() {
        let vc = DownloadsViewController()
        self.navigationController?.pushViewController(vc, animated: true)
        print("person")
    }
    @objc func aboutAction() {
        showAlert()
    }
}
extension HomeViewController {
    func showAlert() {
        let alertController = UIAlertController(title: "Cinematrix",
                                                message: "This is cinematrix. Brand new and simple app for quick movie search",
                                                preferredStyle: .actionSheet)
        alertController.view.tintColor = .gray
        let defaultAction = UIAlertAction(title: "Got it ✌️", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}

