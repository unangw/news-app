//
//  NewsCoordinator.swift
//  News-App
//
//  Created by BTS.id on 30/04/25.
//

import UIKit
import Foundation

protocol NewsCoordinatorProtocol: Coordinator {
    func showNewsViewController()
}

class NewsCoordinator: NSObject, NewsCoordinatorProtocol {
    weak var finishDelegate: CoordinatorFinishDelegate?
    
    var navigationController: UINavigationController
    
    var childCoordinators: [Coordinator] = []
    
    var type: CoordinatorType { .news }
    
    var source: SourceItemModel?
    
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        
        super.init()
        
        self.navigationController.delegate = self
    }
    
    deinit {
        print("NewsCoordinator deinit")
    }
    
    func start() {
        showNewsViewController()
    }
    
    func showNewsViewController() {
        let newsVC: NewsViewController = .init(viewModel: NewsInjection.provideNewsViewModel())
        
        newsVC.source = source
        newsVC.didSendEventClosure = { [weak self] event in
            switch event {
            case .news:
                self?.navigationController.popViewController(animated: true)
                
                self?.finish()
            case .newsDetails(let article):
                self?.showNewsDetailsViewController(article: article)
            }
        }
        
        navigationController.pushViewController(newsVC, animated: true)
    }
    
    func showNewsDetailsViewController(article: ArticleItemModel) {
        let newsDetailsVC: NewsDetailsViewController = NewsDetailsViewController()
        
        newsDetailsVC.article = article
        newsDetailsVC.didSendEventClosure = { [weak self] event in
            switch event {
            case .newsDetails:
                self?.navigationController.popViewController(animated: true)
            }
        }
        
        navigationController.pushViewController(newsDetailsVC, animated: true)
    }
}

extension NewsCoordinator: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        guard let fromViewController = navigationController.transitionCoordinator?.viewController(forKey: .from) else {
            return
        }
        
        if navigationController.viewControllers.contains(fromViewController) {
            return
        }
        
        if fromViewController is NewsViewController {
            self.finish()
        }
    }
}

extension NewsCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        childCoordinators = childCoordinators.filter({ $0.type != childCoordinator.type })
        
    }
}
