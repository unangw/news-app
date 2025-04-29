//
//  DashboardCoordinator.swift
//  News-App
//
//  Created by BTS.id on 29/04/25.
//

import UIKit
import Foundation

protocol MainCoordinatorProtocol: Coordinator {
    func showMainViewController()
}

class MainCoordinator: NSObject, MainCoordinatorProtocol {
    weak var finishDelegate: CoordinatorFinishDelegate?
    
    var navigationController: UINavigationController
    
    var childCoordinators: [Coordinator] = []
    
    var type: CoordinatorType { .main }
    
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        
        super.init()
        
        self.navigationController.delegate = self
    }
    
    deinit {
        print("MainCoordinator deinit")
    }
    
    func start() {
        showMainViewController()
    }
    
    func showMainViewController() {
        let mainVC: MainViewController = .init(viewModel: MainInjection.provideMainViewModel())
        
        mainVC.didSendEventClosure = { [weak self] event in
            switch event {
            case .main:
                self?.finish()
            case .source:
                self?.finish()
            }
        }
        
        navigationController.pushViewController(mainVC, animated: true)
    }
}

extension MainCoordinator: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        guard let fromViewController = navigationController.transitionCoordinator?.viewController(forKey: .from) else {
            return
        }
        
        if navigationController.viewControllers.contains(fromViewController) {
            return
        }
    }
}

extension MainCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        childCoordinators = childCoordinators.filter({ $0.type != childCoordinator.type })
        
    }
}
