//
//  LoadingState.swift
//  MediaPickup
//
//  Created by Yoshio Soma on 2023/04/16.
//

import Foundation

public enum LoadingState<Content>: Equatable {
  case empty
  case loading(Progress)
  case success(Content)
  case failure(Error)

  static public func == (lhs: LoadingState, rhs: LoadingState) -> Bool {
    switch (lhs, rhs) {
    case (.empty, .empty):
      return true
    case (.loading(_), .loading(_)):
      return true
    case (.success(_), .success(_)):
      return true
    case (.failure(_), .failure(_)):
      return true
    default:
      return false
    }
  }
}
