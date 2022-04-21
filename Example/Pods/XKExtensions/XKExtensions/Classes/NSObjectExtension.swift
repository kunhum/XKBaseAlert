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

    /// 获取模块名
    static var xk_moduleName: String? {
        return NSStringFromClass(self).components(separatedBy: ".").first
    }
    var xk_moduleName: String? {
        return NSStringFromClass(classForCoder).components(separatedBy: ".").first
    }

}
