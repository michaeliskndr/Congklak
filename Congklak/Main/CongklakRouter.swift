//
//  CongklakRouter.swift
//  Congklak
//
//  Created by Michael Iskandar on 22/01/24.
//

import UIKit

protocol CongklakRouting {
    func goToGame(from viewController: UIViewController)
}

struct CongklakRouter: CongklakRouting {
    
    var factory: CongklakViewFactory?
    
    init(factory: CongklakViewFactory? = InjectorManager.shared.resolve(CongklakViewFactory.self)) {
        self.factory = factory
    }
    
    func goToGame(from viewController: UIViewController) {
        guard let vc = factory?.makeCongklakViewController() else { return }
        viewController.navigationController?.pushViewController(vc, animated: true)
    }
}
