//
//  HomeView.swift
//  CoinGeckonia
//
//  Created by Enchappolis on 5/14/24.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject private var homeViewModel: HomeViewModel
    
    @State private var showPortfolio = false
    @State private var selectedCoin: Coin?
    @State private var showDetailView = false
    
    var body: some View {
        
        ZStack {
            
            Color.theme.backgound
                .ignoresSafeArea()
            
            VStack {
                
                columnTitles
                
                liveCoinsListView

                Spacer()
            }
        }
        .navigationTitle("Live Values")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: $showPortfolio) {
            PortfolioView()
        }
        .toolbar {
            
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    showPortfolio.toggle()
                }, label: {
                    Image(systemName: "chevron.right")
                })
            }
        }
    }
    
    private var columnTitles: some View {
        
        HStack {
            
            HStack(spacing: 4) {
                Text("Coin")
                    .transaction { transaction in
                        transaction.animation = nil
                    }
                    .fontWeight((homeViewModel.sortOption == .rank ||
                                 homeViewModel.sortOption == .rankReversed) ? .bold : .regular)
                
                Image(systemName: "chevron.down")
                    .opacity(
                        (homeViewModel.sortOption == .rank ||
                         homeViewModel.sortOption == .rankReversed) ? 1.0 : 0.0
                    )
                    .rotationEffect(Angle(degrees: homeViewModel.sortOption == .rank ? 0 : 180))
            }
            .onTapGesture {
                
                withAnimation(.default) {
                    homeViewModel.sortOption = homeViewModel.sortOption == .rank ? .rankReversed : .rank
                }
            }
            
            Spacer()
            
            HStack(spacing: 4) {
                Text("Price")
                    .transaction { transaction in
                        transaction.animation = nil
                    }
                    .fontWeight((homeViewModel.sortOption == .price ||
                                 homeViewModel.sortOption == .priceReversed) ? .bold : .regular)
                
                Image(systemName: "chevron.down")
                    .opacity(
                        (homeViewModel.sortOption == .price ||
                         homeViewModel.sortOption == .priceReversed) ? 1.0 : 0.0
                    )
                    .rotationEffect(Angle(degrees: homeViewModel.sortOption == .price ? 0 : 180))
            }
            .frame(width: UIScreen.main.bounds.width / 3.5, alignment: .trailing)
            .onTapGesture {
                
                withAnimation(.default) {
                    homeViewModel.sortOption = homeViewModel.sortOption == .price ? .priceReversed : .price
                }
            }
        }
        .font(.caption)
        .foregroundColor(.theme.secondaryText)
        .padding(.horizontal)
    }
    
    private var liveCoinsListView: some View {
        
        List {
            
            ForEach(homeViewModel.liveCoins) { coin in
                ListRowView(coin: coin, showHoldingsColumn: false)
                    .listRowInsets(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                    .listRowBackground(Color.theme.backgound)
                    .onTapGesture {
                        selectedCoin = coin
                        showDetailView.toggle()
                    }
            }
        }
        .listStyle(.plain)
        .searchable(text: $homeViewModel.searchText, prompt: "Search by name or symbol ...")
        .refreshable {
            homeViewModel.getData()
        }
        .navigationDestination(isPresented: $showDetailView) {
            
            if let selectedCoin = selectedCoin {
                DetailView(coin: selectedCoin)
            }
        }
        .onAppear {
            homeViewModel.getData()
        }
    }
}

#Preview {
    NavigationStack {
        HomeView()
            .environmentObject(HomeViewModel())
    }
}
