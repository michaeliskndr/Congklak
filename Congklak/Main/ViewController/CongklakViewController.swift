//
//  CongklakViewController.swift
//  Congklak
//
//  Created by Michael Iskandar on 18/01/24.
//

import UIKit

protocol CongklakViewModelResponder {
    func playMove(at index: Int) -> Bool
    func getBoard() -> [Int]
    func isGameFinished() -> Bool
    func getCurrentPlayer() -> Int
    
    var playerOneWarehouse: Int { get }
    var playerTwoWarehouse: Int { get }
}

class CongklakViewController: UIViewController {
    
    var viewModel: CongklakViewModelResponder?
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 24)
        return label
    }()

    let containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    let playerLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    let playerOneLabel: UILabel = {
        let label = UILabel()
        label.text = "Player 1"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()

    let playerTwoScoreView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 35
        view.clipsToBounds = true
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    let playerTwoLabel: UILabel = {
        let label = UILabel()
        label.text = "Player 2"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    let playerOneScoreView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 35
        view.clipsToBounds = true
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    let playerOneScoreLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "0"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    let playerTwoScoreLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "0"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
        
    let boardCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        let padding: CGFloat = 40
        let itemSpacing: CGFloat = 10 * 6
        let itemWidth = (UIScreen.main.bounds.width - padding - itemSpacing) / 11
        layout.estimatedItemSize = .init(width: itemWidth, height: 50)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        
        collectionView.register(HoleCell.self, forCellWithReuseIdentifier: HoleCell.reuseIdentifier)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        view.backgroundColor = .white
        
        titleLabel.text = "Congklak the game"
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
        ])

        playerLabel.text = "Player \(viewModel?.getCurrentPlayer() ?? 1)'s turn"
        view.addSubview(playerLabel)
        playerLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            playerLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
            playerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            playerLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
        view.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 130),
            containerView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ])
                
        containerView.addSubview(playerTwoScoreView)
        playerTwoScoreView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            playerTwoScoreView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            playerTwoScoreView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            playerTwoScoreView.heightAnchor.constraint(equalToConstant: 70),
            playerTwoScoreView.widthAnchor.constraint(equalToConstant: 70)
        ])
        
        playerTwoScoreView.addSubview(playerTwoScoreLabel)
        playerTwoScoreLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            playerTwoScoreLabel.centerXAnchor.constraint(equalTo: playerTwoScoreView.centerXAnchor),
            playerTwoScoreLabel.centerYAnchor.constraint(equalTo: playerTwoScoreView.centerYAnchor),
        ])
        
        view.addSubview(playerOneLabel)
        playerOneLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            playerOneLabel.topAnchor.constraint(equalTo: playerTwoScoreView.bottomAnchor, constant: 40),
            playerOneLabel.centerXAnchor.constraint(equalTo: playerTwoScoreView.centerXAnchor)
        ])

        boardCollectionView.dataSource = self
        boardCollectionView.delegate = self
        containerView.addSubview(boardCollectionView)
        boardCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            boardCollectionView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            boardCollectionView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10),
            boardCollectionView.leadingAnchor.constraint(equalTo: playerTwoScoreView.trailingAnchor, constant: 10),
            boardCollectionView.heightAnchor.constraint(equalToConstant: 120)
        ])
        
        containerView.addSubview(playerOneScoreView)
        playerOneScoreView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            playerOneScoreView.centerYAnchor.constraint(equalTo: boardCollectionView.centerYAnchor),
            playerOneScoreView.leadingAnchor.constraint(equalTo: boardCollectionView.trailingAnchor, constant: 10),
            playerOneScoreView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            playerOneScoreView.heightAnchor.constraint(equalToConstant: 70),
            playerOneScoreView.widthAnchor.constraint(equalToConstant: 70)
        ])

        playerOneScoreView.addSubview(playerOneScoreLabel)
        playerOneScoreLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            playerOneScoreLabel.centerXAnchor.constraint(equalTo: playerOneScoreView.centerXAnchor),
            playerOneScoreLabel.centerYAnchor.constraint(equalTo: playerOneScoreView.centerYAnchor),
        ])
        
        view.addSubview(playerTwoLabel)
        playerTwoLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            playerTwoLabel.topAnchor.constraint(equalTo: playerOneScoreView.bottomAnchor, constant: 40),
            playerTwoLabel.centerXAnchor.constraint(equalTo: playerOneScoreView.centerXAnchor)
        ])
    }
}

extension CongklakViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.getBoard().count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HoleCell.reuseIdentifier, for: indexPath) as? HoleCell else {
            return UICollectionViewCell()
        }
        
        let stones = viewModel?.getBoard()[indexPath.item]
        cell.configure(with: stones ?? 0)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        /// Handle the move logic here
        
        guard viewModel?.playMove(at: indexPath.item) ?? false else {
            showAlert(message: "Player \(viewModel?.getCurrentPlayer() ?? 1)'s invalid move")
            return
        }
        
        /// update board state
        reloadBoard()
        /// update score
        updateScore()
        /// check game is finished or not
        checkIfGameIsFinished()
    }
}

extension CongklakViewController {
    
    func reloadBoard() {
        playerLabel.text = "Player \(viewModel?.getCurrentPlayer() ?? 1)'s turn"
        boardCollectionView.reloadData()
    }
    
    func updateScore() {
        playerOneScoreLabel.text = "\(viewModel?.playerOneWarehouse ?? 1)"
        playerTwoScoreLabel.text = "\(viewModel?.playerTwoWarehouse ?? 2)"
    }
    
    func checkIfGameIsFinished() {
        if viewModel?.isGameFinished() ?? false {
            let winner = viewModel?.getCurrentPlayer() ?? 1
            showAlert(message: "Game Over! Player \(winner) wins!")
        }
    }
}

fileprivate extension CongklakViewController {
    
    func showAlert(message: String) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}
