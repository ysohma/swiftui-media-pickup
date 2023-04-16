//
//  VideoPickupButton.swift
//  MediaPickup
//
//  Created by Yoshio Soma on 2023/04/16.
//

import Foundation
import AVFoundation
import UIKit
import SwiftUI
import PhotosUI


private class VideoPickModel: ObservableObject{
    struct ProfileVideo: Transferable {
        let asset: AVAsset
        static var transferRepresentation: some TransferRepresentation {
            FileRepresentation(importedContentType: .movie){
                let asset = AVAsset(url: $0.file)
                /// !!!
                let _ = asset.isPlayable
                return Self.init(asset: asset)
            }
        }
    }
    
    @Published private(set) var loadState: LoadingState<AVAsset> = .empty
    
    @Published var selection: PhotosPickerItem? = nil {
        didSet {
            if let selection {
                let progress = loadTransferable(from: selection)
                loadState = .loading(progress)
            } else {
                loadState = .empty
            }
        }
    }
    
    private func loadTransferable(from videoSelection: PhotosPickerItem) -> Progress {
        return videoSelection.loadTransferable(type: ProfileVideo.self) { result in
            DispatchQueue.main.async {
                guard videoSelection == self.selection else {
                    print("Failed to get the selected item.")
                    return
                }
                switch result {
                case .success(let profile?):
                    self.loadState = .success(profile.asset)
                case .failure(let error):
                    self.loadState = .failure(error)
                default:
                    self.loadState = .empty
                }
            }
        }
    }
}


/// 一枚の写真を取得する
public struct VideoPickupButton<Label: View>: View{
    @StateObject private var model = VideoPickModel()
    @Binding private var asset:AVAsset?
    
    let label: (LoadingState<AVAsset>) -> Label
    
    public init(pickedVideo asset: Binding<AVAsset?>, @ViewBuilder label: @escaping (LoadingState<AVAsset>) -> Label) {
        self.label = label
        self._asset = asset
    }
    
    public var body: some View{
        PhotosPicker(selection: $model.selection,matching: .videos,photoLibrary: .shared()) {
            label(model.loadState)
        }.onChange(of: model.loadState){ newState in
            switch newState{
                case .success(let asset):
                    self.asset = asset
                default:
                    self.asset = nil
            }
        }
    }
}

