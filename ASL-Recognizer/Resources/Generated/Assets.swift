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
  internal enum HandPoses {
    internal static let letterA = ImageAsset(name: "Hand-Poses/letter-a")
    internal static let letterB = ImageAsset(name: "Hand-Poses/letter-b")
    internal static let letterC = ImageAsset(name: "Hand-Poses/letter-c")
    internal static let letterD = ImageAsset(name: "Hand-Poses/letter-d")
    internal static let letterE = ImageAsset(name: "Hand-Poses/letter-e")
    internal static let letterF = ImageAsset(name: "Hand-Poses/letter-f")
    internal static let letterG = ImageAsset(name: "Hand-Poses/letter-g")
    internal static let letterH = ImageAsset(name: "Hand-Poses/letter-h")
    internal static let letterI = ImageAsset(name: "Hand-Poses/letter-i")
    internal static let letterJ = ImageAsset(name: "Hand-Poses/letter-j")
    internal static let letterK = ImageAsset(name: "Hand-Poses/letter-k")
    internal static let letterL = ImageAsset(name: "Hand-Poses/letter-l")
    internal static let letterM = ImageAsset(name: "Hand-Poses/letter-m")
    internal static let letterN = ImageAsset(name: "Hand-Poses/letter-n")
    internal static let letterO = ImageAsset(name: "Hand-Poses/letter-o")
    internal static let letterP = ImageAsset(name: "Hand-Poses/letter-p")
    internal static let letterQ = ImageAsset(name: "Hand-Poses/letter-q")
    internal static let letterR = ImageAsset(name: "Hand-Poses/letter-r")
    internal static let letterS = ImageAsset(name: "Hand-Poses/letter-s")
    internal static let letterT = ImageAsset(name: "Hand-Poses/letter-t")
    internal static let letterU = ImageAsset(name: "Hand-Poses/letter-u")
    internal static let letterV = ImageAsset(name: "Hand-Poses/letter-v")
    internal static let letterW = ImageAsset(name: "Hand-Poses/letter-w")
    internal static let letterX = ImageAsset(name: "Hand-Poses/letter-x")
    internal static let letterY = ImageAsset(name: "Hand-Poses/letter-y")
    internal static let letterZ = ImageAsset(name: "Hand-Poses/letter-z")
  }
  internal static let hello = ImageAsset(name: "hello")
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
