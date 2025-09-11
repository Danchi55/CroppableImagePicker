//
//  CropView.swift
//  PhotoEditor_PoC
//
//  Created by Daymein Gregorio on 9/10/25.
//

import SwiftUI

struct CropView: View {

  @Environment(\.dismiss) private var dismiss

  let title: String
  let crop: Crop
  let image: Image?
  let onCrop: (Image?, Bool) -> Void

  // Gesture properties

  @State private var scale: CGFloat = 1
  @State private var lastScale: CGFloat = 0
  @State private var offset: CGSize = .zero
  @State private var lastOffset: CGSize = .zero

  /// Is `true` if interaction is in progress.
  @GestureState private var interacting: Bool = false

  var body: some View {
    NavigationStack {
      imageView()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
          Color.black
            .ignoresSafeArea()
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackgroundVisibility(.visible, for: .navigationBar)
        .toolbarBackground(Color.black, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbar {
          ToolbarItem(placement: .topBarLeading) {
            Button(action: cancelCropTapped) {
              Image(systemName: "xmark")
                .font(.callout)
                .fontWeight(.semibold)
                .accessibilityLabel("Cancel")
            }
          }
          ToolbarItem(placement: .topBarTrailing) {
            Button(action: acceptCropTapped) {
              Image(systemName: "checkmark")
                .font(.callout)
                .fontWeight(.semibold)
                .accessibilityLabel("Accept crop")
            }
          }
        }
    }
  }

  private func imageView(hideGrid: Bool = false) -> some View {
    let cropSize = crop.size()
    let coordinateSpaceName: String = "crop_view"

    return GeometryReader {
      let size = $0.size

      if let image {
        image
          .resizable()
          .aspectRatio(contentMode: .fill)
          .overlay {
            GeometryReader { proxy in
              let rect = proxy.frame(in: .named(coordinateSpaceName))
              Color.clear
                .onChange(of: interacting) { _, isDragging in
                  withAnimation(.easeInOut(duration: 0.2)) {
                    resetOffset(rect, size: size)
                  }
                  if !isDragging {
                    // store last offset so next drag starts at the same point
                    lastOffset = offset
                  }
                }
            }
          }
          .frame(size)
      }
    }
    .scaleEffect(scale)
    .offset(offset)
    .overlay {
      if !hideGrid {
        grids()
      }
    }
    .coordinateSpace(name: coordinateSpaceName)
    .gesture(
      DragGesture()
        .updating($interacting, body: { _, out, _ in
          out = true
        })
        .onChanged { value in
          updateOffset(dragValue: value)
        }
    )
    .gesture(
      MagnifyGesture()
        .updating($interacting, body: { _, out, _ in
          out = true
        })
        .onChanged { value in
          updateScaleValue(magValue: value)
        }
        .onEnded { value in
          withAnimation(.easeInOut) {
            setScaleValues()
          }
        }
    )
    .frame(cropSize)
    .cornerRadius(crop == .circle ? cropSize.height / 2 : 0)
  }

  private func grids() -> some View {
    ZStack {
      HStack {
        ForEach(1...5, id: \.self) { _ in
          Rectangle()
            .fill(.white.opacity(0.7))
            .frame(width: 1)
            .frame(maxWidth: .infinity)
        }
      }
      VStack {
        ForEach(1...5, id: \.self) { _ in
          Rectangle()
            .fill(.white.opacity(0.7))
            .frame(height: 1)
            .frame(maxHeight: .infinity)
        }
      }
    }
  }

}

private extension CropView {

  func cancelCropTapped() {
    dismiss()
  }

  func acceptCropTapped() {
    setImageCrop()
    dismiss()
  }

  /// Generates cropped image and triggers `onCrop` completion.
  func setImageCrop() {
    let renderer = ImageRenderer(content: imageView(hideGrid: true))
    renderer.scale = 10
    renderer.proposedSize = .init(crop.size())
    if let image = renderer.uiImage {
      onCrop(Image(uiImage: image), true)
    } else {
      onCrop(nil, false)
    }
  }

  /// Updates scale with either the Magnify Value or 1, whichever is higher.
  /// - Parameter magValue: Value of magnification.
  func updateScaleValue(magValue: MagnifyGesture.Value) {
    let updatedScale = magValue.magnification + lastScale
    scale = max(updatedScale, 1)
  }
  
  /// Updates the offset based on the Drag Value and last offset.
  /// - Parameter dragValue: Value of the drag gesture.
  func updateOffset(dragValue: DragGesture.Value) {
    let translation = dragValue.translation
    offset = CGSize(
      width: translation.width + lastOffset.width,
      height: translation.height + lastOffset.height
    )
  }

  /// Resets offset if needed ensuring image is within its view.
  /// - Parameters:
  ///   - rect: Frame of image container.
  ///   - size: Size of image.
  func resetOffset(_ rect: CGRect, size: CGSize) {
    if rect.minX > 0 {
      // resetting to last location
      offset.width = offset.width - rect.minX
        haptics(.medium)
    }
    if rect.minY > 0 {
      // resettng to last location
      offset.height = offset.height - rect.minY
      haptics(.medium)
    }

    if rect.maxX < size.width {
      offset.width = rect.minX - offset.width
      haptics(.medium)
    }

    if rect.maxY < size.height {
      offset.height = rect.minY - offset.height
      haptics(.medium)
    }
  }
  
  /// Sets last scale value, and ensures scale is >= 1.
  func setScaleValues() {
    if scale < 1 {
      scale = 1
      lastScale = 0
    } else {
      lastScale = scale - 1
    }
  }

}

#Preview {
  CropView(
    title: "Crop View Preview",
    crop: .portrait,
    image: Image("sample"),
    onCrop: { _, _ in
    })
}
