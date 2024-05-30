//
//  CoinGeckoniaApp.swift
//  CoinGeckonia
//
//  Created by Enchappolis on 5/14/24.
//

import SwiftUI

@main
struct CoinGeckoniaApp: App {
    
    @StateObject private var homeViewModel = HomeViewModel()
    @StateObject private var portfolioViewModel = PortfolioViewModel()

    @State private var showLaunchView = true

    init() {
        
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(.theme.accent)]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(.theme.accent)]
    }

    var body: some Scene {
        WindowGroup {
            
            let isUnitTest = NSClassFromString("XCTestCase") != nil
            
            if isUnitTest {
                Text("Unit Test")
            } else {
                showApp
            }
        }
    }
    
    private var showApp: some View {
        
        ZStack {
            
            NavigationStack{
                HomeView()
                    .navigationTitle("Live Values")
                    .onAppear {
                        self.portfolioViewModel.homeViewModel = homeViewModel
                    }
            }
            .environmentObject(homeViewModel)
            .environmentObject(portfolioViewModel)
            
            ZStack {
                if showLaunchView {
                    LaunchView(showLaunchView: $showLaunchView)
                }
            }
            .zIndex(2.0)
        }
    }
}
