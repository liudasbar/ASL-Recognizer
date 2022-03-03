// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {

  internal enum AVCaptureFailure {
    /// Could not add video data output to capture session.
    /// 
    /// Please restart your device.
    internal static let couldNotAddVideoDataOutputToSession = L10n.tr("Localizable", "AVCaptureFailure.couldNotAddVideoDataOutputToSession")
    /// Could not add video device input to capture session.
    /// 
    /// Please restart your device.
    internal static let couldNotAddVideoDeviceInputToSession = L10n.tr("Localizable", "AVCaptureFailure.couldNotAddVideoDeviceInputToSession")
    /// Could not create video device input.
    /// 
    /// Please restart your device.
    internal static let couldNotCreateVideoDeviceInput = L10n.tr("Localizable", "AVCaptureFailure.couldNotCreateVideoDeviceInput")
    /// Failed to lock video capture for configuration.
    /// 
    /// Please restart your device.
    internal static let failedVideoCaptureLockForConfiguration = L10n.tr("Localizable", "AVCaptureFailure.failedVideoCaptureLockForConfiguration")
    /// No camera device found.
    /// 
    /// Please ensure your device camera is working correctly.
    internal static let noCameraDeviceFound = L10n.tr("Localizable", "AVCaptureFailure.noCameraDeviceFound")
    /// No camera preview layer available.
    /// 
    /// Please restart your device.
    internal static let noPreviewLayerAvailable = L10n.tr("Localizable", "AVCaptureFailure.noPreviewLayerAvailable")
  }

  internal enum Alert {
    /// Error
    internal static let generic = L10n.tr("Localizable", "Alert.generic")
    /// Error with reason: %@
    internal static func genericWithError(_ p1: Any) -> String {
      return L10n.tr("Localizable", "Alert.genericWithError", String(describing: p1))
    }
    /// No hand pose detected
    internal static let noHandPoseDetected = L10n.tr("Localizable", "Alert.noHandPoseDetected")
  }

  internal enum Common {
    /// -
    internal static let dash = L10n.tr("Localizable", "Common.dash")
    /// No
    internal static let no = L10n.tr("Localizable", "Common.no")
    /// NA
    internal static let notAvailable = L10n.tr("Localizable", "Common.notAvailable")
    /// Yes
    internal static let yes = L10n.tr("Localizable", "Common.yes")
    internal enum Button {
      /// Back
      internal static let back = L10n.tr("Localizable", "Common.Button.back")
      /// Cancel
      internal static let cancel = L10n.tr("Localizable", "Common.Button.cancel")
      /// Close
      internal static let close = L10n.tr("Localizable", "Common.Button.close")
      /// Confirm
      internal static let confirm = L10n.tr("Localizable", "Common.Button.confirm")
      /// Continue
      internal static let `continue` = L10n.tr("Localizable", "Common.Button.continue")
      /// Help
      internal static let help = L10n.tr("Localizable", "Common.Button.help")
      /// Next
      internal static let next = L10n.tr("Localizable", "Common.Button.next")
      /// Okay
      internal static let okay = L10n.tr("Localizable", "Common.Button.okay")
      /// Reset
      internal static let reset = L10n.tr("Localizable", "Common.Button.reset")
      /// Start
      internal static let start = L10n.tr("Localizable", "Common.Button.start")
    }
  }

  internal enum HandPoses {
    /// Alphabet hand poses
    internal static let title = L10n.tr("Localizable", "HandPoses.title")
  }

  internal enum Main {
    /// Developed by Liudas Baronas.
    /// Source code is available on GitHub.
    /// Application version: %@ (%@)
    internal static func info(_ p1: Any, _ p2: Any) -> String {
      return L10n.tr("Localizable", "Main.info", String(describing: p1), String(describing: p2))
    }
    internal enum Button {
      /// Detecting
      internal static let detecting = L10n.tr("Localizable", "Main.Button.detecting")
      /// Alphabet
      internal static let handPoses = L10n.tr("Localizable", "Main.Button.handPoses")
      /// Detect
      internal static let startDetection = L10n.tr("Localizable", "Main.Button.startDetection")
      internal enum Settings {
        /// Open Settings
        internal static let `open` = L10n.tr("Localizable", "Main.Button.Settings.open")
      }
    }
    internal enum Status {
      internal enum CameraStatus {
        /// Checking camera status...
        internal static let checking = L10n.tr("Localizable", "Main.Status.CameraStatus.checking")
        /// Camera access is not allowed
        internal static let notAllowed = L10n.tr("Localizable", "Main.Status.CameraStatus.notAllowed")
        /// Please grant camera access for ASL signs recognition
        internal static let shouldRequest = L10n.tr("Localizable", "Main.Status.CameraStatus.shouldRequest")
        /// Camera is not available
        internal static let unknownFailure = L10n.tr("Localizable", "Main.Status.CameraStatus.unknownFailure")
      }
    }
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: nil, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
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
