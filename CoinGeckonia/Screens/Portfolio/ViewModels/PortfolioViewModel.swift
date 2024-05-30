//
//  PortfolioViewModel.swift
//  CoinGeckonia
//
//  Created by Enchappolis on 4/9/24.
//

import Foundation
import Combine

class PortfolioViewModel: ObservableObject {
    
    @Published var portfolioCoins: [Coin] = []
    @Published var searchText = ""
    @Published var sortOption: SortOption = .rank
    
    var homeViewModel: HomeViewModel?
    private let portfolioCoreDataService = PortfolioCoreDataService()
    private var cancellabel = Set<AnyCancellable>()
    
    init() {
        addSubscribers()
    }
    
    func getPortfolios() {
        portfolioCoreDataService.getPortfolios()
    }
    
    func deletePortfolio(coin: Coin) {
        portfolioCoreDataService.deletePortfolio(coin: coin)
    }
    
    func updatePortfolio(coin: Coin, amount: Double) {
        portfolioCoreDataService.updatePortfolio(coin: coin, amount: amount)
    }
    
    func deletePortfolio(offsets: IndexSet) {
        
        for index in offsets {
            let coin = portfolioCoins[index]
            portfolioCoreDataService.deletePortfolio(coin: coin)
        }
    }
    
    func addPortfolio(coin: Coin, amount: Double) {
        
        portfolioCoreDataService.addPortfolio(coin: coin, amount: amount)
    }
    
    func addSubscribers() {
        
        $searchText
            .combineLatest($sortOption)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(filterAndSortCoins)
            .sink { [weak self] filteredAndSortedCoins in
                
                guard let self = self else { return }
                
                self.portfolioCoins = filteredAndSortedCoins
            }
            .store(in: &cancellabel)
                
        portfolioCoreDataService.$portfolioEntities
            .map { portfolioEntities -> [Coin] in
             
                let coins: [Coin] =  portfolioEntities.compactMap { portfolioEntity in
                    
                    if let coin = self.homeViewModel?.liveCoins.first(where: { $0.id == portfolioEntity.coinId }) {
                        return coin.updateHoldings(amount: portfolioEntity.amount)
                    }
                    return nil
                }
                
                return coins.sorted(by: { $0.name < $1.name })
            }
            .sink { [weak self] returnedCoins in
                
                guard let self = self else { return }
                
                self.portfolioCoins = returnedCoins
            }
            .store(in: &cancellabel)
    }
    
    private func filterAndSortCoins(returnedSearchText: String, sortOption: SortOption) -> [Coin] {
        
        var updatedCoins = filterCoins(returnedSearchText: returnedSearchText)
        
        sortPortfolioCoins(coins: &updatedCoins, sortOption: sortOption)
        
        return updatedCoins
    }
    
    private func filterCoins(returnedSearchText: String) -> [Coin] {
        
        guard !returnedSearchText.isEmpty else {
            portfolioCoreDataService.getPortfolios()
            return portfolioCoins
        }
        
        let lowercasedText = returnedSearchText.lowercased()
        
        return portfolioCoins.filter { coin in
            
            return  coin.name.lowercased().contains(lowercasedText) ||
                    coin.symbol.lowercased().contains(lowercasedText) ||
                    coin.id.lowercased().contains(lowercasedText)
        }
    }
    
    private func sortPortfolioCoins(coins: inout [Coin], sortOption: SortOption) {
        
        switch sortOption {
        case .rank:
            coins.sort(by: { $0.rank < $1.rank })
        case .rankReversed:
            coins.sort(by: { $0.rank > $1.rank })
        case .holdings:
            coins.sort(by: { $0.currentHoldingsValue > $1.currentHoldingsValue })
        case .holdingsReversed:
            coins.sort(by: { $0.currentHoldingsValue < $1.currentHoldingsValue })
        case .price:
            coins.sort(by: { $0.currentPrice > $1.currentPrice })
        case .priceReversed:
            coins.sort(by: { $0.currentPrice < $1.currentPrice })
        }
    }
}
