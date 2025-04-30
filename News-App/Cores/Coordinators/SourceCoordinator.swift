//
//  SourceCoordinator.swift
//  News-App
//
//  Created by BTS.id on 30/04/25.
//

import UIKit
import Foundation

protocol SourceCoordinatorProtocol: Coordinator {
    func showSourceViewController()
}

class SourceCoordinator: NSObject, SourceCoordinatorProtocol {
    weak var finishDelegate: CoordinatorFinishDelegate?
    
    var navigationController: UINavigationController
    
    var childCoordinators: [Coordinator] = []
    
    var type: CoordinatorType { .source }
    
    var category: String!
    
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        
        super.init()
        
        self.navigationController.delegate = self
    }
    
    deinit {
        print("SourceCoordinator deinit")
    }
    
    func start() {
        showSourceViewController()
    }
    
    func showSourceViewController() {
        let sourceVC: SourceViewController = .init(viewModel: SourceInjection.provideSourceViewModel())
        
        sourceVC.category = category
        sourceVC.didSendEventClosure = { [weak self] event in
            switch event {
            case .source:
                self?.navigationController.hideNavigationBar()
                
                self?.navigationController.popViewController(animated: true)
            case .news:
                self?.finish()
            }
        }
        
        navigationController.pushViewController(sourceVC, animated: true)
    }
}

extension SourceCoordinator: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        guard let fromViewController = navigationController.transitionCoordinator?.viewController(forKey: .from) else {
            return
        }
        
        if navigationController.viewControllers.contains(fromViewController) {
            return
        }
        
        if fromViewController is SourceViewController {
            self.finish()
        }
    }
}

extension SourceCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        childCoordinators = childCoordinators.filter({ $0.type != childCoordinator.type })
        
    }
}
