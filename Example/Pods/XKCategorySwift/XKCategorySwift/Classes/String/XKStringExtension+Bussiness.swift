//
//  XKStringExtension+Bussiness.swift
//  XKCategorySwift
//
//  Created by kenneth on 2022/3/3.
//  业务向

import Foundation

public extension String {

    /// 格式化昵称
    var nickName: String {

        let tmpNic = self as NSString

        guard tmpNic.length > 1 else {
            return self
        }
        guard tmpNic.length > 2 else {
            return tmpNic.replacingCharacters(in: NSRange(location: tmpNic.length - 1, length: 1), with: "*") as String
        }

        let prefix = tmpNic.substring(to: 1)
        let suffix = tmpNic.substring(with: NSRange(location: tmpNic.length - 1, length: 1))

        return prefix + "*" + suffix
    }

}
