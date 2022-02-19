import SwiftUI

public struct PreviewContainer: UIViewRepresentable {
    private let view: UIView

    public init(_ view: UIView) {
        self.view = view
    }

    public func makeUIView(context: Context) -> UIView {
        view
    }

    public func updateUIView(_ view: UIView, context: Context) {

    }
}
