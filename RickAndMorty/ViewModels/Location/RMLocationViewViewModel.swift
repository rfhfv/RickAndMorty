//
//  RMLocationViewViewModel.swift
//  RickAndMorty
//
//  Created by admin on 18.06.2026.
//

import Foundation

final class RMLocationViewViewModel {
    
    private var locations: [RMLocation] = []
    
    private var cellViewModel: [String] = []
    
    init() {}
    
    public func fetchLocations() {
        RMService.shared.execute(.listCharactersRequests, expecting: String.self) { result in
            switch result {
            case .success(let model):
                break
            case .failure(let error):
                break
            }
        }
    }
    
    private var hasMoreResults: Bool {
        return false
    }
}
