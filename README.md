#  CroppableImagePicker

CroppableImagePicker is a light-weight tool thats adds image cropping to the Image Picker flow.

## Requirements

- iOS 18+
- Swift Package Manager
- iOS Photo Library access

## Installation

CroppableImagePicker is done through Swift Package Manager.

To install using  [Swift Package Manager](https://github.com/apple/swift-package-manager)  you have a couple of options:

### Option 1: In Xcode

1. Open your project
2. Go to **File -> Add Package Dependencies...**
3. Enter the repository URL: ` https://github.com/Danchi55/CroppableImagePicker.git`
4. Choose the version you want to use
5. Select your target and click **Add Package**

### Option 2: Manual Installation

1. Download or clone the CroppableImagePicker repository
2. Drag the CroppableImagePicker framework/source files into your Xcode project
3. Make sure to add it to your target's dependencies

### Additional Setup:

The CroppableImagePicker library requires Photo Library access. Your app should have Photo Library permissions set up and user must grant `PhotoLibraryStatus` of either `.allowed` or `.restricted` to use this component.

Refer to [Apple's documentation](https://www.apple.com) for more information on how to set up Photo Library permissions.

## Implementation

In the view where you'd like to show the picker:

1. Import the library

`import CroppableImagePicker`

2. Set state properties to handle showing the picker and the result image

```swift
@State private var showingCroppableImagePicker: Bool = false
@State private var croppedImage: Image?
```

3. Add cropImagePicker to your body property

```swift
var body: some View {
  NavigationStack {
    VStack {
      // ...your code
    }
    .cropImagePicker(
      title: "Crop View",
      options: [.circle, .square],
      show: $showingCroppableImagePicker,
      croppedImage: $croppedImage
    )
  }
}
```

4. Add some method to trigger the picker to show

```swift
// ...your body code
Button {
  showingCroppableImagePicker = true
} label: {
  Text("Show image picker")
}
```



## Function Details

The only function you need is:

```swift 
func cropImagePicker(
  title: String,
  options: [Crop],
  show: Binding<Bool>,
  croppedImage: Binding<Image?>
) -> some View
```

### Parameters

- **title** - Title to be displayed in the CropView.
- **options** - Cropping options available to the user.
- **show** - Determines if the Picker is shown.
- **croppedImage** - Property when the cropped image is stored

### Crop

There are 4 cropping options:

- **circle** (300 x 300)
- **portrait** (300 x 500)
- **square** (300 x 300)
- **custom** (up to you)

The custom option has a parameter of type `CGSize` to allow you to set a size of your choice.

> ☝️ **Important**
> If only one cropping option is assigned, the user will go directly from the Photo Library to the Crop View. If 2 or more options are provided, the user will see a Confirmation Dialog allowing them to choose which crop style they want to us.

## WCAG 2.1 Compliance

Still early, but working on it

## Data Collection

CroppableImagePicker does not collect any data. It does require access to the Photo Library for it to function. This notice is provided to help you complete [App Privacy Details](https://developer.apple.com/app-store/app-privacy-details/).

## ToDos

- [ ] Add images and gifs to ReadMe
- [ ] Unit tests
- [ ] WCAG 2.1 compliance

## Note

Because of the lack of WCAG compliance, I don't recommend using any version under `1.0.0`

