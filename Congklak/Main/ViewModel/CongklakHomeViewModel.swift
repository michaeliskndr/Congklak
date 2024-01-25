//
//  CongklakHomeViewModel.swift
//  Congklak
//
//  Created by Michael Iskandar on 25/01/24.
//

import UIKit
import Swinject

class CongklakHomeViewModel {
    var router: CongklakRouting? = InjectorManager.shared.resolve(CongklakRouting.self)
    
    init() {}
}

extension CongklakHomeViewModel: CongklakHomeResponder {
    func goToGame(from viewController: UIViewController) {
        guard let router = router else { return }
        router.goToGame(from: viewController)
    }
}
