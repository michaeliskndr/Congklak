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
    
    let playerLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    let playerOneWarehouseLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    let playerTWoWarehouseLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()

    let boardCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        let padding: CGFloat = 40
        let itemSpacing: CGFloat = 10 * 6
        let itemWidth = (UIScreen.main.bounds.width - padding - itemSpacing) / 8
        layout.estimatedItemSize = .init(width: itemWidth, height: 30)
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

        playerLabel.text = "Player \(viewModel?.getCurrentPlayer() ?? 1)'s turn"
        view.addSubview(playerLabel)
        playerLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            playerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            playerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            playerLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        boardCollectionView.dataSource = self
        boardCollectionView.delegate = self
        view.addSubview(boardCollectionView)
        boardCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            boardCollectionView.topAnchor.constraint(equalTo: playerLabel.bottomAnchor, constant: 20),
            boardCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            boardCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            boardCollectionView.heightAnchor.constraint(equalToConstant: 120)
        ])
        
        view.addSubview(playerOneWarehouseLabel)
        playerOneWarehouseLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            playerOneWarehouseLabel.topAnchor.constraint(equalTo: boardCollectionView.bottomAnchor, constant: 20),
            playerOneWarehouseLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
        ])

        view.addSubview(playerTWoWarehouseLabel)
        playerTWoWarehouseLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            playerTWoWarehouseLabel.topAnchor.constraint(equalTo: playerOneWarehouseLabel.bottomAnchor, constant: 20),
            playerTWoWarehouseLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
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
        // Handle the move logic here
        
        guard viewModel?.playMove(at: indexPath.item) ?? false else {
            showAlert(message: "Player \(viewModel?.getCurrentPlayer() ?? 1)'s invalid move")
            return
        }
        
        playerLabel.text = "Player \(viewModel?.getCurrentPlayer() ?? 1)'s turn"
        boardCollectionView.reloadData()
        
        playerOneWarehouseLabel.text = "Player 1 count: \(viewModel?.playerOneWarehouse ?? 1)"
        playerTWoWarehouseLabel.text = "player 2 count: \(viewModel?.playerTwoWarehouse ?? 2)"

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
