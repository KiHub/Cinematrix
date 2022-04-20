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

//    
//    private let playButton: UIButton = {
//        let button = UIButton()
//        button.setTitle("Play", for: .normal)
//        button.layer.borderColor = UIColor.white.cgColor
//        button.layer.borderWidth  = 1
//        button.layer.cornerRadius = 15
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.addTarget(self, action: #selector(playAction), for: .touchUpInside)
//        return button
//    }()
//    
//    private let addButton: UIButton = {
//        let button = UIButton()
//        button.setTitle("Add to list", for: .normal)
//        button.layer.borderColor = UIColor.white.cgColor
//        button.layer.borderWidth  = 1
//        button.layer.cornerRadius = 15
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.addTarget(self, action: #selector(addAction), for: .touchUpInside)
//        return button
//    }()
    
    
    
    private let heroImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        

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
       // addSubview(playButton)
       // addSubview(addButton)
       // applyConstraints()
    }
    
//    private func applyConstraints() {
//        let playButtonConstraints = [
//            playButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 70),
//            playButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -30),
//            playButton.widthAnchor.constraint(equalToConstant: 120)
//        ]
//        NSLayoutConstraint.activate(playButtonConstraints)
//
//        let downloadButtonConstraints = [
//            addButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -70),
//            addButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -30),
//            addButton.widthAnchor.constraint(equalToConstant: 120)
//        ]
//        NSLayoutConstraint.activate(downloadButtonConstraints)
//
//    }
    
    public func configureHeaderImage(with model: MovieViewModel) {
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(model.posterUrl)") else { return }

        heroImageView.sd_setImage(with: url, completed: nil)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        heroImageView.frame = bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//extension HeroHeaderUIView {
//
//    @objc func playAction(sender: UIButton!) {
//      print("Button tapped")
//
//
//    }
//    @objc func addAction(sender: UIButton!) {
//      print("Add tapped")
//
//
//    }
//}


