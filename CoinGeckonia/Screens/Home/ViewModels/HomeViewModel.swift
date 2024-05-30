//
//  HomeViewModel.swift
//  CoinGeckonia
//
//  Created by Enchappolis on 4/9/24.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    
    @Published var liveCoins: [Coin] = []
    @Published var searchText = ""
    @Published var sortOption: SortOption = .rank
    @Published var isLoading = false
    @Published var errorFetchingCoins: NetworkingManager.NetworkingError!
    
    private let coinDataService: CoinDataService
    private var cancellabel = Set<AnyCancellable>()
    
    init(coinDataService: CoinDataService = CoinDataService()) {
        
        self.coinDataService = coinDataService
        
        addSubscribers()
    }
    
    func addSubscribers() {
        
        $searchText
            .combineLatest(coinDataService.$liveCoins, $sortOption)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(filterAndSortCoins)
            .sink { [weak self] filteredAndSortedCoins in
                
                guard let self = self else { return }
                
                self.liveCoins = filteredAndSortedCoins
                
                self.isLoading = false
            }
            .store(in: &cancellabel)
        
        coinDataService.$errorFetchingCoins
            .dropFirst()
            .sink { [weak self] error in
                self?.errorFetchingCoins = error
            }
            .store(in: &cancellabel)
            
    }
    
    private func filterAndSortCoins(returnedSearchText: String, coins: [Coin], sortOption: SortOption) -> [Coin] {
        
        var updatedCoins = filterCoins(returnedSearchText: returnedSearchText, coins: coins)
        
        sortCoins(coins: &updatedCoins, sortOption: sortOption)
        
        return updatedCoins
    }
    
    private func filterCoins(returnedSearchText: String, coins: [Coin]) -> [Coin] {
        
        guard !returnedSearchText.isEmpty else {
            return coins
        }
        
        let lowercasedText = returnedSearchText.lowercased()
        
        return coins.filter { coin in
            
            return  coin.name.lowercased().contains(lowercasedText) ||
                    coin.symbol.lowercased().contains(lowercasedText) ||
                    coin.id.lowercased().contains(lowercasedText)
        }
    }
    
    private func sortCoins(coins: inout [Coin], sortOption: SortOption) {
        
        switch sortOption {
        case .rank, .holdings:
            coins.sort(by: { $0.rank < $1.rank })
        case .rankReversed, .holdingsReversed:
            coins.sort(by: { $0.rank > $1.rank })
        case .price:
            coins.sort(by: { $0.currentPrice > $1.currentPrice })
        case .priceReversed:
            coins.sort(by: { $0.currentPrice < $1.currentPrice })
        }
    }
    
    func getData() {
        isLoading = true
        coinDataService.getCoins()
    }
}
