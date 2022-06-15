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
  internal static let accentColor = ColorAsset(name: "AccentColor")
  internal static let carbon = ColorAsset(name: "Carbon")
  internal static let alkaliMetals = ColorAsset(name: "alkaliMetals")
  internal static let alkalineEarthMetals = ColorAsset(name: "alkalineEarthMetals ")
  internal static let boron = ColorAsset(name: "boron")
  internal static let bromine = ColorAsset(name: "bromine")
  internal static let chlorine = ColorAsset(name: "chlorine")
  internal static let fluorine = ColorAsset(name: "fluorine")
  internal static let hydrogen = ColorAsset(name: "hydrogen")
  internal static let iodine = ColorAsset(name: "iodine")
  internal static let iron = ColorAsset(name: "iron")
  internal static let nitrogen = ColorAsset(name: "nitrogen")
  internal static let nobleGases = ColorAsset(name: "nobleGases")
  internal static let otherElements = ColorAsset(name: "otherElements")
  internal static let oxygen = ColorAsset(name: "oxygen")
  internal static let phosphorus = ColorAsset(name: "phosphorus ")
  internal static let sulfur = ColorAsset(name: "sulfur")
  internal static let titanium = ColorAsset(name: "titanium")
  internal static let buttonsColor = ColorAsset(name: "buttonsColor")
  internal static let darkBlueAndWhiteHalfTransparent = ColorAsset(name: "darkBlueAndWhiteHalfTransparent")
  internal static let grayTransparent = ColorAsset(name: "grayTransparent")
  internal static let navigationBarColor = ColorAsset(name: "navigationBarColor")
  internal static let primaryBackground = ColorAsset(name: "primaryBackground")
  internal static let primaryHalfTransparent = ColorAsset(name: "primaryHalfTransparent")
  internal static let redFailure = ColorAsset(name: "redFailure")
  internal static let redFailureTransparent = ColorAsset(name: "redFailureTransparent")
  internal static let textColor = ColorAsset(name: "textColor")
  internal static let textColorHalfTransparent = ColorAsset(name: "textColorHalfTransparent")
  internal static let titleTextColor = ColorAsset(name: "titleTextColor")
  internal static let failedCircle = ImageAsset(name: "failedCircle")
  internal static let moleculeMutipleColor = ImageAsset(name: "moleculeMutipleColor")
  internal static let moleculePurpleOrange = ImageAsset(name: "moleculePurpleOrange")
  internal static let moleculeRedBlue = ImageAsset(name: "moleculeRedBlue")
  internal static let moleculesRedGray = ImageAsset(name: "moleculesRedGray")
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
