//
//  CongklakFactory.swift
//  Congklak
//
//  Created by Michael Iskandar on 25/01/24.
//

import UIKit

protocol CongklakViewFactory {
    func makeCongklakViewController() -> UIViewController
    func makeCongklakHomeViewController() -> UIViewController
}

struct CongklakFactory: CongklakViewFactory {
    func makeCongklakViewController() -> UIViewController {
        let viewModel = CongklakViewModel()
        let viewController = CongklakViewController()
        
        viewController.viewModel = viewModel
        return viewController
    }
    
    func makeCongklakHomeViewController() -> UIViewController {
        let viewModel = CongklakHomeViewModel()
        let viewController = CongklakHomeViewController()
        
        viewController.viewModel = viewModel
        return viewController
    }
}
