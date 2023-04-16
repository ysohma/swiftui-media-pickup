//
//  UIImage+.swift
//  MediaPickup
//
//  Created by Yoshio Soma on 2023/04/16.
//

import Foundation
import UIKit

extension UIImage {
  convenience init?(contentsOf url: URL) {
    guard let data = try? Data(contentsOf: url) else {
      return nil
    }
    self.init(data: data)
  }
}
