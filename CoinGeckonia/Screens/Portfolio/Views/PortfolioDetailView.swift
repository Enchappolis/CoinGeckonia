//
//  PortfolioDetailView.swift
//  CoinGeckonia
//
//  Created by Enchappolis on 5/17/24.
//

import SwiftUI

struct PortfolioDetailView: View {
    
    @Environment(\.presentationMode) private var presentationMode
    @EnvironmentObject private var homeViewModel: HomeViewModel
    @EnvironmentObject private var portfolioViewModel: PortfolioViewModel
    
    @State private var selectedCoin: Coin?
    @State private var quantityText = ""
    @State private var showCheckmark = false
    @State private var disableInput = false
    @State private var editMode = false
    
    init(updateCoin: Coin? = nil) {
        
        if updateCoin != nil {
            _selectedCoin = State(initialValue: updateCoin)
            _editMode = State(initialValue: true)
        }
    }
    
    var body: some View {
        
        NavigationStack {
            
            GeometryReader { proxy in
                
                ScrollView(.vertical) {
                    VStack(alignment: .leading, spacing: 0) {
                        
                        coinLogoList
                        
                        if selectedCoin != nil {
                            
                            portfolioInputSection
                        }
                        
                        lottieCheckmark
                    }
                    .frame(minHeight: proxy.size.height)
                }
                .navigationTitle(editMode ? "Edit Portfolio" : "Add Portfolio")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        XButtonView()
                            .disabled(disableInput ? true : false)
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        trailingToolbarItem
                    }
                }
                .searchable(
                    text: $homeViewModel.searchText,
                    placement: .navigationBarDrawer(
                        displayMode: .always
                    ),
                    prompt: "Search by name or symbol ..."
                )
                
            }
            .background(Color.theme.backgound)
        }
        .onAppear {
            let appearance = UINavigationBarAppearance()
            appearance.backgroundColor = UIColor(Color.theme.backgound)
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
        }
    }
}

extension PortfolioDetailView {
    
    private var coinLogoList: some View {
        
        ScrollView(.horizontal, showsIndicators: false) {
            
            ScrollViewReader(content: { proxy in
                LazyHStack(spacing: 10) {
                    ForEach(editMode ? portfolioViewModel.portfolioCoins : liveCoinsWithoutPortfolioCoins) { coin in
                        CoinLogoView(coin: coin)
                            .padding(4)
                            .onTapGesture {
                                withAnimation(.easeIn) {
                                    updateSelectedCoin(coin: coin)
                                }
                            }
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(selectedCoin?.id == coin.id ? Color.theme.green.opacity(0.3) : Color.clear)
                            )
                    }
                }
                .frame(height: 120)
                .padding(.leading)
                .onAppear {
                    scrollToCoin(scrollProxy: proxy)
                }
            })
        }
        .allowsHitTesting(disableInput ? false : true)
    }
    
    private var liveCoinsWithoutPortfolioCoins: [Coin] {
        
        let liveCoinsWithoutPortfolioCoins = homeViewModel.liveCoins.filter({ !portfolioViewModel.portfolioCoins.contains($0)})
        
        return liveCoinsWithoutPortfolioCoins
    }
    
    private func getCurrentValue() -> Double {
        
        if let quantity = Double(quantityText) {
            return quantity * (selectedCoin?.currentPrice ?? 0)
        }
        
        return 0
    }
    
    private func scrollToCoin(scrollProxy: ScrollViewProxy) {
        
        guard editMode else { return }
        
        if let coin = portfolioViewModel.portfolioCoins.first(where: { $0.id == selectedCoin?.id}) {
            scrollProxy.scrollTo(coin.id, anchor: .center)
        }
    }
    
    private var portfolioInputSection: some View {
        
        VStack(spacing: 20) {
            
            HStack {
                Text("Current price of \(selectedCoin?.symbol.uppercased() ?? ""):")
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(selectedCoin?.currentPrice.asCurrencyWith2Decimals() ?? "")
            }
            
            Divider()
            
            HStack {
                Text("Amount holding:")
                    .frame(maxWidth: .infinity, alignment: .leading)
                TextField("Ex: 1.4", text: $quantityText)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
            }.onAppear(perform: {
                if let selectedCoin = selectedCoin {
                    updateSelectedCoin(coin: selectedCoin)
                }
            })
            
            Divider()
            
            HStack {
                Text("Current Value:")
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(getCurrentValue().asCurrencyWith2Decimals())
            }
        }
        .transaction { transaction in
            transaction.animation = nil
        }
        .padding()
        .font(.headline)
    }
    
    private var trailingToolbarItem: some View {
        
        ZStack {
            
            Button {
                saveButtonTapped()
            } label: {
                Text("SAVE")
            }
            .opacity(
                (selectedCoin != nil &&
                 selectedCoin?.currentHoldings != Double(quantityText)) ? 1.0 : 0.0
            )

        }
        .font(.headline)
    }
    
    private var lottieCheckmark: some View {
        
        VStack {
            
            if showCheckmark {
                
                LottiePlaceholderView(onAnimationDidFinish: {
                    presentationMode.wrappedValue.dismiss()
                })
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .scaleEffect(CGSize(width: 2.0, height: 2.0), anchor: .center)
                .offset(y: -100)
            }
        }
        .frame(maxHeight: .infinity)
    }
    
    private func updateSelectedCoin(coin: Coin) {
        selectedCoin = coin
        
        guard let selectedCoin = selectedCoin,
              let amount = selectedCoin.currentHoldings else {
            return
        }
        
        quantityText = "\(amount)"
    }

    private func saveButtonTapped() {
        
        guard let selectedCoin = selectedCoin,
              let amount = Double(quantityText)
        else { return }
        
        disableInput = true
        
        // Hide keyboard.
        UIApplication.shared.endEditing()
        
        if editMode {
            portfolioViewModel.updatePortfolio(coin: selectedCoin, amount: amount)
        } else {
            portfolioViewModel.addPortfolio(coin: selectedCoin, amount: amount)
        }
        
        // Show SAVE and remove portfolioInputSection.
        withAnimation(.easeOut(duration: 0.5)) {
            removeSelectedCoin()
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            showCheckmark = true
        }
    }
    
    private func removeSelectedCoin() {
        
        selectedCoin = nil
        portfolioViewModel.searchText = ""
        quantityText = ""
    }
}

#Preview {
    PortfolioDetailView(updateCoin: nil)
        .environmentObject(HomeViewModel())
        .environmentObject(PortfolioViewModel())
}
