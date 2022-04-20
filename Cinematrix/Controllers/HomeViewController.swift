//
//  HomeViewController.swift
//  Cinematrix
//
//  Created by  Mr.Ki on 11.04.2022.
//

import UIKit



enum Sections: Int {
    case TrendyMovies = 0
   // case TrendyTv = 1
    case Popular = 1
    case Upcoming = 2
    case TopRated = 3
}

class HomeViewController: UIViewController {
    
    private var randomTrendyMovie: Movie?
    private var headerView: HeroHeaderUIView?

   
  //  var heroHeader = HeroHeaderUIView()
    let refreshControl = UIRefreshControl()
    let sectionTitles: [String] = ["Trendy", "Popular", "Upcoming", "Top rated"]
    
    private let homeTable: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(CollectionTableViewCell.self, forCellReuseIdentifier: CollectionTableViewCell.identifier)
        return table
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(homeTable)
        
        homeTable.delegate = self
        homeTable.dataSource = self
        homeTable.separatorStyle = .none
        homeTable.backgroundColor = .systemBackground
        configureNavBar()
        
        headerView = HeroHeaderUIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 450))
        homeTable.tableHeaderView = headerView
        configureHeaderView()
        setupRefreshControl()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeTable.frame = view.bounds
    }
    
//    private func getTrendyMovies() {
//        APICaller.shared.getTrendyMovies { results in
//            switch results {
//            case .success(let movies):
//                print(movies)
//            case .failure(let error):
//                print(error)
//            }
//        }
//    }
    
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
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: nil)
        
        navigationItem.leftBarButtonItems =
        [
        UIBarButtonItem(image: UIImage(systemName: "info"), style: .done, target: self, action:  #selector(aboutAction)),
        UIBarButtonItem(image: UIImage(systemName: "star"), style: .done, target: self, action:  #selector(personAction))
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
            
//        case Sections.TrendyTv.rawValue:
//            APICaller.shared.getTrendyTv { result in
//                switch result {
//                case .success(let movies):
//                    cell.configure(with: movies)
//                case .failure(let error):
//                    print(error.localizedDescription)
//                }
//            }
            
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
        
     //   cell.configure(with: "")
        
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
//                        guard let title = self?.titleForPreviewHome else {return}
//                        vc.titleForPreview = title
            self?.navigationController?.pushViewController(vc, animated: true)
          //  vc.
//            vc.configure(with: MoviePreviewViewModel(title: title ?? "No data", youtubeView: viewModel.youtubeView, titleOverview: viewModel.titleOverview ))
    //        vc.configure(with: MoviePreviewViewModel(title: titleName, youtubeView: video, titleOverview: title.overview ?? "No data"))
           
//            guard let title = self?.titleForPreviewHome else {return}
//            vc.titleForPreview = title
        }
    }
}

extension HomeViewController {
    @objc func refreshContent() {
        configureHeaderView()
        print("refresh")
        }
    @objc func personAction() {
        let vc = DownloadsViewController()
        self.navigationController?.pushViewController(vc, animated: true)
        print("person")
        }
    @objc func mailAction() {
        print("mail")
        }
    @objc func aboutAction() {
        showAlert()
        print("about")
        }
}

extension HomeViewController {
    func showAlert() {
       let alert = UIAlertController(title: "About cinematrix",
                                     message: "Hey, this is fresh and easy to use app for all cine lovers",
                                     preferredStyle: .actionSheet)
       alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true) {
            alert.view.tintColor = .gray
        }
   }
}
