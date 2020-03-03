//
//  TextView.swift
//  CheckInPlus
//
//  Created by Mark Townsend on 2/29/20.
//  Copyright © 2020 Mark Townsend. All rights reserved.
//

import Foundation
import SwiftUI

struct TextView: UIViewRepresentable {

  typealias UIViewType = UITextView

  var configuration = { (view: UIViewType) in }
  var placeholder: String
  @Binding var text: String
  var minHeight: CGFloat
  @Binding var calculatedHeight: CGFloat

  init(placeholder: String, text: Binding<String>, minHeight: CGFloat, calculatedHeight: Binding<CGFloat>) {
    self.placeholder = placeholder
    self._text = text
    self._calculatedHeight = calculatedHeight
    self.minHeight = minHeight
  }

  func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }

  func makeUIView(context: Context) -> UIViewType {
    let textView = UIViewType()
    textView.delegate = context.coordinator
    textView.isScrollEnabled = false
    textView.isEditable = true
    textView.isUserInteractionEnabled = true
    textView.text = placeholder
    textView.textColor = UIColor.tertiaryLabel

    textView.layer.borderColor = UIColor.tertiaryLabel.cgColor
    textView.layer.cornerRadius = 3.0
    textView.layer.masksToBounds = true
    return textView
  }

  func updateUIView(_ uiView: UIViewType, context: Context) {
    if uiView.text != self.text {
      uiView.text = self.text
    }

    recalculateHeight(view: uiView)
  }

  func recalculateHeight(view: UIView) {
    let newSize = view.sizeThatFits(CGSize(width: view.frame.size.width, height: .greatestFiniteMagnitude))
    if minHeight < newSize.height && $calculatedHeight.wrappedValue != newSize.height {
      DispatchQueue.main.async {
        self.$calculatedHeight.wrappedValue = newSize.height
      }
    } else if minHeight >= newSize.height && $calculatedHeight.wrappedValue != minHeight {
      DispatchQueue.main.async {
        self.$calculatedHeight.wrappedValue = self.minHeight
      }
    }
  }

  class Coordinator: NSObject, UITextViewDelegate {
    var parent: TextView

    init(_ uiTextView: TextView) {
      self.parent = uiTextView
    }

    func textViewDidChange(_ textView: UITextView) {
      if textView.markedTextRange == nil {
        parent.text = textView.text ?? String()
        parent.recalculateHeight(view: textView)
      }
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
      if textView.textColor == UIColor.tertiaryLabel {
        textView.text = nil
        textView.textColor = UIColor.label
      }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
      if textView.text.isEmpty {
        textView.text = parent.placeholder
        textView.textColor = UIColor.lightGray
      }
    }
  }
}
