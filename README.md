# SwiftUI-MediaPickup

SwiftUI tools to pickup photos and videos from iOS media library.

Reference: [Bringing Photos picker to your SwiftUI app](https://developer.apple.com/documentation/photokit/bringing_photos_picker_to_your_swiftui_app)


## Install

### Requirement
Only iOS16+ is supported.


### Swift Package Manager
Add the package as a dependency in `Package.swift`
```swift
dependencies: [
  .package(
    url: "https://github.com/ysohma/swiftui-media-pickup",
    from: "0.1.0"
  ),
]
```
Then add MediaPickup as a dependency of your target.

```swift
.executableTarget(
    name: "YourApp",
    dependencies: [
      .product(name: "MediaPickup", package: "swiftui-media-pickup"),
    ]
  )

```
## Usage


### Photo
Use `PhotoPickupButton`

```swift
import MediaPickup

struct PhotoPickup: View{
    @State private var image: UIImage? = nil
    
    var body: some View{
        PhotoPickupButton(pickedImage: $image){ status in
            /// Label content
            /// You can switch label depending on loading status.
            switch status {
                case .loading(_):
                    ProgressView()
                default:
                    Image(systemName: "plus")
            }
        }
    }
}
```

### Video
Use `VideoPickupButton`

```swift
struct VideoPickup: View{
    @State private var asset: AVAsset? = nil
    
    var body: some View{
        VideoPickupButton(pickedVideo: $asset){ status in
            /// Label content
            /// You can switch view depending on loading status.
            switch status {
                case .loading(_):
                    ProgressView()
                default:
                    Image(systemName: "plus")
            }
        }
    }
}
```

## Example App
See `MediaPickupDemo`
