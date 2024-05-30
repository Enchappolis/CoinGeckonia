//
//  Color+Extension.swift
//  CoinGeckonia
//
//  Created by Enchappolis on 4/5/24.
//

import Foundation
import SwiftUI

extension Color {
    
    static let theme = ColorTheme()
    static let launch = LaunchColorTheme()
}

struct ColorTheme {
    
    let accent = Color("AccentColor")
    let backgound = Color("BackgroundColor")
    let green = Color("GreenCustomColor")
    let red = Color("RedCustomColor")
    let secondaryText = Color("SecondaryTextColor")
}

struct LaunchColorTheme {
    
    let backgound = Color("LaunchBackgroundColor")
}
