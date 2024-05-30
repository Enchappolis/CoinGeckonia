//
//  NetworkingServiceProvider.swift
//  CoinGeckonia
//
//  Created by Enchappolis on 5/24/24.
//

import Foundation
import Combine

protocol NetworkingServiceProvider {
    func download(url: URL) -> AnyPublisher<Data, Error>
    func handleCompletion(completion: Subscribers.Completion<Error>)
}
