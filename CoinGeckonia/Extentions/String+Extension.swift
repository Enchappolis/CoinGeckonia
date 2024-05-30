//
//  String+Extension.swift
//  CoinGeckonia
//
//  Created by Enchappolis on 4/24/24.
//

import Foundation

extension String {
    var removingHTMLOccurances: String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
}
