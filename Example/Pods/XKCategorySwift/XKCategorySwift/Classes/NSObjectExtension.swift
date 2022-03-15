//
//  NSObjectExtension.swift
//  Health
//
//  Created by Nicholas on 2020/4/19.
//  Copyright © 2020 Nicholas. All rights reserved.
//

// swiftlint:disable identifier_name
import Foundation

public extension NSObject {

    /// 获取类名
    static var xk_className: String {
        return String(describing: self)
    }

    var xk_className: String {
        return String(describing: self.classForCoder)
   }

}
