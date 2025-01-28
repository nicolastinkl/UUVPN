//
//  View+Extensions.swift
//  LoginKit
//
//  Created by Balaji on 04/08/23.
//

import SwiftUI

/// Custom SwiftUI View Extensions
extension View {
    /// View Alignments
    @ViewBuilder
    func hSpacing(_ alignment: Alignment = .center) -> some View {
        self
            .frame(maxWidth: .infinity, alignment: alignment)
    }
    
    @ViewBuilder
    func vSpacing(_ alignment: Alignment = .center) -> some View {
        self
            .frame(maxHeight: .infinity, alignment: alignment)
    }
    
    /// Disable With Opacity
    @ViewBuilder
    func disableWithOpacity(_ condition: Bool) -> some View {
        self
            .disabled(condition)
            .opacity(condition ? 0.5 : 1)
    }
}


// Extedning View to get Screen Size and Frame....
extension View{
    
    func getRect()->CGRect{
        UIScreen.main.bounds
    }
    
    func getSafeArea()->UIEdgeInsets{
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else{
            return .zero
        }
        
        guard let safeArea = screen.windows.first?.safeAreaInsets else{
            return .zero
        }
        
        return safeArea
    }
}


extension Text {
  init(_ attributedString: NSAttributedString) {
    self.init("") // initial, empty Text

    // scan the attributed string for distinctly attributed regions
    attributedString.enumerateAttributes(in: NSRange(location: 0, length: attributedString.length),
                                         options: []) { (attrs, range, _) in
      let string = attributedString.attributedSubstring(from: range).string
      var text = Text(string)

      // then, read applicable attributes and apply them to the Text

      if let font = attrs[.font] as? UIFont {
        // this takes care of the majority of formatting - text size, font family,
        // font weight, if it's italic, etc.
        text = text.font(.init(font))
      }

      if let color = attrs[.foregroundColor] as? UIColor {
        text = text.foregroundColor(Color(color))
      }

      if let kern = attrs[.kern] as? CGFloat {
        text = text.kerning(kern)
      }

      if #available(iOS 14.0, *) {
        if let tracking = attrs[.tracking] as? CGFloat {
          text = text.tracking(tracking)
        }
      }

      if let strikethroughStyle = attrs[.strikethroughStyle] as? NSNumber,
         strikethroughStyle != 0 {
        if let strikethroughColor = (attrs[.strikethroughColor] as? UIColor) {
          text = text.strikethrough(true, color: Color(strikethroughColor))
        } else {
          text = text.strikethrough(true)
        }
      }

      if let underlineStyle = attrs[.underlineStyle] as? NSNumber,
         underlineStyle != 0 {
        if let underlineColor = (attrs[.underlineColor] as? UIColor) {
          text = text.underline(true, color: Color(underlineColor))
        } else {
          text = text.underline(true)
        }
      }

      if let baselineOffset = attrs[.baselineOffset] as? NSNumber {
        text = text.baselineOffset(CGFloat(baselineOffset.floatValue))
      }

      // append the newly styled subtext to the rest of the text
      self = self + text
    }
  }
}


extension Text {
  init(html htmlString: String, // the HTML-formatted string
       raw: Bool = false, // set to true if you don't want to embed in the doc skeleton
       size: CGFloat? = nil, // optional document-wide text size
       fontFamily: String = "-apple-system") { // optional document-wide font family
    let fullHTML: String
    if raw {
      fullHTML = htmlString
    } else {
      var sizeCss = ""
       if let size = size {
         sizeCss = "font-size: \(size)px;"
       }
       fullHTML = """
        <!doctype html>
         <html>
            <head>
              <style>
                body {
                  font-family: \(fontFamily);
                  \(sizeCss)
                }
              </style>
            </head>
            <body>
              \(htmlString)
            </body>
          </html>
        """
    }
    let attributedString: NSAttributedString
    if let data = fullHTML.data(using: .unicode),
       let attrString = try? NSAttributedString(data: data,
                                                options: [.documentType: NSAttributedString.DocumentType.html],
                                                documentAttributes: nil) {
      attributedString = attrString
    } else {
      attributedString = NSAttributedString()
    }

    self.init(attributedString) // uses the NSAttributedString initializer
  }
}
 

 

public extension View {
    // 扩展 View 以提供隐藏键盘的功能
      func hideKeyboard() {
          UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
      }
    func transparentScrolling() -> some View {
        if #available(iOS 16.0, *) {
            return scrollContentBackground(.hidden)
        } else {
            return onAppear {
                UITextView.appearance().backgroundColor = .clear
            }
        }
    }
}

struct TriangleShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

