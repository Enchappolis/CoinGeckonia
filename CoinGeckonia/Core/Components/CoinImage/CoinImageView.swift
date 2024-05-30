//
//  CoinImageView.swift
//  CoinGeckonia
//
//  Created by Enchappolis on 4/10/24.
//

import SwiftUI

struct CoinImageView: View {
    
    @StateObject private var coinImageViewModel: CoinImageViewModel
    
    init(coin: Coin) {
        _coinImageViewModel = StateObject(wrappedValue: CoinImageViewModel(coin: coin))
    }
    
    var body: some View {
        
        ZStack {
            
            if let image = coinImageViewModel.image {
                
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            } else if coinImageViewModel.isLoading {
                ProgressView()
            } else {
                Image(systemName: "questionmark.app.fill")
                    .foregroundColor(.theme.secondaryText)
            }
        }
    }
}

struct CoinImageView_Previews: PreviewProvider {
    static var previews: some View {
        CoinImageView(coin: Coin.exampleData())
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
