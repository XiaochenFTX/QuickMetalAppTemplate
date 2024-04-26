//
//  QuickMetalView.swift
//  QuickMetalAppTemplate
//
//  Created by 王晓辰 on 2024/4/26.
//

import SwiftUI
import MetalKit


struct QuickMetalView: View {
    var body: some View {
        QuickMetalComponent()
            .ignoresSafeArea()
    }
}

struct QuickMetalComponent: UIViewRepresentable {

    func makeUIView(context: Context) -> MTKView {
        print("[QuickMetalComponent::makeUIView]")
        
        let view = MTKView()
        view.device = context.coordinator.device
        view.delegate = context.coordinator
        return view
    }
    
    func updateUIView(_ view: MTKView, context: Context) {
        print("[QuickMetalComponent::updateUIView]")
    }
    
    func makeCoordinator() -> QuickMetalRenderer {
        QuickMetalRenderer()
    }

}

#Preview {
    QuickMetalView()
}
