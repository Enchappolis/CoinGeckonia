//
//  PortfolioView.swift
//  CoinGeckonia
//
//  Created by Enchappolis on 5/15/24.
//

import SwiftUI

struct PortfolioView: View {
    
    @EnvironmentObject private var portfolioViewModel: PortfolioViewModel
    
    @State private var activeSheet: ActiveSheet?
    @State private var selectedCoin: Coin?
    @State private var showDetailView = false
    
    enum ActiveSheet: Identifiable {
        case add
        case edit(updateCoin: Coin?)
        
        var id: Int {
            switch self {
            case .add:
                return 1
            case .edit(_):
                return 2
            }
        }
    }
    
    var body: some View {
        
        ZStack {
            
            Color.theme.backgound
                .ignoresSafeArea()
            
            VStack {
                
                columnTitles
                
                if portfolioViewModel.portfolioCoins.isEmpty {
                    portfolioEmptyText
                } else {
                    portfolioListView
                }
                
                Spacer()
            }
        }
        .navigationTitle("Portfolio")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    activeSheet = .add
                }, label: {
                    Image(systemName: "plus")
                })
            }
        }
        .toolbarRole(.editor)
        .sheet(item: $activeSheet, content: { activeSheet in
            
            switch activeSheet {
            case .add:
                PortfolioDetailView()
                    .environmentObject(portfolioViewModel)
            case .edit(let updateCoin):
                PortfolioDetailView(updateCoin: updateCoin)
                    .environmentObject(portfolioViewModel)
            }
        })
        .onAppear {
            portfolioViewModel.getPortfolios()
        }
        .searchable(text: $portfolioViewModel.searchText, prompt: "Search by name or symbol ...")
    }
    
    private var columnTitles: some View {
        
        HStack {
            
            HStack(spacing: 4) {
                Text("Coin")
                    .transaction { transaction in
                        transaction.animation = nil
                    }
                    .fontWeight((portfolioViewModel.sortOption == .rank ||
                                 portfolioViewModel.sortOption == .rankReversed) ? .bold : .regular)
                
                Image(systemName: "chevron.down")
                    .opacity(
                        (portfolioViewModel.sortOption == .rank ||
                         portfolioViewModel.sortOption == .rankReversed) ? 1.0 : 0.0
                    )
                    .rotationEffect(Angle(degrees: portfolioViewModel.sortOption == .rank ? 0 : 180))
            }
            .onTapGesture {
                
                withAnimation(.default) {
                    portfolioViewModel.sortOption = portfolioViewModel.sortOption == .rank ? .rankReversed : .rank
                }
            }
            
            Spacer()
            
            HStack(spacing: 4) {
                Text("Holdings")
                    .transaction { transaction in
                        transaction.animation = nil
                    }
                    .fontWeight((portfolioViewModel.sortOption == .holdings ||
                                 portfolioViewModel.sortOption == .holdingsReversed) ? .bold : .regular)
                Image(systemName: "chevron.down")
                    .opacity(
                        (portfolioViewModel.sortOption == .holdings ||
                         portfolioViewModel.sortOption == .holdingsReversed) ? 1.0 : 0.0
                    )
                    .rotationEffect(Angle(degrees: portfolioViewModel.sortOption == .holdings ? 0 : 180))
            }
            .onTapGesture {
                
                withAnimation(.default) {
                    portfolioViewModel.sortOption = portfolioViewModel.sortOption == .holdings ? .holdingsReversed : .holdings
                }
            }
            
            HStack(spacing: 4) {
                Text("Price")
                    .transaction { transaction in
                        transaction.animation = nil
                    }
                    .fontWeight((portfolioViewModel.sortOption == .price ||
                                 portfolioViewModel.sortOption == .priceReversed) ? .bold : .regular)
                
                Image(systemName: "chevron.down")
                    .opacity(
                        (portfolioViewModel.sortOption == .price ||
                         portfolioViewModel.sortOption == .priceReversed) ? 1.0 : 0.0
                    )
                    .rotationEffect(Angle(degrees: portfolioViewModel.sortOption == .price ? 0 : 180))
            }
            .frame(width: UIScreen.main.bounds.width / 3.5, alignment: .trailing)
            .onTapGesture {
                
                withAnimation(.default) {
                    portfolioViewModel.sortOption = portfolioViewModel.sortOption == .price ? .priceReversed : .price
                }
            }
        }
        .font(.caption)
        .foregroundColor(.theme.secondaryText)
        .padding(.horizontal)
    }
    
    private var portfolioEmptyText: some View {
        
        Text("You haven't added any coins to your portfolio yet.")
            .font(.callout)
            .foregroundColor(Color.theme.accent)
            .fontWeight(.medium)
            .multilineTextAlignment(.center)
            .padding(50)
    }
    
    private var portfolioListView: some View {
        
        List {
            
            ForEach( portfolioViewModel.portfolioCoins) { coin in
                
                ListRowView(coin: coin, showHoldingsColumn: true)
                    .listRowInsets(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                    .listRowBackground(Color.theme.backgound)
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        Button(role: .destructive) {
                            delete(coin: coin)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        Button(action: {
                            update(coin: coin)
                        }, label: {
                            Label("Edit", systemImage: "square.and.pencil")
                        })
                        .tint(.blue)
                    }
                    .onTapGesture {
                        selectedCoin = coin
                        showDetailView.toggle()
                    }
    
            }
        }
        .listStyle(.plain)
        .navigationDestination(isPresented: $showDetailView) {
            
            if let selectedCoin = selectedCoin {
                DetailView(coin: selectedCoin)
            }
        }
    }
    
    private func update(coin: Coin) {
        activeSheet = .edit(updateCoin: coin)
    }
    
    private func delete(coin: Coin) {
        portfolioViewModel.deletePortfolio(coin: coin)
    }
    
    private func delete(at offsets: IndexSet) {
        portfolioViewModel.deletePortfolio(offsets: offsets)
    }
}

#Preview {
    
    NavigationStack {
        PortfolioView()
            .environmentObject(PortfolioViewModel())
    }
}
