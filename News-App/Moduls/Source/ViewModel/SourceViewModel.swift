//
//  SourceViewModel.swift
//  News-App
//
//  Created by BTS.id on 30/04/25.
//

protocol SourceViewModelProtocol {
    // MARK: - States
    var getSourceState: ((_ event: RequestState) -> Void)? { get set }
    
    // MARK: - Variables
    var sources: [SourceItemModel] { get set }
    
    // MARK: - Functions
    func getSource(request: SourceRequestModel)
}

class SourceViewModel: SourceViewModelProtocol {
    let service: SourceServiceProtocol
    
    var getSourceState: ((RequestState) -> Void)?
    
    var sources: [SourceItemModel] = []
    
    init(service: SourceServiceProtocol) {
        self.service = service
    }
    
    func getSource(request: SourceRequestModel) {
        getSourceState?(.loading)
        
        Task {
            let result = try await self.service.getSource(request: request)
            
            switch result {
            case .success(let response):
                sources = response.sources ?? []
                
                self.getSourceState?(.loaded)
            case .failure(let failure):
                self.getSourceState?(.error(failure))
            }
        }
    }
}
