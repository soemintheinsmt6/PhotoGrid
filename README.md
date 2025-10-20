## PhotoGrid (iOS)

A lightweight iOS app that displays a grid of photos with a details screen. Built with UIKit and MVVM, featuring a clean separation of concerns, lightweight networking, and unit/UI tests.

### Features
- **Photo list**: Paginated grid with placeholder images and loading indicators
- **Photo details**: Fullscreen viewer with metadata
- **MVVM**: `PhotoListViewModel` powers the list UI
- **Networking**: `PhotoService` for API requests and parsing into `PhotoModel`
- **Environments**: `Dev.xcconfig` and `Prod.xcconfig` for build-time configuration
- **Tests**: Unit tests (`PhotoGridTests`) and UI tests (`PhotoGridUITests`)

### Requirements
- **Xcode**: 15+ (recommended)
- **iOS Deployment Target**: iOS 15+
- **Swift**: 5.9+

### Getting Started
1. Clone the repository
2. Open `PhotoGrid.xcodeproj` in Xcode
3. Select a scheme:
   - `PhotoGrid` (Production)
   - `PhotoGrid(Dev)` (Development)
4. Build and run on Simulator or a device

### Project Structure
- `PhotoGrid/`
  - `AppDelegate.swift`, `SceneDelegate.swift`
  - `Environment/`
    - `Environment.swift`, `Dev.xcconfig`, `Prod.xcconfig`
  - `Model/`
    - `PhotoModel.swift`
  - `Networking/`
    - `PhotoService.swift`
  - `View/`
    - `PhotoList/` (`PhotoListViewController`, `.xib`)
    - `PhotoDetails/` (`PhotoDetailsViewController`, `.xib`)
  - `ViewModel/`
    - `PhotoListViewModel.swift`
  - `Cells/`
    - `PhotoCell/`, `IndicatorCell/`
  - `Utils/`
    - `Extensions/` (`UIImage-Extension.swift`, `UIImageView-Extension.swift`, `UIViewController-Extension.swift`)
  - `Assets.xcassets/`, `Base.lproj/`, `Info.plist`

### Environments & Configuration
This project uses build configurations via `.xcconfig` files located in `PhotoGrid/Environment/`:
- `Dev.xcconfig` for development
- `Prod.xcconfig` for production

Provide environment values (e.g., API base URL) in these files and read them via `Environment.swift` at runtime.

Example keys (add as needed in the `.xcconfig` files):
```
API_BASE_URL = https://example.com/api
IMAGE_CDN_URL = https://images.example.com
```

Access them in code through `Environment` helpers.

### Running Tests
- Unit Tests: `PhotoGridTests`
- UI Tests: `PhotoGridUITests`

From Xcode:
- Select the `PhotoGrid` workspace, press Command+U to run all tests

From CLI (optional):
```bash
xcodebuild -project PhotoGrid.xcodeproj -scheme "PhotoGrid" -destination 'platform=iOS Simulator,name=iPhone 15' test
```

### Architecture Notes
- **MVVM**: View controllers are kept lean; view models contain transformation and data-loading logic
- **Networking**: `PhotoService` abstracts request creation and decoding into strongly-typed `PhotoModel`
- **UI**: NIB-backed cells (`PhotoCell`, `IndicatorCell`) and view controllers with corresponding `.xib` files
- **Extensions**: UIKit helpers in `Utils/Extensions` for image loading, caching, and view controller utilities

### Assets & Placeholders
`Assets.xcassets/placeholder.imageset` includes placeholder images used while photos load.

### Troubleshooting
- If images do not load, verify your `API_BASE_URL` and any network entitlements if testing on device
- Clean build folder (Shift+Command+K) and re-run if Xcode reports stale NIBs or assets
- Ensure the correct scheme is selected (`PhotoGrid` vs `PhotoGrid(Dev)`) when testing environment-specific behavior

### License
This project is provided as-is for educational purposes. Update with your preferred license if distributing.


