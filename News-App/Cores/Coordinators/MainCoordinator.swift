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
        
        // Hide navigation bar
        self.navigationController.hideNavigationBar()
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
            case .source(let category):
                self?.showSourceFlow(category: category)
            }
        }
        
        navigationController.pushViewController(mainVC, animated: true)
    }
    
    func showSourceFlow(category: String) {
        // Implement Source Coordinator Flow
        let sourceCoordinator = SourceCoordinator.init(navigationController)
        sourceCoordinator.finishDelegate = self
        
        sourceCoordinator.category = category
        
        sourceCoordinator.start()
        childCoordinators.append(sourceCoordinator)
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
        
        switch childCoordinator.type {
        case .source:
            // Hide navigation bar
            self.navigationController.hideNavigationBar()
        default:
            return
        }
        
    }
}
