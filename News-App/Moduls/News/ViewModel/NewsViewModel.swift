//
//  NewsViewModel.swift
//  News-App
//
//  Created by BTS.id on 30/04/25.
//

protocol NewsViewModelProtocol {
    // MARK: - States
    var getNewsState: ((_ event: RequestState) -> Void)? { get set }
    
    // MARK: - Variables
    var articles: [ArticleItemModel] { get set }
    var isMaxPage: Bool { get set }
    
    // MARK: - Functions
    func getNews(request: NewsRequestModel)
}

class NewsViewModel: NewsViewModelProtocol {
    let service: NewsServiceProtocol
    
    var getNewsState: ((RequestState) -> Void)?
    
    var articles: [ArticleItemModel] = []
    var isMaxPage: Bool = false
    
    init(service: NewsServiceProtocol) {
        self.service = service
    }
    
    func getNews(request: NewsRequestModel) {
        getNewsState?(.loading)
        
        Task {
            let result = try await self.service.getNews(request: request)
            
            switch result {
            case .success(let response):
                if request.page == 1 {
                    isMaxPage = false
                    
                    articles.removeAll()
                }
                
                articles.append(contentsOf: response.articles ?? [])
                
                if (response.articles?.isEmpty ?? true) {
                    isMaxPage = true
                }
                
                self.getNewsState?(.loaded)
            case .failure(let failure):
                self.getNewsState?(.error(failure))
            }
        }
    }
}
