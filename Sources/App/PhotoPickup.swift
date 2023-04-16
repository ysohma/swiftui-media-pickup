//
//  PhotoPickup.swift
//  MediaPickupDemo
//
//  Created by Yoshio Soma on 2023/04/16.
//

import SwiftUI
import MediaPickup

struct PhotoPickup_: View{
    @State private var image: UIImage? = nil
    
    var body: some View{
        PhotoPickupButton(pickedImage: $image){ status in
            /// Label content
            /// You can switch view depending on loading status.
            switch status {
                case .loading(_):
                    ProgressView()
                default:
                    Image(systemName: "plus")
            }
        }
    }
}

struct VideoPickup_: View{
    @State private var asset: AVAsset? = nil
    
    var body: some View{
        VideoPickupButton(pickedVideo: $asset){ status in
            /// Label content
            /// You can switch view depending on loading status.
            switch status {
                case .loading(_):
                    ProgressView()
                default:
                    Image(systemName: "plus")
            }
        }
    }
}
struct PhotoPickup: View{
    /// Loaded image
    @State private var image: UIImage? = nil
    
    var body: some View{
        NavigationView{
            ZStack{
                if let image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                }else{
                    UnknownIcon()
                }
            }
            .navigationTitle("Photo Pickup")
            .toolbar{
                ToolbarItem(placement: .destructiveAction){
                    PhotoPickupButton(pickedImage: $image){ status in
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

