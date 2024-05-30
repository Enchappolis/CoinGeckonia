//
//  DetailView.swift
//  CoinGeckonia
//
//  Created by Enchappolis on 4/23/24.
//

import SwiftUI

struct DetailView: View {
    
    @StateObject private var detailViewModel: DetailViewModel
    
    @State private var showFullDescription = false
    
    private let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    private let spacing: CGFloat = 30
    
    init(coin: Coin) {
        self._detailViewModel = StateObject(wrappedValue: DetailViewModel(coin: coin))
        
        print("Detail View init \(coin.name)")
    }
    
    var body: some View {
        
        ScrollView {
            VStack {
                
                ChartView(coin: detailViewModel.coin)
                    .padding(.vertical)
                
                overviewTitle
                descriptionSection
                
                Divider()
                
                overviewGrid
                additionalTitle
                
                Divider()
                
                additionalGrid
                websiteSection
            }
            .padding()
        }
        .navigationTitle(detailViewModel.coin.name)
        .background(Color.theme.backgound)
    }
}

extension DetailView {
    
    private var overviewTitle: some View {
        Text("Overview")
            .font(.title)
            .bold()
            .foregroundColor(Color.theme.accent)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var descriptionSection: some View {
        
        Group {
            if let coinDescription = detailViewModel.coinDescription,
               !coinDescription.isEmpty {
                
                VStack(alignment: .leading) {
                    Text(coinDescription)
                        .lineLimit(showFullDescription ? nil : 3)
                        .font(.callout)
                        .foregroundColor(.theme.secondaryText)
                    
                    Button(action: {
                        withAnimation(.easeInOut) {
                            showFullDescription.toggle()
                        }
                    }, label: {
                        Text(showFullDescription ? "Show less..." : "Show more...")
                            .font(.caption)
                            .fontWeight(.bold)
                            .padding(.vertical, 5)
                    })
                    .tint(.blue)
                }
            }
        }
    }
    
    private var additionalTitle: some View {
        Text("Additional Details")
            .font(.title)
            .bold()
            .foregroundColor(Color.theme.accent)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var overviewGrid: some View {
        LazyVGrid(
            columns: columns,
            alignment: .leading,
            spacing: spacing,
            pinnedViews: [],
            content: {
                ForEach(detailViewModel.overviewStatistics) { statistic in
                    StatisticView(statistic: statistic)
                }
        })
    }
    
    private var additionalGrid: some View {
        LazyVGrid(
            columns: columns,
            alignment: .leading,
            spacing: spacing,
            pinnedViews: [],
            content: {
                ForEach(detailViewModel.additionalStatistics) { statistic in
                    StatisticView(statistic: statistic)
                }
        })
    }
    
    private var websiteSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            if let websiteString = detailViewModel.websiteURL,
               let url = URL(string: websiteString) {
                Link("Website", destination: url)
            }
            
            if let redditString = detailViewModel.redditURL,
               let url = URL(string: redditString) {
                Link("Reddit", destination: url)
            }
            
        }
        .tint(.blue)
        .frame(maxWidth: .infinity, alignment: .leading)
        .font(.headline)
    }
}

#Preview {
    NavigationStack {
        DetailView(coin: Coin.exampleData())
    }
}
