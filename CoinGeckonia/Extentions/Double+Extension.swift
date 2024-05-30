//
//  Double+Extension.swift
//  CoinGeckonia
//
//  Created by Enchappolis on 4/8/24.
//

import Foundation

extension Double {
    
    /// Converts a Double into a Currency with 2 decimal points.
    /// ```
    /// Example:
    /// Converts 1234.5678 to $1,234.56
    /// ```
    private var currencyFormatter: NumberFormatter {
        
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .currency
        formatter.locale = .current
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }
    
    /// Converts a Double into a Currency String with 2 decimal points.
    /// ```
    /// Example:
    /// Converts 1234.5678 to "$1,234.56"
    /// ```
    func asCurrencyWith2Decimals() -> String {
        let nsNumber = NSNumber(value: self)
        return currencyFormatter.string(from: nsNumber) ?? "0.00"
    }
    
    /// Converts a Double into a String representation with 2 decimal points.
    /// ```
    /// Example:
    /// Converts 1234.5678 to "1234.56"
    /// ```
    func asNumberString() -> String {
        return String(format: "%.2f", self)
    }
    
    /// Converts a Double into a String representation with 2 decimal points and percent symbol.
    /// ```
    /// Example:
    /// Converts 1234.5678 to "1234.56%"
    /// ```
    func asPercentString() -> String {
        return asNumberString() + "%"
    }
    
    /// Convert a Double to a String with K, M, Bn, Tr abbreviations.
    /// ```
    /// Examples:
    /// Convert 12 to 12.00
    /// Convert 1234 to 1.23K
    /// Convert 12345678 to 12.34M
    /// Convert 123456789012 to 123.45Bn
    /// Convert 12345678901234 to 12.34Tr
    /// ```
    func formattedWithAbbreviations() -> String {
        let num = abs(Double(self))
        let sign = (self < 0) ? "-" : ""

        switch num {
        case 1_000_000_000_000...:
            let formatted = num / 1_000_000_000_000
            let stringFormatted = formatted.asNumberString()
            return "\(sign)\(stringFormatted)Tr"
        case 1_000_000_000...:
            let formatted = num / 1_000_000_000
            let stringFormatted = formatted.asNumberString()
            return "\(sign)\(stringFormatted)Bn"
        case 1_000_000...:
            let formatted = num / 1_000_000
            let stringFormatted = formatted.asNumberString()
            return "\(sign)\(stringFormatted)M"
        case 1_000...:
            let formatted = num / 1_000
            let stringFormatted = formatted.asNumberString()
            return "\(sign)\(stringFormatted)K"
        case 0...:
            return self.asNumberString()

        default:
            return "\(sign)\(self)"
        }
    }
}
