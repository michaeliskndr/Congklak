//
//  CongklakViewController.swift
//  Congklak
//
//  Created by Michael Iskandar on 18/01/24.
//

import UIKit
import RxSwift

protocol CongklakViewModelResponder {
    func playMove(at index: Int)
    func playAgain()
    var boardObservable: Observable<[Int]> { get }
    var playerObservable: Observable<Int> { get }
    var playerOneWarehouseObservable: Observable<Int> { get }
    var playerTwoWarehouseObservable: Observable<Int> { get }
    var invalidMoveObservable: Observable<String?> { get }
    var winnerObservable: Observable<String?> { get }
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
    
    let playerTwoDescLabel: UILabel = {
        let label = UILabel()
        label.text = "Player 2"
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
    
    let playerOneDescLabel: UILabel = {
        let label = UILabel()
        label.text = "Player 1"
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
    
    let disposeBag = DisposeBag()
    
    var board: [Int] = [] {
        didSet {
            boardCollectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupRx()
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
        
        view.addSubview(playerTwoDescLabel)
        playerTwoDescLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            playerTwoDescLabel.topAnchor.constraint(equalTo: playerTwoScoreView.bottomAnchor, constant: 40),
            playerTwoDescLabel.centerXAnchor.constraint(equalTo: playerTwoScoreView.centerXAnchor)
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
        
        view.addSubview(playerOneDescLabel)
        playerOneDescLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            playerOneDescLabel.topAnchor.constraint(equalTo: playerOneScoreView.bottomAnchor, constant: 40),
            playerOneDescLabel.centerXAnchor.constraint(equalTo: playerOneScoreView.centerXAnchor)
        ])
    }
    
    private func setupRx() {
        viewModel?.playerObservable
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] player in
                guard let self = self else { return }
                self.playerLabel.text = "Player \(player)'s turn"
            }).disposed(by: disposeBag)
        
        viewModel?.boardObservable
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] board in
                guard let self = self else { return }
                self.board = board
            }).disposed(by: disposeBag)
        
        viewModel?.playerOneWarehouseObservable
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] score in
                guard let self = self else { return }
                self.playerOneScoreLabel.text = "\(score)"
            }).disposed(by: disposeBag)
        
        viewModel?.playerTwoWarehouseObservable
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] score in
                guard let self = self else { return }
                self.playerTwoScoreLabel.text = "\(score)"
            }).disposed(by: disposeBag)
        
        viewModel?.invalidMoveObservable
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] message in
                guard let self = self, let message = message else { return }
                self.showAlert(message: message)
            }).disposed(by: disposeBag)
        
        viewModel?.winnerObservable
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] message in
                guard let self = self, let message = message else { return }
                self.showAlert(message: message) { _ in
                    self.viewModel?.playAgain()
                }
            }).disposed(by: disposeBag)
    }
}

extension CongklakViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return board.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HoleCell.reuseIdentifier, for: indexPath) as? HoleCell else {
            return UICollectionViewCell()
        }
        
        let stones = board[indexPath.item]
        cell.configure(with: stones)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        /// Handle the move logic here
        viewModel?.playMove(at: indexPath.item)
    }
}

fileprivate extension CongklakViewController {
    
    func showAlert(message: String, handler: ((UIAlertAction) -> Void)? = nil) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: handler))
        present(alertController, animated: true, completion: nil)
    }
}
