// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(macOS)
  import AppKit
#elseif os(iOS)
  import UIKit
#elseif os(tvOS) || os(watchOS)
  import UIKit
#endif

// Deprecated typealiases
@available(*, deprecated, renamed: "ColorAsset.Color", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias AssetColorTypeAlias = ColorAsset.Color
@available(*, deprecated, renamed: "ImageAsset.Image", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias AssetImageTypeAlias = ImageAsset.Image

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Asset Catalogs

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
internal enum Asset {
  internal enum Colors {
    internal static let disabledAuthorizationButtonBackground = ColorAsset(name: "Colors/disabledAuthorizationButtonBackground")
    internal static let disabledAuthorizationButtonText = ColorAsset(name: "Colors/disabledAuthorizationButtonText")
    internal static let enabledAuthorizationButtonBorderLine = ColorAsset(name: "Colors/enabledAuthorizationButtonBorderLine")
    internal static let enabledAuthorizationButtonText = ColorAsset(name: "Colors/enabledAuthorizationButtonText")
    internal static let loginPlaceholderTextColor = ColorAsset(name: "Colors/loginPlaceholderTextColor")
    internal static let loginTextColor = ColorAsset(name: "Colors/loginTextColor")
    internal static let textFieldBoarderColor = ColorAsset(name: "Colors/textFieldBoarderColor")
    internal static let loginFailedText = ColorAsset(name: "Colors/loginFailedText")
    internal static let registrationQuestionLabelText = ColorAsset(name: "Colors/registrationQuestionLabelText")
    internal static let activeBackground = ColorAsset(name: "Colors/activeBackground")
    internal static let deepBlue = ColorAsset(name: "Colors/deepBlue")
    internal static let grayTextHalfTranparent = ColorAsset(name: "Colors/grayTextHalfTranparent")
    internal static let grayTransperent = ColorAsset(name: "Colors/grayTransperent")
    internal static let navigationBarBackground = ColorAsset(name: "Colors/navigationBarBackground")
    internal static let navigationBarTextColor = ColorAsset(name: "Colors/navigationBarTextColor")
    internal static let primaryBackground = ColorAsset(name: "Colors/primaryBackground")
    internal static let tabBarBackground = ColorAsset(name: "Colors/tabBarBackground")
    internal static let textColor = ColorAsset(name: "Colors/textColor")
  }
  internal static let collectionViewImage = ImageAsset(name: "collectionViewImage")
  internal static let searchIcon = ImageAsset(name: "searchIcon")
  internal static let tabelViewImage = ImageAsset(name: "tabelViewImage")
  internal static let agonaLogo = ImageAsset(name: "AgonaLogo")
  internal static let watchLater = ImageAsset(name: "WatchLater")
  internal static let eye = ImageAsset(name: "eye")
  internal static let collectionActive = ImageAsset(name: "CollectionActive")
  internal static let collectionInactive = ImageAsset(name: "CollectionInactive")
  internal static let watchLaterLogoFull = ImageAsset(name: "WatchLaterLogoFull")
  internal static let logoShort = ImageAsset(name: "logoShort")
  internal static let noImage = ImageAsset(name: "noImage")
  internal static let searchIconGray = ImageAsset(name: "searchIconGray")
}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name

// MARK: - Implementation Details

internal final class ColorAsset {
  internal fileprivate(set) var name: String

  #if os(macOS)
  internal typealias Color = NSColor
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  internal typealias Color = UIColor
  #endif

  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  internal private(set) lazy var color: Color = {
    guard let color = Color(asset: self) else {
      fatalError("Unable to load color asset named \(name).")
    }
    return color
  }()

  #if os(iOS) || os(tvOS)
  @available(iOS 11.0, tvOS 11.0, *)
  internal func color(compatibleWith traitCollection: UITraitCollection) -> Color {
    let bundle = BundleToken.bundle
    guard let color = Color(named: name, in: bundle, compatibleWith: traitCollection) else {
      fatalError("Unable to load color asset named \(name).")
    }
    return color
  }
  #endif

  fileprivate init(name: String) {
    self.name = name
  }
}

internal extension ColorAsset.Color {
  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  convenience init?(asset: ColorAsset) {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSColor.Name(asset.name), bundle: bundle)
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

internal struct ImageAsset {
  internal fileprivate(set) var name: String

  #if os(macOS)
  internal typealias Image = NSImage
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  internal typealias Image = UIImage
  #endif

  @available(iOS 8.0, tvOS 9.0, watchOS 2.0, macOS 10.7, *)
  internal var image: Image {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    let image = Image(named: name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    let name = NSImage.Name(self.name)
    let image = (bundle == .main) ? NSImage(named: name) : bundle.image(forResource: name)
    #elseif os(watchOS)
    let image = Image(named: name)
    #endif
    guard let result = image else {
      fatalError("Unable to load image asset named \(name).")
    }
    return result
  }

  #if os(iOS) || os(tvOS)
  @available(iOS 8.0, tvOS 9.0, *)
  internal func image(compatibleWith traitCollection: UITraitCollection) -> Image {
    let bundle = BundleToken.bundle
    guard let result = Image(named: name, in: bundle, compatibleWith: traitCollection) else {
      fatalError("Unable to load image asset named \(name).")
    }
    return result
  }
  #endif
}

internal extension ImageAsset.Image {
  @available(iOS 8.0, tvOS 9.0, watchOS 2.0, *)
  @available(macOS, deprecated,
    message: "This initializer is unsafe on macOS, please use the ImageAsset.image property")
  convenience init?(asset: ImageAsset) {
    #if os(iOS) || os(tvOS)
    let bundle = BundleToken.bundle
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSImage.Name(asset.name))
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
