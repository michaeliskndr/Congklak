//
//  CongklakHomeViewController.swift
//  Congklak
//
//  Created by Michael Iskandar on 25/01/24.
//

import UIKit

protocol CongklakHomeResponder {
    func goToGame(from viewController: UIViewController)
}

class CongklakHomeViewController: UIViewController {
    
    var viewModel: CongklakHomeResponder?
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 32)
        label.text = "Congklak"
        return label
    }()
    
    lazy var miniTitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 12)
        label.text = "Blitz"
        return label
    }()
    
    lazy var startButton: UIButton = {
        let button = UIButton()
        button.setTitle("Start", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 1
        button.backgroundColor = .white
        return button
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 3
        label.text = "This game is called Congklak Blitz, the objective is to score as much as you can in 16 turn. The winner is the one who score higher in 16 turn, meanwhile you can adhere to congklak traditional rule"
        label.textAlignment = .center
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: -70)
        ])
        
        view.addSubview(miniTitleLabel)
        miniTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            miniTitleLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            miniTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor)
        ])
        
        view.addSubview(descriptionLabel)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: miniTitleLabel.bottomAnchor, constant: 16),
            descriptionLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            descriptionLabel.widthAnchor.constraint(equalToConstant: 480)
        ])
        
        view.addSubview(startButton)
        startButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            startButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            startButton.widthAnchor.constraint(equalToConstant: 120),
            startButton.heightAnchor.constraint(equalToConstant: 40),
            startButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40)
        ])
        
        startButton.addTarget(self, action: #selector(goToGame), for: .touchUpInside)
    }
    
    @objc func goToGame(_ sender: UIButton) {
        viewModel?.goToGame(from: self)
    }
}
