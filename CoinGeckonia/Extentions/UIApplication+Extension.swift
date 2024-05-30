//
//  UIApplication+Extension.swift
//  CoinGeckonia
//
//  Created by Enchappolis on 4/16/24.
//

import UIKit

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
