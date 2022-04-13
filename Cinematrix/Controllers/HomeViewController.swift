//
//  HomeViewController.swift
//  Cinematrix
//
//  Created by  Mr.Ki on 11.04.2022.
//

import UIKit

enum Sections: Int {
    case TrendyMovies = 0
    case TrendyTv = 1
    case Popular = 2
    case Upcoming = 3
    case TopRated = 4
}

class HomeViewController: UIViewController {
    
    let sectionTitles: [String] = ["Trendy movies", "Trendy series", "Popular", "Upcoming movies", "Top rated"]
    
    private let homeTable: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(CollectionTableViewCell.self, forCellReuseIdentifier: CollectionTableViewCell.identifier)
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(homeTable)
        
        homeTable.delegate = self
        homeTable.dataSource = self
        
        configureNavBar()
        
        let headerView = HeroHeaderUIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 450))
        homeTable.tableHeaderView = headerView
        
      
        
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
    
    private func configureNavBar() {
        var image = UIImage(named: "miniLogo")
        image = image?.withRenderingMode(.alwaysOriginal)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: nil)
        
        navigationItem.leftBarButtonItems =
        [
        UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: self, action: nil),
        UIBarButtonItem(image: UIImage(systemName: "envelope"), style: .done, target: self, action: nil)
        ]
        navigationController?.navigationBar.tintColor = .systemGray
    }
    
}




extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionTableViewCell.identifier, for: indexPath) as? CollectionTableViewCell else { return UITableViewCell() }
        
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
            
        case Sections.TrendyTv.rawValue:
            APICaller.shared.getTrendyTv { result in
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
                    print(movies[0].poster_path)
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
