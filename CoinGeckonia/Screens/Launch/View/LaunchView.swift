//
//  LaunchView.swift
//  CoinGeckonia
//
//  Created by Enchappolis on 4/24/24.
//

import SwiftUI

struct LaunchView: View {
    
    @Binding var showLaunchView: Bool
    
    private let timer = Timer.publish(every: 1.0, on: .main, in: .common).autoconnect()
    
    var body: some View {
        
        ZStack {
            Color.launch.backgound
                .ignoresSafeArea()
            
            Image("Logo")
                .resizable()
                .frame(width: 100, height: 100, alignment: .center)
        }
        .onReceive(timer, perform: { _ in
            withAnimation {
                showLaunchView = false
            }
        })
    }
}

#Preview {
    LaunchView(showLaunchView: .constant(false))
}
