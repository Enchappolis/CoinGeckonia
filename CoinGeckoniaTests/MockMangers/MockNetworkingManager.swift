//
//  MockNetworkingManager.swift
//  CoinGeckoniaTests
//
//  Created by Enchappolis on 5/24/24.
//

import Foundation
import Combine
@testable import CoinGeckonia

class MockNetworkingManager: NetworkingServiceProvider {
    
    var testforSuccessfulData = true
    
    func download(url: URL) -> AnyPublisher<Data, Error> {
        
        if testforSuccessfulData {
            guard let data = MockReader.readJson() else {
                
                let error = NSError(domain:"", code: 1, userInfo: nil)
                
                return Fail(error: error)
                    .eraseToAnyPublisher()
            }
            
            return Just(data)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
            
        } else {
            let error = NSError(domain:"", code: 1, userInfo: nil)
            
            return Fail(error: error)
                .eraseToAnyPublisher()
        }
    }
    
    func handleCompletion(completion: Subscribers.Completion<Error>) {
        
    }
}
