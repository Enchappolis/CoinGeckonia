//
//  StatisticView.swift
//  CoinGeckonia
//
//  Created by Enchappolis on 4/16/24.
//

import SwiftUI

struct StatisticView: View {
    
    let statistic: Statistic
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 5) {
            
            Text(statistic.title)
                .font(.caption)
                .foregroundColor(.theme.secondaryText)
            
            Text(statistic.value)
                .font(.headline)
                .foregroundColor(.theme.accent)
            
            HStack(spacing: 5) {
                
                Image(systemName: "triangle.fill")
                    .font(.caption2)
                    .rotationEffect(Angle(degrees:
                                            (statistic.percentageChanged ?? 0) >= 0 ? 0 : 180
                                         ))
                
                Text(statistic.percentageChanged?.asPercentString() ?? "")
                    .font(.caption)
                .bold()
            }
            .foregroundColor((statistic.percentageChanged ?? 0) >= 0 ? .theme.green : .theme.red)
            .opacity(statistic.percentageChanged == nil ? 0.0 : 1.0)
        }
    }
}

struct StatisticView_Previews: PreviewProvider {
    static var previews: some View {
        StatisticView(statistic: Statistic.sampleData[0])
            .previewLayout(.sizeThatFits)
        StatisticView(statistic: Statistic.sampleData[1])
            .previewLayout(.sizeThatFits)
        StatisticView(statistic: Statistic.sampleData[2])
            .previewLayout(.sizeThatFits)
    }
}
