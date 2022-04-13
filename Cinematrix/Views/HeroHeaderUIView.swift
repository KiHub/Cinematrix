//
//  HeroHeaderUIView.swift
//  Cinematrix
//
//  Created by  Mr.Ki on 12.04.2022.
//

import UIKit
import SDWebImage


class HeroHeaderUIView: UIView {
    
    var basicColor = UIColor.systemBackground
    
    private let playButton: UIButton = {
        let button = UIButton()
        button.setTitle("Play", for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth  = 1
        button.layer.cornerRadius = 15
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let downloadButton: UIButton = {
        let button = UIButton()
        button.setTitle("Download", for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth  = 1
        button.layer.cornerRadius = 15
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    
    private let heroImageView: UIImageView = {
        let randomNumber = Int.random(in: 0..<11)
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        
        APICaller.shared.getTopratedMovies { result in
            switch result {
            case .success(let movies):
                var poster = movies[randomNumber].poster_path
                guard let url = URL(string: "https://image.tmdb.org/t/p/w500\(poster ?? "/abPQVYyNfVuGoFUfGVhlNecu0QG.jpg")") else { return }
                imageView.sd_setImage(with: url, completed: nil)
                DispatchQueue.main.async {
                    imageView.sd_setImage(with: url, completed: nil)
                }
            case .failure(let error):
                print(error.localizedDescription)
                
            }
        }
        return imageView
    }()
    
     func addGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            basicColor.cgColor,
            UIColor.clear.cgColor,
            basicColor.cgColor
           // UIColor.systemBackground.cgColor
        ]
        gradientLayer.frame = bounds
        layer.addSublayer(gradientLayer)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(heroImageView)
        addGradient()
        addSubview(playButton)
        addSubview(downloadButton)
        applyConstraints()
    }
    
    private func applyConstraints() {
        let playButtonConstraints = [
            playButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 70),
            playButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -30),
            playButton.widthAnchor.constraint(equalToConstant: 120)
        ]
        NSLayoutConstraint.activate(playButtonConstraints)
        
        let downloadButtonConstraints = [
            downloadButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -70),
            downloadButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -30),
            downloadButton.widthAnchor.constraint(equalToConstant: 120)
        ]
        NSLayoutConstraint.activate(downloadButtonConstraints)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        heroImageView.frame = bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
