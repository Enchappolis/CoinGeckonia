//
//  MockReader.swift
//  CoinGeckoniaTests
//
//  Created by Enchappolis on 5/23/24.
//

import Foundation
@testable import CoinGeckonia

struct MockReader {
    
    static func readCoinMockData() -> Coin? {
        
        guard let data = readJson() else {
            return nil
        }
        
        do {
            
            let coin = try JSONDecoder().decode(Coin.self, from: data)
            
            return coin
            
        } catch {
            return nil
        }
    }
    
    static func readJson() -> Data? {
        
        guard let fileUrl = Bundle(for: CoinGeckoniaTests.self).url(forResource: "Coin", withExtension: "json") else {
            return nil
        }
        
        do {

            let data = try Data(contentsOf: fileUrl)
            
            return data
            
        } catch {
            return nil
        }
    }
}
