//
//  Untitled.swift
//  Jagu
//
//  Created by Artur Hellmann on 29.06.25.
//

import SwiftUI

private struct TextEditorVerticalInsetKey: EnvironmentKey {
    static let defaultValue: CGFloat = 4
}

private struct TextEditorHorizontalInsetKey: EnvironmentKey {
    static let defaultValue: CGFloat = 6
}

extension EnvironmentValues {
    var textEditorVerticalInset: CGFloat {
        get { self[TextEditorVerticalInsetKey.self] }
        set { self[TextEditorVerticalInsetKey.self] = newValue }
    }

    var textEditorHorizontalInset: CGFloat {
        get { self[TextEditorHorizontalInsetKey.self] }
        set { self[TextEditorHorizontalInsetKey.self] = newValue }
    }
}

extension View {
    func verticalInset(_ value: CGFloat) -> some View {
        environment(\.textEditorVerticalInset, value)
    }

    func horizontalInset(_ value: CGFloat) -> some View {
        environment(\.textEditorHorizontalInset, value)
    }
}

struct InsetTextEditor: NSViewRepresentable {   // für macOS
    typealias NSViewType = NSScrollView

    class Coordinator: NSObject, NSTextViewDelegate {
        var parent: InsetTextEditor

        init(_ parent: InsetTextEditor) {
            self.parent = parent
        }

        func textDidChange(_ notification: Notification) {
            guard let tv = notification.object as? NSTextView else { return }
            parent.text = tv.string
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    @Binding var text: String
    @Environment(\.textEditorVerticalInset) private var verticalInset
    @Environment(\.textEditorHorizontalInset) private var horizontalInset

    func makeNSView(context: Context) -> NSScrollView {
        let textView = NSTextView()
        textView.isVerticallyResizable = true
        textView.isHorizontallyResizable = false
        textView.textContainerInset = NSSize(width: horizontalInset, height: verticalInset)
        textView.autoresizingMask = [.width]
        textView.delegate = context.coordinator
        if let container = textView.textContainer {
            container.widthTracksTextView = true
            container.heightTracksTextView = false
            container.containerSize = NSSize(
                width: CGFloat.greatestFiniteMagnitude,
                height: CGFloat.greatestFiniteMagnitude
            )
        }

        let scrollView = NSScrollView()
        scrollView.hasVerticalScroller = true
        scrollView.hasHorizontalScroller = false
        scrollView.autohidesScrollers = true
        scrollView.documentView = textView

        return scrollView
    }

    func updateNSView(_ scrollView: NSScrollView, context: Context) {
        guard let textView = scrollView.documentView as? NSTextView else { return }
        if textView.string != text {
            textView.string = text
        }
        textView.textContainerInset = NSSize(width: horizontalInset, height: verticalInset)
    }
}
