//
//  PickupDemo.swift
//  MediaPickupDemo
//
//  Created by Yoshio Soma on 2023/04/16.
//

import SwiftUI

struct PickupDemo: View {
  var body: some View {
    TabView {
      /// Photo
      PhotoPickup()
        .tabItem {
          Label("Photo", systemImage: "photo")
        }
      /// Video
      VideoFramePickup()
        .tabItem {
          Label("Video", systemImage: "video")
        }
    }
  }
}
