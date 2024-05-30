//
//  NetworkingManager.swift
//  CoinGeckonia
//
//  Created by Enchappolis on 4/9/24.
//

import Foundation
import Combine

class NetworkingManager: NetworkingServiceProvider {
    
    static let shared = NetworkingManager()

    private init () { }
    
    enum NetworkingError: LocalizedError, Equatable {
        case badURLResponse(url: URL)
        case badURLResponse(url: URL, statusCode: Int)
        case decodeError
        case unknown
        
        var errorDescription: String? {
            switch self {
            case .badURLResponse(url: let url, statusCode: let statusCode):
                return "Bad response from URL: \(url) StatusCode: \(statusCode)"
            case .decodeError:
                return "Decode Error"
            case .unknown:
                return "Unknown error occured"
            }
        }
    }
    
    func download(url: URL) -> AnyPublisher<Data, Error> {
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap({ try self.handleURLResponse(output: $0, url: url) })
            .retry(3)
            .eraseToAnyPublisher()
    }
    
    func handleURLResponse(output: URLSession.DataTaskPublisher.Output,
                                  url: URL) throws -> Data {
        guard let reponse = output.response as? HTTPURLResponse else {
            throw NetworkingError.badURLResponse(url: url)
        }
        
        guard (200..<300).contains(reponse.statusCode) else {
            throw NetworkingError.badURLResponse(url: url, statusCode: reponse.statusCode)
        }
        
        return output.data
    }
    
    func handleCompletion(completion: Subscribers.Completion<Error>) {
        
        switch completion {
        case .finished:
            break
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
}
