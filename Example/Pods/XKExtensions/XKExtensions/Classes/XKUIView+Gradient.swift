//
//  XKUIView+Gradient.swift
//  XKGradientSwift
//
//  Created by kenneth on 2022/3/10.
//

import Foundation
import UIKit

public class XKGradientLayer: CAGradientLayer {}

fileprivate extension UIView {
    func fetchCornerRadiusLayer() -> CALayer? {
        return layer.sublayers?.first(where: { sublayer in
            return sublayer.isKind(of: XKGradientLayer.self)
        })
    }
}

public extension UIView {

    func addGradient(startPoint: CGPoint, endPoint: CGPoint, colors: [UIColor]) {
        if let sublayer = fetchCornerRadiusLayer() {
            sublayer.removeFromSuperlayer()
        }
        let gradientLayer = XKGradientLayer()
        gradientLayer.frame      = bounds
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint   = endPoint
        gradientLayer.colors     = colors.map({ color in
            return color.cgColor
        })
        layer.addSublayer(gradientLayer)
    }
}
