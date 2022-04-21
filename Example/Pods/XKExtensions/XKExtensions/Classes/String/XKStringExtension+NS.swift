//
//  XKStringExtension+NS.swift
//  XKCategorySwift
//
//  Created by kenneth on 2021/12/8.
//

import Foundation

public extension NSString {

    @objc func xk_appendSpace(_ length: Int) -> NSString {
        return (self as String).xk_appendSpace(length) as NSString
    }

    @objc func xk_appendHalfSpace(_ length: Int) -> NSString {
        return (self as String).xk_appendHalfSpace(length) as NSString
    }
}

 public extension NSMutableAttributedString {

    // MARK: 字符串拼接
   func xk_append(text: String, color: UIColor? = nil, font: UIFont? = nil, spacing: CGFloat? = nil) {
        var attributes = [NSAttributedString.Key: Any]()
        if let color = color {
            attributes[.foregroundColor] = color
        }
        if let font = font {
            attributes[.font] = font
        }
        if let spacing = spacing {

            let style                   = NSMutableParagraphStyle()
            style.lineSpacing           = spacing
            attributes[.paragraphStyle] = style
        }
        let attributedText = NSAttributedString(string: text, attributes: attributes)
        append(attributedText)
    }

    // MARK: 突出显示某部分
    func xk_highlighted(type: NSTextCheckingResult.CheckingType, color: UIColor) {

        guard let regular = XKRegularType.regular(type: .link) else {
            return
        }

        guard let expression = try? NSRegularExpression(pattern: regular, options: .caseInsensitive) else {
            return
        }

        let matches = expression.matches(in: string, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSRange(location: 0, length: length))

        switch type {
        case .link:
            highlightedLink(color: color, matches: matches)
        default:
            break
        }
    }

   func highlightedLink(color: UIColor, matches: [NSTextCheckingResult]) {

        for match in matches {

            let text = (string as NSString).substring(with: match.range)

            if let url = URL(string: text) {
                addAttribute(.link, value: url, range: match.range)
                addAttribute(.foregroundColor, value: color, range: match.range)
            }
        }
    }

    // MARK: 更新style
    func xk_setStyle(spacing: CGFloat = 4.0, alignment: NSTextAlignment = .left) {

        let style         = NSMutableParagraphStyle()
        style.lineSpacing = spacing
        style.alignment   = alignment
        addAttribute(.paragraphStyle, value: style, range: NSRange(location: 0, length: length))
    }

}

 public extension NSAttributedString {

   func height(forWidth width: CGFloat) -> CGFloat {

        let rect = boundingRect(with: CGSize(width: width, height: CGFloat(HUGE)), options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil)

        return rect.size.height
    }
}
