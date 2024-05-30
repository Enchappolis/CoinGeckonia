//
//  XButtonView.swift
//  CoinGeckonia
//
//  Created by Enchappolis on 4/18/24.
//

import SwiftUI

struct XButtonView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        Button {
            presentationMode.wrappedValue.dismiss()
        } label: {
            Image(systemName: "xmark")
        }
    }
}

struct XButtonView_Previews: PreviewProvider {
    static var previews: some View {
        XButtonView()
    }
}
