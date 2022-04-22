//
//  MoviePreviewViewController.swift
//  Cinematrix
//
//  Created by  Mr.Ki on 14.04.2022.
//

import UIKit
import WebKit

class MoviePreviewViewController: UIViewController {
    
    var titleForPreview: Movie?
    private var movies: [Movie] = [Movie]()
    
    lazy var contentViewSize = CGSize(width: self.view.frame.width, height: self.view.frame.height + 250)
    
    lazy var scrollView: UIScrollView = {
        let view = UIScrollView(frame: .zero)
        view.backgroundColor = .systemBackground
        view.frame = self.view.bounds
        view.contentSize = contentViewSize
        return view
    }()
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.frame.size = contentViewSize
        return view
    }()
    
    private let titleLabel: UILabel = {
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.text = "Matrix"
        return label
    }()
    
    private let overViewLabel: UILabel = {
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.numberOfLines = 0
        label.text = "This is realy nice movie"
        return label
    }()
    
    private let downloadButton: UIButton = {
        
        let button = UIButton(type: .system)
        button.backgroundColor = .clear
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.gray.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Add to list", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.clipsToBounds = true
        button.layer.cornerRadius = 14
        button.addTarget(self, action: #selector(addAction), for: .touchUpInside)
        return button
    }()
    
    private let backButton: UIButton = {
        
        let button = UIButton(type: .system)
        button.backgroundColor = .clear
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.gray.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Back", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.clipsToBounds = true
        button.layer.cornerRadius = 14
        button.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        return button
    }()
    
    private let horizontalStackView: UIStackView = {
        let horizontalStackView = UIStackView()
        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        horizontalStackView.axis = .horizontal
        horizontalStackView.distribution = .fillEqually
        horizontalStackView.alignment = .center
        horizontalStackView.spacing = 40
        
        return horizontalStackView
        
    }()
    
    private let webWiew: WKWebView = {
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupAddButton()
    }
    
    func setupAddButton() {
        
        if titleForPreview?.title == nil {
            downloadButton.isHidden = true
        } else {
            downloadButton.isHidden = false
        }
    }
    
    func setup() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        
        containerView.addSubview(webWiew)
        containerView.addSubview(titleLabel)
        containerView.addSubview(overViewLabel)
        horizontalStackView.addArrangedSubview(backButton)
        horizontalStackView.addArrangedSubview(downloadButton)
        containerView.addSubview(horizontalStackView)
    }
    func setupConstraints() {
        let containerViewConstrains = [
            containerView.topAnchor.constraint(equalTo: view.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ]
        NSLayoutConstraint.activate(containerViewConstrains)
        
        let webViewConstraints = [
            webWiew.topAnchor.constraint(equalTo: view.topAnchor),
            webWiew.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webWiew.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webWiew.heightAnchor.constraint(equalToConstant: 300)
        ]
        NSLayoutConstraint.activate(webViewConstraints)
        
        let titleLabelConstraints = [
            titleLabel.topAnchor.constraint(equalTo: webWiew.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ]
        NSLayoutConstraint.activate(titleLabelConstraints)
        
        let overViewLabelConstraints = [
            overViewLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15),
            overViewLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            overViewLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ]
        NSLayoutConstraint.activate(overViewLabelConstraints)
        
        let stackViewConstraints = [
            backButton.widthAnchor.constraint(equalToConstant: 140),
            downloadButton.widthAnchor.constraint(equalToConstant: 140),
            horizontalStackView.topAnchor.constraint(equalTo: overViewLabel.bottomAnchor, constant: 20),
            horizontalStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            horizontalStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ]
        NSLayoutConstraint.activate(stackViewConstraints)
        
    }
    
    func configure(with model: MoviePreviewViewModel) {
        titleLabel.text = model.title
        overViewLabel.text = model.titleOverview
        
        guard let  url = URL(string: "https://www.youtube.com/embed/\(model.youtubeView.id.videoId)") else { return }
        webWiew.load(URLRequest(url: url))
    }
    
}

extension MoviePreviewViewController {
    @objc func backAction(sender: UIButton!) {
        print("Back button tapped")
        navigationController?.popViewController(animated: true)
        // dismiss(animated: true, completion: nil)
    }
    @objc func addAction(sender: UIButton!) {
        print("Add button tapped")
        //   print(titleForPreview?.title)
        guard let currentMovie = titleForPreview else {return}
        //   print(currentMovie.title)
        downloadTitleAt(currentMovie: currentMovie)
    }
}

extension MoviePreviewViewController {
    // save movie in core data
    private func downloadTitleAt(currentMovie: Movie) {
        
        DataPersistentManager.shared.downloadMovieToDataBase(model: currentMovie) { result in
            switch result {
            case .success():
                print("Downloaded to DB")
                NotificationCenter.default.post(name: NSNotification.Name("loaded"), object: nil)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        //   print("Downloading \(movies[indexPath.row].title)")
    }
    
}
