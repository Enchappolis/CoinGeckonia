//
//  CoinImageViewModel.swift
//  CoinGeckonia
//
//  Created by Enchappolis on 4/10/24.
//

import UIKit
import Combine

class CoinImageViewModel: ObservableObject {
    
    @Published var image: UIImage?
    @Published var isLoading = false
    
    private let coinImageService: CoinImageService
    private let coin: Coin
    private var cancellables = Set<AnyCancellable>()
    
    init(coin: Coin) {
        
        self.coin = coin
        self.isLoading = true
        self.coinImageService = CoinImageService(coin: coin)
        self.addSubscriber()
    }
    
    private func addSubscriber() {
     
        coinImageService.$image
            .sink { [weak self] _ in

                self?.isLoading = false
                
            } receiveValue: { [weak self] uiImage in
                
                self?.image = uiImage
            }
            .store(in: &cancellables)

    }
}
