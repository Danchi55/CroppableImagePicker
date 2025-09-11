//
//  View+.swift
//  PhotoEditor_PoC
//
//  Created by Daymein Gregorio on 9/10/25.
//

import SwiftUI

extension View {

  func frame(_ size: CGSize) -> some View {
    self
      .frame(width: size.width, height: size.height)
  }

  // Haptics

  func haptics(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
    UIImpactFeedbackGenerator(style: style).impactOccurred()
  }

}
