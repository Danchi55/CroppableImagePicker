//
//  Crop.swift
//  PhotoEditor
//
//  Created by Daymein Gregorio on 9/9/25.
//

import SwiftUI

// MARK: Crop Config

public enum Crop: Equatable, Hashable {
  case circle
  case portrait
  case square
  case custom(CGRect)

  var name: String {
    switch self {
    case .custom(let cgSize):
      "Custom \(Int(cgSize.width))x\(Int(cgSize.height))"
    default:
      String(describing: self).capitalized
    }
  }

  func size() -> CGSize {
    switch self {
    case .circle:
      .init(width: 300, height: 300)
    case .portrait:
      .init(width: 300, height: 500)
    case .square:
      .init(width: 300, height: 300)
    case .custom(let cgSize):
        .init(width: cgSize.width, height: cgSize.height)
    }
  }

  public func hash(into hasher: inout Hasher) {
    hasher.combine(self.name)
  }

}
