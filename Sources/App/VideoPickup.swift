//
//  VideoPickup.swift
//  MediaPickupDemo
//
//  Created by Yoshio Soma on 2023/04/16.
//

import SwiftUI
import AVFoundation
import MediaPickup

private struct VideoThumbnail: View{
    struct FramePositionSlider: View{
        @Binding var pos: CMTime
    
        let duration: CMTime
        
        @State private var p: Double = .zero
        
        let step: Double = 0.1
        
        var body: some View{
            VStack(alignment: .trailing){
                Slider(value: $p, in: 0...1.0)
                    .onChange(of: p){ newValue in
                        pos = CMTimeMakeWithSeconds(duration.seconds*newValue, preferredTimescale: duration.timescale)
                    }
                Text("\(pos.seconds, specifier: "%.1f")/\(duration.seconds, specifier: "%.1f")")
            }
        }
    }

    
    let asset: AVAsset
    private let imageGenerator: AVAssetImageGenerator
    
    //@State private var frameImage: UIImage? = nil
    @State private var duration: CMTime? = nil
    @State private var time: CMTime = .zero
    
    @Binding private var frameImage: UIImage?
    
    
    internal init(asset: AVAsset, image: Binding<UIImage?>) {
        self.asset = asset
        self.imageGenerator = AVAssetImageGenerator(asset: asset)
        self.imageGenerator.requestedTimeToleranceBefore = CMTime(value: 1, timescale: 30)
        self.imageGenerator.requestedTimeToleranceAfter = CMTime(value: 1, timescale: 30)
        self._frameImage = image
    }
    
    private func updateFrame(at: CMTime){
        var actualTime: CMTime = .zero
        if let cgImage = try? self.imageGenerator.copyCGImage(at: at, actualTime: &actualTime){
            frameImage = UIImage(cgImage: cgImage)
        }
    }

    var body: some View{
        ZStack{
            if let duration{
                /// フレーム位置選択スライダー
                FramePositionSlider(pos: $time, duration: duration)
                    .onChange(of: time){ newTime in
                        updateFrame(at: newTime)
                    }
            }else{
                ProgressView("Loading")
            }
        }.task {
            do{
                let duration = try await asset.load(.duration)
                self.duration = duration
                self.updateFrame(at: time)
            }catch{
                /// Error
            }
        }
    }
}


struct VideoFramePickup: View{
    
    @State private var asset: AVAsset? = nil
    
    @State private var frameImage: UIImage? = nil
    
    var body: some View{
        NavigationView{
            ZStack{
                if let asset {
                    VStack{
                        if let frameImage{
                            Image(uiImage: frameImage)
                                .resizable()
                                .scaledToFit()
                        }else{
                            Image(systemName: "questionmark.circle")
                                .resizable()
                                .scaledToFit()
                        }
                        VideoThumbnail(asset: asset, image: $frameImage)
                            .padding()
                    }
                }else{
                    UnknownIcon()
                }
            }
            .navigationTitle("Video Pickup")
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing){
                    VideoPickupButton(pickedVideo: $asset){ status in
                        switch status {
                        case .empty:
                            Image(systemName: "plus")
                        case .loading(_):
                            ProgressView()
                        case .success(_):
                            Image(systemName: "plus")
                        case .failure(_):
                            Image(systemName: "exclamationmark")
                        }
                    }
                }
            }
        }
    }
}
