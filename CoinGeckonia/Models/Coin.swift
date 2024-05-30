//
//  Coin.swift
//  CoinGeckonia
//
//  Created by Enchappolis on 4/5/24.
//

import Foundation


 /*
 URL:
 https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=5&page=1&sparkline=true&price_change_percentage=24h&locale=en
 
 JSON:
 
[
    {
    "id": "bitcoin",
    "symbol": "btc",
    "name": "Bitcoin",
    "image": "https://assets.coingecko.com/coins/images/1/large/bitcoin.png?1696501400",
    "current_price": 67858,
    "market_cap": 1335247582695,
    "market_cap_rank": 1,
    "fully_diluted_valuation": 1425220171144,
    "total_volume": 35608096060,
    "high_24h": 68679,
    "low_24h": 66174,
    "price_change_24h": -508.22730583634984,
    "price_change_percentage_24h": -0.74339,
    "market_cap_change_24h": -10713572957.850098,
    "market_cap_change_percentage_24h": -0.79598,
    "circulating_supply": 19674293,
    "total_supply": 21000000,
    "max_supply": 21000000,
    "ath": 73738,
    "ath_change_percentage": -7.96104,
    "ath_date": "2024-03-14T07:10:36.635Z",
    "atl": 67.81,
    "atl_change_percentage": 99986.45932,
    "atl_date": "2013-07-06T00:00:00.000Z",
    "roi": null,
    "last_updated": "2024-04-05T23:28:35.601Z",
    "sparkline_in_7d": {
        "price": [
            69432.58774240862,
            69496.38370749578,
            67923.36299115152
        ]
    },
    "price_change_percentage_24h_in_currency": -0.7433879729831984
    }
]
 */

struct Coin: Codable, Identifiable, Equatable {
    let id, symbol, name: String
    let image: String
    let currentPrice: Double
    let marketCap, marketCapRank, fullyDilutedValuation, totalVolume: Double?
    let high24H, low24H, priceChange24H, priceChangePercentage24H: Double?
    let marketCapChange24H, marketCapChangePercentage24H, circulatingSupply, totalSupply: Double?
    let maxSupply: Double?
    let ath, athChangePercentage: Double?
    let athDate: String?
    let atl, atlChangePercentage: Double?
    let atlDate: String?
    let lastUpdated: String?
    let sparklineIn7D: SparklineIn7D?
    let priceChangePercentage24HInCurrency: Double?
    
    // Custom Property, not from json.
    let currentHoldings: Double?
    
    enum CodingKeys: String, CodingKey {
        case id, symbol, name, image
        case currentPrice = "current_price"
        case marketCap = "market_cap"
        case marketCapRank = "market_cap_rank"
        case fullyDilutedValuation = "fully_diluted_valuation"
        case totalVolume = "total_volume"
        case high24H = "high_24h"
        case low24H = "low_24h"
        case priceChange24H = "price_change_24h"
        case priceChangePercentage24H = "price_change_percentage_24h"
        case marketCapChange24H = "market_cap_change_24h"
        case marketCapChangePercentage24H = "market_cap_change_percentage_24h"
        case circulatingSupply = "circulating_supply"
        case totalSupply = "total_supply"
        case maxSupply = "max_supply"
        case ath
        case athChangePercentage = "ath_change_percentage"
        case athDate = "ath_date"
        case atl
        case atlChangePercentage = "atl_change_percentage"
        case atlDate = "atl_date"
        case lastUpdated = "last_updated"
        case sparklineIn7D = "sparkline_in_7d"
        case priceChangePercentage24HInCurrency = "price_change_percentage_24h_in_currency"
        
        // Custom Property, not from json.
        case currentHoldings
    }
    
    func updateHoldings(amount: Double) -> Coin {
        
        return Coin(id: id, symbol: symbol, name: name, image: image, currentPrice: currentPrice, marketCap: marketCap, marketCapRank: marketCapRank, fullyDilutedValuation: fullyDilutedValuation, totalVolume: totalVolume, high24H: high24H, low24H: low24H, priceChange24H: priceChange24H, priceChangePercentage24H: priceChangePercentage24H, marketCapChange24H: marketCapChange24H, marketCapChangePercentage24H: marketCapChangePercentage24H, circulatingSupply: circulatingSupply, totalSupply: totalSupply, maxSupply: maxSupply, ath: ath, athChangePercentage: athChangePercentage, athDate: athDate, atl: atl, atlChangePercentage: atlChangePercentage, atlDate: atlDate, lastUpdated: lastUpdated, sparklineIn7D: sparklineIn7D, priceChangePercentage24HInCurrency: priceChangePercentage24HInCurrency, currentHoldings: amount)
    }
    
    var currentHoldingsValue: Double {
        return (currentHoldings ?? 0) * currentPrice
    }
    
    var rank: Int {
        return Int(marketCapRank ?? 0)
    }
}

struct SparklineIn7D: Codable {
    let price: [Double]?
}

extension Coin {
    static func ==(lhs: Coin, rhs: Coin) -> Bool {
        return lhs.id == rhs.id
    }
}

extension Coin {
    
    static func exampleData() -> Coin {
        
        return Coin(id: "bitcoin",
                    symbol: "btc",
                    name: "Bitcoin",
                    image: "https://assets.coingecko.com/coins/images/1/large/bitcoin.png?1696501400",
                    currentPrice: 67858,
                    marketCap: 1335247582695,
                    marketCapRank: 1,
                    fullyDilutedValuation: 1425220171144,
                    totalVolume: 35608096060,
                    high24H: 68679,
                    low24H: 66174,
                    priceChange24H: -508.22730583634984,
                    priceChangePercentage24H: -0.74339,
                    marketCapChange24H: -10713572957.850098,
                    marketCapChangePercentage24H: -0.79598,
                    circulatingSupply: 19674293,
                    totalSupply: 21000000,
                    maxSupply: 21000000,
                    ath: 73738,
                    athChangePercentage: -7.96104,
                    athDate: "2024-03-14T07:10:36.635Z",
                    atl: 67.81,
                    atlChangePercentage: 99986.45932,
                    atlDate: "2013-07-06T00:00:00.000Z",
                    lastUpdated: "2024-04-05T23:28:35.601Z",
                    sparklineIn7D: SparklineIn7D(price: [
                        69432.58774240862,
                        69496.38370749578,
                        67923.36299115152,
                        63496.38370749578,
                        51496.38370749578,
                        63496.38370749578,
                        65496.38370749578,
                        55496.38370749578,
                        65496.38370749578,
                        69496.38370749578
                    ]),
                    priceChangePercentage24HInCurrency: -0.7433879729831984,
                    currentHoldings: 1)
    }
}
