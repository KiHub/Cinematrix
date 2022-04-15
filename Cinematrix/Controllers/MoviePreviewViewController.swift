//
//  MoviePreviewViewController.swift
//  Cinematrix
//
//  Created by  Mr.Ki on 14.04.2022.
//

import UIKit
import WebKit

class MoviePreviewViewController: UIViewController {
    
   
    
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
        button.setTitle("Download", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.clipsToBounds = true
        button.layer.cornerRadius = 14
     
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
    
    func setup() {
        view.backgroundColor = .systemBackground
        view.addSubview(webWiew)
        view.addSubview(titleLabel)
        view.addSubview(overViewLabel)
      //  view.addSubview(downloadButton)
        horizontalStackView.addArrangedSubview(backButton)
        horizontalStackView.addArrangedSubview(downloadButton)
        view.addSubview(horizontalStackView)
    }
    func setupConstraints() {
        let webViewConstraints = [
            webWiew.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
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
        
//        let downloadButtonConstraints = [
//            downloadButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            downloadButton.topAnchor.constraint(equalTo: overViewLabel.bottomAnchor, constant: 20),
//            downloadButton.widthAnchor.constraint(equalToConstant: 150)
//        ]
//        NSLayoutConstraint.activate(downloadButtonConstraints)
        let stackViewConstraints = [
          //  downloadButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
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
    
    @objc func backAction(sender: UIButton!) {
      print("Button tapped")
        navigationController?.popViewController(animated: true)
       // dismiss(animated: true, completion: nil)
    }
    

}
