//
//  CustomImagePicker.swift
//  PhotoEditor_PoC
//
//  Created by Daymein Gregorio on 9/9/25.
//

import SwiftUI
import PhotosUI

struct CroppableImagePicker<Content: View>: View {

  /// Title of the crop view.
  private let title: String

  /// Available cropping options.
  private let options: [Crop]

  /// Determines whether the Crop View is shown.
  @Binding var show: Bool

  /// Optional crop image. Set when crop is complete
  @Binding var croppedImage: Image?

  /// Parent view.
  private let content: Content

  @State private var photoItems: PhotosPickerItem?
  @State private var selectedImage: Image?
  @State private var showDialog: Bool = false
  @State private var selectedCrop: Crop = .circle
  @State private var showCropView: Bool = false

  var body: some View {
    content
      .photosPicker(
        isPresented: $show,
        selection: $photoItems,
        matching: .images
      )
      .onChange(of: photoItems) { _, item in
        setImage(from: item)
      }
      .onChange(of: selectedImage) { _, newImage in
        guard newImage != nil else { return }
        showNextView()
      }
      .confirmationDialog("Image Crop Style", isPresented: $showDialog) {
        ForEach(options, id: \.self) { option in
          Button(option.name) {
            selectedCrop = option
            showCropView = true
          }
        }
      }
      .fullScreenCover(
        isPresented: $showCropView,
        onDismiss: { selectedImage = nil },
        content: cropView
      )
      .onAppear { selectedCrop = options.first! }
  }
  
  /// Initializes this Photo Picker wrapper that manages the Crop View.
  /// - Parameters:
  ///   - title: Title to be shown on the Crop View.
  ///   - options: Available cropping options.
  ///   - show: Binding that determines if the Crop View is shown.
  ///   - croppedImage: Binding of optional UIImage of cropped image.
  ///   - content: Parent of this view.
  init(
    title: String,
    options: [Crop] = [.circle],
    show: Binding<Bool>,
    croppedImage: Binding<Image?>,
    @ViewBuilder content: @escaping () -> Content
  ) {
    self.title = title
    self.options = options.count > 1 ? options : [.circle]
    self._show = show
    self._croppedImage = croppedImage
    self.content = content()
  }

  private func cropView() -> some View {
    CropView(
      title: title,
      crop: selectedCrop,
      image: selectedImage
    ) { croppedImage, success in
      if let croppedImage {
        self.croppedImage = croppedImage
      }
    }
  }

}

// MARK: Private functions

private extension CroppableImagePicker {

  @MainActor
  func setImage(from item: PhotosPickerItem?) {
    Task {
      guard let item,
            let imageData = try? await item.loadTransferable(type: Data.self),
            let uiImage = UIImage(data: imageData)
      else { return }
      selectedImage = Image(uiImage: uiImage)
    }
  }

  func showNextView() {
    if options.count == 1 {
      selectedCrop = options.first!
      showCropView = true
    } else {
      showDialog = true
    }
  }

}


