// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(OSX)
  import AppKit.NSImage
  public typealias AssetColorTypeAlias = NSColor
  public typealias AssetImageTypeAlias = NSImage
#elseif os(iOS) || os(tvOS) || os(watchOS)
  import UIKit.UIImage
  public typealias AssetColorTypeAlias = UIColor
  public typealias AssetImageTypeAlias = UIImage
#endif

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Asset Catalogs

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
public enum Assets {
  public static let black = ColorAsset(name: "Black")
  public static let blackThree = ColorAsset(name: "BlackThree")
  public static let buyPageBackground = ColorAsset(name: "BuyPageBackground")
  public static let coolGrey = ColorAsset(name: "CoolGrey")
  public static let greyishBrown = ColorAsset(name: "GreyishBrown")
  public static let title = ColorAsset(name: "Title")
  public static let unactive = ColorAsset(name: "Unactive")
  public static let warmGrey = ColorAsset(name: "WarmGrey")
  public static let winterGreen = ColorAsset(name: "WinterGreen")
  public static let backButton = ImageAsset(name: "BackButton")
  public static let closeButtonIcon = ImageAsset(name: "CloseButtonIcon")
  public static let locked = ImageAsset(name: "Locked")
  public static let pauseBig = ImageAsset(name: "PauseBig")
  public static let play = ImageAsset(name: "Play")
  public static let playBig = ImageAsset(name: "PlayBig")
  public static let playButtonIcon = ImageAsset(name: "PlayButtonIcon")
  public static let checkMark = ImageAsset(name: "checkMark")
  public static let david = ImageAsset(name: "David")
  public static let logo = ImageAsset(name: "Logo")
  public static let titleImage = ImageAsset(name: "TitleImage")
  public static let gradient = ImageAsset(name: "gradient")
  public static let slide1 = ImageAsset(name: "slide1")
  public static let slide2 = ImageAsset(name: "slide2")
  public static let slide3 = ImageAsset(name: "slide3")
  public static let slide4 = ImageAsset(name: "slide4")
  public static let slide5 = ImageAsset(name: "slide5")
  public static let iconBackward = ImageAsset(name: "iconBackward")
  public static let iconBackwardUnactive = ImageAsset(name: "iconBackwardUnactive")
  public static let iconForward = ImageAsset(name: "iconForward")
  public static let iconForwardUnactive = ImageAsset(name: "iconForwardUnactive")
  public static let iconPause = ImageAsset(name: "iconPause")
  public static let iconPlay = ImageAsset(name: "iconPlay")
}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name

// MARK: - Implementation Details

public struct ColorAsset {
  public fileprivate(set) var name: String

  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, OSX 10.13, *)
  public var color: AssetColorTypeAlias {
    return AssetColorTypeAlias(asset: self)
  }
}

public extension AssetColorTypeAlias {
  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, OSX 10.13, *)
  convenience init!(asset: ColorAsset) {
    let bundle = Bundle(for: BundleToken.self)
    #if os(iOS) || os(tvOS)
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(OSX)
    self.init(named: NSColor.Name(asset.name), bundle: bundle)
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

public struct DataAsset {
  public fileprivate(set) var name: String

  #if os(iOS) || os(tvOS) || os(OSX)
  @available(iOS 9.0, tvOS 9.0, OSX 10.11, *)
  public var data: NSDataAsset {
    return NSDataAsset(asset: self)
  }
  #endif
}

#if os(iOS) || os(tvOS) || os(OSX)
@available(iOS 9.0, tvOS 9.0, OSX 10.11, *)
public extension NSDataAsset {
  convenience init!(asset: DataAsset) {
    let bundle = Bundle(for: BundleToken.self)
    #if os(iOS) || os(tvOS)
    self.init(name: asset.name, bundle: bundle)
    #elseif os(OSX)
    self.init(name: NSDataAsset.Name(asset.name), bundle: bundle)
    #endif
  }
}
#endif

public struct ImageAsset {
  public fileprivate(set) var name: String

  public var image: AssetImageTypeAlias {
    let bundle = Bundle(for: BundleToken.self)
    #if os(iOS) || os(tvOS)
    let image = AssetImageTypeAlias(named: name, in: bundle, compatibleWith: nil)
    #elseif os(OSX)
    let image = bundle.image(forResource: NSImage.Name(name))
    #elseif os(watchOS)
    let image = AssetImageTypeAlias(named: name)
    #endif
    guard let result = image else { fatalError("Unable to load image named \(name).") }
    return result
  }
}

public extension AssetImageTypeAlias {
  @available(iOS 1.0, tvOS 1.0, watchOS 1.0, *)
  @available(OSX, deprecated,
    message: "This initializer is unsafe on macOS, please use the ImageAsset.image property")
  convenience init!(asset: ImageAsset) {
    #if os(iOS) || os(tvOS)
    let bundle = Bundle(for: BundleToken.self)
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(OSX)
    self.init(named: NSImage.Name(asset.name))
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

private final class BundleToken {}
