//
//  CongklakRouter.swift
//  Congklak
//
//  Created by Michael Iskandar on 22/01/24.
//

import UIKit

protocol CongklakRouting {
    func makeCongklakViewController() -> UIViewController
}

struct CongklakRouter: CongklakRouting {
    
    func makeCongklakViewController() -> UIViewController {
        let viewModel = CongklakViewModel()
        let viewController = CongklakViewController()
        
        viewController.viewModel = viewModel
        return viewController
    }
}
