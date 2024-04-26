//
//  ContentView.swift
//  QuickMetalAppTemplate
//
//  Created by 王晓辰 on 2024/4/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            
            QuickMetalView()
            
            VStack {
                Spacer()
                HStack {
                    Button("Hello, world!") {
                        print("HELLO Quick Metal App Template ...")
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
