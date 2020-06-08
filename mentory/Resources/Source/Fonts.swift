// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(OSX)
  import AppKit.NSFont
  public typealias Font = NSFont
#elseif os(iOS) || os(tvOS) || os(watchOS)
  import UIKit.UIFont
  public typealias Font = UIFont
#endif

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Fonts

// swiftlint:disable identifier_name line_length type_body_length
public enum Fonts {

  // MARK: - System font
  public enum SFUIDisplay {
    public static let ultraLight = SystemFontConvertible(weight: .ultraLight)
    public static let thin = SystemFontConvertible(weight: .thin)
    public static let light = SystemFontConvertible(weight: .light)
    public static let regular = SystemFontConvertible(weight: .regular)
    public static let medium = SystemFontConvertible(weight: .medium)
    public static let semibold = SystemFontConvertible(weight: .semibold)
    public static let bold = SystemFontConvertible(weight: .bold)
    public static let heavy = SystemFontConvertible(weight: .heavy)
    public static let black = SystemFontConvertible(weight: .black)
  }

  // No fonts found
}
// swiftlint:enable identifier_name line_length type_body_length

// MARK: - Implementation Details

public struct SystemFontConvertible {
  public let weight: UIFont.Weight

  public func font(size: CGFloat) -> Font! {
    return UIFont.systemFont(ofSize: size, weight: weight)
  }
}

