//
//  QuickMetalRenderer.swift
//  QuickMetalAppTemplate
//
//  Created by 王晓辰 on 2024/4/26.
//

import MetalKit
import simd

@MainActor final class QuickMetalRenderer: NSObject, MTKViewDelegate {
    
    let device: any MTLDevice
    private let queue: any MTLCommandQueue
    
    private let renderPipeline: any MTLRenderPipelineState

    private let vertexPositionsBuffer: any MTLBuffer
    private let vertexColorsBuffer: any MTLBuffer
    
    //
    private let positions: [SIMD3<Float>] =
    [
        [ -0.8,  0.8, 0.0 ],
        [  0.0, -0.8, 0.0 ],
        [ +0.8,  0.8, 0.0 ]
    ]
    
    private let colors: [SIMD3<Float>] =
    [
        [ 1.0, 0.3, 0.2 ],
        [ 0.8, 1.0, 0.0 ],
        [ 0.8, 0.0, 1.0 ]
    ]
    
    override init() {
        
        self.device = MTLCreateSystemDefaultDevice()!
        self.queue = device.makeCommandQueue()!
        
        let library = device.makeDefaultLibrary()!
        
        let vertexFunc = library.makeFunction(name: "vertexMain")
        let fragmentFunc = library.makeFunction(name: "fragmentMain")
        
        let renderDescriptor = MTLRenderPipelineDescriptor()
        renderDescriptor.label = "pipeline.render"
        renderDescriptor.vertexFunction = vertexFunc
        renderDescriptor.fragmentFunction = fragmentFunc
        renderDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        self.renderPipeline = try! device.makeRenderPipelineState(descriptor: renderDescriptor)
        
        let samplePositionBuffer = device.makeBuffer(bytes: self.positions, length: self.positions.count * MemoryLayout<SIMD3<Float>>.stride, options: .cpuCacheModeWriteCombined)!
        self.vertexPositionsBuffer = samplePositionBuffer

        let sampleColorBuffer = device.makeBuffer(bytes: self.colors, length: self.colors.count * MemoryLayout<SIMD3<Float>>.stride, options: .cpuCacheModeWriteCombined)!
        self.vertexColorsBuffer = sampleColorBuffer
        
    }
    
    nonisolated func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        
    }
    
    nonisolated func draw(in view: MTKView) {
        MainActor.assumeIsolated {
            
            let commandBuffer = self.queue.makeCommandBuffer()!
            commandBuffer.label = "QuickMetal Pass"
            
            let drawable = view.currentDrawable!
            let renderPassDescriptor = view.currentRenderPassDescriptor!
            
            let renderCommandEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor)!
            
            renderCommandEncoder.setRenderPipelineState(self.renderPipeline)
            renderCommandEncoder.setFrontFacing(.counterClockwise)
            renderCommandEncoder.setCullMode(.back)
            
            renderCommandEncoder.setVertexBuffer(self.vertexPositionsBuffer, offset: 0, index: 0)
            renderCommandEncoder.setVertexBuffer(self.vertexColorsBuffer, offset: 0, index: 1)
            renderCommandEncoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: 3)
            
            renderCommandEncoder.endEncoding()
            commandBuffer.present(drawable)
            
            commandBuffer.commit()
        }
    }
}
