//
//  CoinLogoView.swift
//  CoinGeckonia
//
//  Created by Enchappolis on 4/18/24.
//

import SwiftUI

struct CoinLogoView: View {
    
    let coin: Coin
    
    var body: some View {
        
        VStack {
            CoinImageView(coin: coin)
                .frame(width: 50, height: 50)
            Text(coin.symbol.uppercased())
                .font(.headline)
                .foregroundColor(Color.theme.accent)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
            Text(coin.name)
                .font(.caption)
                .foregroundColor(Color.theme.secondaryText)
                .lineLimit(2)
                .minimumScaleFactor(0.5)
                .multilineTextAlignment(.center)

        }
        .frame(width: 75)
    }
}

struct CoinLogoView_Previews: PreviewProvider {
    static var previews: some View {
        CoinLogoView(coin: Coin.exampleData())
            .previewLayout(.sizeThatFits)

        CoinLogoView(coin: Coin.exampleData())
            .previewLayout(.sizeThatFits)
            .preferredColorScheme(.dark)
    }
}
