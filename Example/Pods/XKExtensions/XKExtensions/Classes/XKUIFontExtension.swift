//
//  UIFontExtension.swift
//  PhysicalExamination
//
//  Created by Nicholas on 2020/11/21.
//

import Foundation

public enum XKPingFangSCWeight: String {
    /// 中黑体
    case medium     = "PingFangSC-Medium"
    /// 中粗体
    case semibold   = "PingFangSC-Semibold"
    /// 细体
    case light      = "PingFangSC-Light"
    /// 极细体
    case ultralight = "PingFangSC-Ultralight"
    /// 常规体
    case regular    = "PingFangSC-Regular"
    /// 纤细体
    case thin       = "PingFangSC-Thin"
}

public extension UIFont {

    static func xk_pingFangSC(size: CGFloat, name: XKPingFangSCWeight = .regular) -> UIFont {

        return UIFont(name: name.rawValue, size: size) ?? UIFont.systemFont(ofSize: size)
    }

    static func xk_DINAlternateBold(size: CGFloat) -> UIFont {

        return UIFont(name: "DINAlternate-Bold", size: size) ?? UIFont.systemFont(ofSize: size)
    }

}
