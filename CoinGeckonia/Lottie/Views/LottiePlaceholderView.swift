//
//  LottiePlaceholderView.swift
//  CoinGeckonia
//
//  Created by Enchappolis on 5/17/24.
//

import SwiftUI
import Lottie

struct LottiePlaceholderView: View {
    
    var fileName = "checkmark"
    var contentMode: UIView.ContentMode = .scaleAspectFit
    var playLoopMode: LottieLoopMode = .playOnce
    var onAnimationDidFinish: (() -> Void)?
    
    var body: some View {
        
        LottieView(animation: .named(fileName))
            .configure({ lottieAnimationView in
                lottieAnimationView.contentMode = contentMode
            })
            .playing(.toProgress(1, loopMode: playLoopMode))
            .animationSpeed(0.6)
            .animationDidFinish { completed in
                onAnimationDidFinish?()
            }
    }
}

#Preview {
    LottiePlaceholderView()
}
