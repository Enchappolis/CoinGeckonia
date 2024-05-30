//
//  Statistic.swift
//  CoinGeckonia
//
//  Created by Enchappolis on 4/16/24.
//

import Foundation

struct Statistic: Identifiable {
    
    let id = UUID()
    let title: String
    let value: String
    let percentageChanged: Double?
    
    init(title: String, value: String, percentageChanged: Double? = nil) {
        self.title = title
        self.value = value
        self.percentageChanged = percentageChanged
    }
}

extension Statistic {
    
    static var oneSampleData: Statistic {
        return Statistic(title: "title", value: "$282.28", percentageChanged: 23.03)
    }
    
    static var sampleData: [Statistic] {
        
        return [
            Statistic(title: "title", value: "$282.28", percentageChanged: nil),
            Statistic(title: "title2", value: "$22482.28", percentageChanged: 0.08),
            Statistic(title: "title3", value: "$233382.28", percentageChanged: -5.01),
            Statistic(title: "title4", value: "$25464352.28", percentageChanged: -36.28),
            Statistic(title: "title5", value: "$2332.28", percentageChanged: 5.01),
            Statistic(title: "title6", value: "$254344252.28", percentageChanged: 36.28)
            ]
    }
}

