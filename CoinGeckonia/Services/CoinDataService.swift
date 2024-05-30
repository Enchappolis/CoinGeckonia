//
//  CoinDataService.swift
//  CoinGeckonia
//
//  Created by Enchappolis on 4/9/24.
//

import Foundation
import Combine

/*
URL:
https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=20&page=1&sparkline=true&price_change_percentage=24h&locale=en
*/

class CoinDataService {
    
    @Published var liveCoins: [Coin] = []
    @Published var errorFetchingCoins: NetworkingManager.NetworkingError!
    
    private var coinSubscription: AnyCancellable?
    
    private var networkingManager: NetworkingServiceProvider
    
    init(networkingManager: NetworkingServiceProvider = NetworkingManager.shared) {
        
        self.networkingManager = networkingManager
    }
    
    func getCoins() {

        let urlString = "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=20&page=1&sparkline=true&price_change_percentage=24h&locale=en"

        guard let url = URL(string: urlString) else { return }
        
        coinSubscription = networkingManager.download(url: url)
            .tryMap({ data -> [Coin] in
                
                let decoder = JSONDecoder()
                
                guard let coins = try? decoder.decode([Coin].self, from: data) else {
                    throw NetworkingManager.NetworkingError.decodeError
                }
                
                return coins
            })
            .mapError({ error -> NetworkingManager.NetworkingError in
                return error as? NetworkingManager.NetworkingError ?? .unknown
            })
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                
                switch completion {
                case .finished:
                    break
                case .failure(_):
                    self?.errorFetchingCoins = .unknown
                }
            }, receiveValue: { [weak self] coins in
                guard let self = self else { return }
                
                self.liveCoins = coins
                
                self.coinSubscription?.cancel()
            })
    }
}
