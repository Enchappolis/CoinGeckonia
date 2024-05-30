//
//  ListRowView.swift
//  CoinGeckonia
//
//  Created by Enchappolis on 4/8/24.
//

import SwiftUI

struct ListRowView: View {
    
    let coin: Coin
    let showHoldingsColumn: Bool
    
    var body: some View {
        HStack(spacing: 0) {
            
            leftColumn
            
            Spacer()

            if showHoldingsColumn {
                centerColumn
            }
            
            rightColumn
        }
        .font(.subheadline)
        .contentShape(Rectangle())
    }
}

extension ListRowView {
    
    private var leftColumn: some View {
        
        Group {
            Text("\(coin.rank)")
                .font(.caption)
                .foregroundColor(.theme.secondaryText)
                .frame(minWidth: 30)
            
            CoinImageView(coin: coin)
                .frame(width: 30, height: 30)
            
            Text(coin.symbol.uppercased())
                .font(.headline)
                .padding(.leading, 6)
                .foregroundColor(.theme.secondaryText)
        }
    }
    
    private var centerColumn: some View {
        
        VStack(alignment: .trailing) {
            Text(coin.currentHoldingsValue.asCurrencyWith2Decimals())
                .bold()
            Text((coin.currentHoldings ?? 0).asNumberString())
            
        }
        .foregroundColor(.theme.secondaryText)
    }
    
    private var rightColumn: some View {
        
        VStack(alignment: .trailing) {
            Text(coin.currentPrice.asCurrencyWith2Decimals())
                .bold()
                .foregroundColor(.theme.secondaryText)
            
            Text(coin.priceChangePercentage24H?.asPercentString() ?? "0.0")
                .foregroundColor(
                    (coin.priceChangePercentage24H ?? 0.0) >= 0 ?
                    .theme.green :
                    .theme.red
                )
        }
        .frame(width: UIScreen.main.bounds.width / 3.5, alignment: .trailing)
    }
}


struct HomeRowView_Previews: PreviewProvider {
    static var previews: some View {
        ListRowView(coin: Coin.exampleData(), showHoldingsColumn: true)
            .previewLayout(.sizeThatFits)
        
        ListRowView(coin: Coin.exampleData(), showHoldingsColumn: true)
            .previewLayout(.sizeThatFits)
            .preferredColorScheme(.dark)
    }
}

