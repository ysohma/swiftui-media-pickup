//
//  PhotoPickupButton.swift
//  MediaPickup
//
//  Created by Yoshio Soma on 2023/04/16.
//

import Foundation
import AVFoundation
import UIKit
import SwiftUI
import PhotosUI

private class ImagePickModel: ObservableObject{
    ///
    private struct ImageData: Transferable {
        let image: UIImage
        static var transferRepresentation: some  TransferRepresentation{
            DataRepresentation(importedContentType: .image){ data in
                guard let uiImage = UIImage(data: data) else{
                    throw TransferError.importFailed
                }
                return ImageData(image: uiImage)
            }
        }
    }
    
    @Published private(set) var loadState: LoadingState<UIImage> = .empty
    
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
    
    private func loadTransferable(from imageSelection: PhotosPickerItem) -> Progress {
        return imageSelection.loadTransferable(type: ImageData.self) { result in
            DispatchQueue.main.async {
                guard imageSelection == self.selection else {
                    print("Failed to get the selected item.")
                    return
                }
                switch result {
                case .success(let profile?):
                    self.loadState = .success(profile.image)
                case .failure(let error):
                    self.loadState = .failure(error)
                default:
                    self.loadState = .empty
                }
            }
        }
    }
}




public struct PhotoPickupButton<Label: View>: View{
    @StateObject private var model = ImagePickModel()
    @Binding private var image:UIImage?
    
    let label: (LoadingState<UIImage>) -> Label
    
    public init(pickedImage image: Binding<UIImage?>, @ViewBuilder label: @escaping (LoadingState<UIImage>) -> Label) {
        self.label = label
        self._image = image
    }
    
    public var body: some View{
        PhotosPicker(selection: $model.selection,matching: .images,photoLibrary: .shared()) {
            label(model.loadState)
        }.onChange(of: model.loadState){ newState in
            switch newState{
                case .success(let image):
                    self.image = image
                    break
                default:
                    self.image = nil
                    break
            }
        }
    }
}
