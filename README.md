#  CroppableImagePicker

CroppableImagePicker is a light-weight tool thats adds image cropping to the Image Picker flow.

## Requirements

- iOS 18+
- Swift Package Manager

## Installation

CroppableImagePicker is done through Swift Package Manager.

To install using  [Swift Package Manager](https://github.com/apple/swift-package-manager)  you can follow the  [tutorial published by Apple](https://developer.apple.com/documentation/xcode/adding_package_dependencies_to_your_app)  using the URL for the Toaster repo with the current version:

1. In Xcode, select “File” → “Add Packages...”
2. Enter  https://github.com/Danchi55/CroppableImagePicker.git

or you can add the following dependency to your `Package.swift`:

```
.package(url: " https://github.com/Danchi55/CroppableImagePicker.git", from: "0.1.0")
```

## Implementation

1. Add Photo Library permissions
2. Add @State object
3. Add modifier
4. Before showing, check photo permissions
5. Show

## WCAG 2.1 Compliance

Still early, but working on it

## Data Collection

CroppableImagePicker does not collect any data. It does require access to the Photo Library for it to function. This notice is provided to help you complete [App Privacy Details](https://developer.apple.com/app-store/app-privacy-details/).

## ToDos

- [ ] Finish this read me
- [ ] Add more inline docs
- [ ] Unit tests
- [ ] WCAG 2.1 compliance

## Note

Because of the lack of WCAG compliance, I don't recommend using any version under `1.0.0`

