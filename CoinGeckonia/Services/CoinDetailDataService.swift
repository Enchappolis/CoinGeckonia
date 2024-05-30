//
//  CoinDetailDataService.swift
//  CoinGeckonia
//
//  Created by Enchappolis on 4/24/24.
//

import Foundation
import Combine

/*
URL:
 https://api.coingecko.com/api/v3/coins/bitcoin?localization=false&tickers=false&market_data=false&community_data=false&developer_data=false&sparkline=false
*/

class CoinDetailDataService {
    
    @Published var coinDetail: CoinDetail?
    
    private let coin: Coin
    private var coinDetailSubscription: AnyCancellable?
    
    private var networkingManager: NetworkingServiceProvider
    
    init(coin: Coin,
         networkingManager: NetworkingServiceProvider = NetworkingManager.shared) {
        
        self.networkingManager = networkingManager
        self.coin = coin
        getCoinDetails()
    }
    
    func getCoinDetails() {

        let urlString = "https://api.coingecko.com/api/v3/coins/\(coin.id)?localization=false&tickers=false&market_data=false&community_data=false&developer_data=false&sparkline=false"

        guard let url = URL(string: urlString) else { return }
        
        coinDetailSubscription = networkingManager.download(url: url)
            .tryMap({ data -> CoinDetail in
                
                let decoder = JSONDecoder()
                
                guard let coinDetail = try? decoder.decode(CoinDetail.self, from: data) else {
                    throw NetworkingManager.NetworkingError.decodeError
                }
                
                return coinDetail
            })
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: networkingManager.handleCompletion, receiveValue: { [weak self] coinDetail in
                
                guard let self = self else { return }
                
                self.coinDetail = coinDetail
                
                self.coinDetailSubscription?.cancel()
            })
    }
}
