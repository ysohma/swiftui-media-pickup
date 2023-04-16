//
//  Common.swift
//  MediaPcikupDemo
//
//  Created by Yoshio Soma on 2023/04/16.
//

import SwiftUI

/// Display when contents has not been loaded.
struct UnknownIcon: View {
  var body: some View {
    Image(systemName: "questionmark")
      .resizable()
      .scaledToFit()
      .frame(width: 64, height: 64)
      .foregroundColor(.gray)
  }
}
