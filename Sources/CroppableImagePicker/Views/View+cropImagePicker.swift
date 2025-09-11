//
//  View+.swift
//  PhotoEditor_PoC
//
//  Created by Daymein Gregorio on 9/10/25.
//

import SwiftUI

public extension View {
  
  /// Adds CroppableImagePicker to current view.
  /// - Parameters:
  ///   - title: Title to be displayed in the CropView.
  ///   - options: Cropping options.
  ///   - show: Binding Bool to determine if the picker is shown.
  ///   - croppedImage: Binding optional UIImage that has been cropped.
  /// - Returns: CroppableImagePicker
  /// - Note: Content is `self` to allow PSPhotosPicker to overlay existing view.
  func cropImagePicker(
    title: String,
    options: [Crop],
    show: Binding<Bool>,
    croppedImage: Binding<Image?>
  ) -> some View {
    CroppableImagePicker(
      title: title,
      options: options,
      show: show,
      croppedImage: croppedImage,
      content: { self }
    )
  }

}

