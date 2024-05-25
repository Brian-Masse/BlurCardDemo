//
//  ContentView.swift
//  BlurCardDemo
//
//  Created by Brian Masse on 5/25/24.
//

import SwiftUI

struct ContentView: View {
//    MARK: Body
    var body: some View {
        VStack {
            HStack { Spacer() }
            
            Spacer()
        
            Card()
            
            Spacer()
            
        }.background(Color(red: 0.3, green: 0.3, blue: 0.3))
    }
}

#Preview {
    ContentView()
}
