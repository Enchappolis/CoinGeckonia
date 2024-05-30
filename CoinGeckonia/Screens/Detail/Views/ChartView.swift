//
//  ChartView.swift
//  CoinGeckonia
//
//  Created by Enchappolis on 5/28/24.
//

import SwiftUI
import Charts

struct ChartView: View {
    
    let data: [Double]
    
    private let startingDate: Date
    private let endingDate: Date
    
    init(coin: Coin) {
        self.data = coin.sparklineIn7D?.price ?? []
        
        endingDate = Date(coinGeckoString: coin.lastUpdated ?? "")
        startingDate = Calendar.current.date(byAdding: .day, value: -7, to: endingDate) ?? endingDate
        
    }
    
    var body: some View {
        
        VStack {
            
            Chart(0..<data.count, id: \.self) { index in
                LineMark(x: .value("x", index),
                         y: .value("y", data[index]))
                .foregroundStyle(lineColor())
                .lineStyle(StrokeStyle(lineWidth: 3))
                .shadow(color: lineColor(), radius: 10, x: 0.0, y: 10)
                .shadow(color: lineColor().opacity(0.5), radius: 10, x: 0.0, y: 20)
                .shadow(color: lineColor().opacity(0.2), radius: 10, x: 0.0, y: 30)
                .shadow(color: lineColor().opacity(0.1), radius: 10, x: 0.0, y: 40)
            }
            .frame(height: 150)
            .chartXAxis(.hidden)
            .chartYScale(
                domain: subtractTenPercentOf(value: data.min())...addTenPercentTo(value: data.max()),
                range: .plotDimension(startPadding: 0, endPadding: 0)
            )
            
            chartDateLabels
                .padding(.horizontal, 4)
        }
        .font(.caption)
        .foregroundColor(Color.theme.secondaryText)
    }
    
    private func lineColor() -> Color {
        
        let priceChange = (data.last ?? 0) - (data.first ?? 0)
        return priceChange > 0 ? Color.theme.green : Color.theme.red
    }
    
    private var chartDateLabels: some View {
        HStack {
            Text(startingDate.asShortDateString())
            Spacer()
            Text(endingDate.asShortDateString())
        }
    }
    
    private func addTenPercentTo(value: Double?) -> Double {
        
        guard let value else { return 0.0 }

        let tenPercent = value * 0.1
        
        return value + tenPercent
    }
    
    private func subtractTenPercentOf(value: Double?) -> Double {
        
        guard let value else { return 0.0 }

        let tenPercent = value * 0.1
        
        return value - tenPercent
    }
}

#Preview {
    ChartView(coin: Coin.exampleData())
}
