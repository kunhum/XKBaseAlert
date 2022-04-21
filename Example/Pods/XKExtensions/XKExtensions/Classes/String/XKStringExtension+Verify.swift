//
//  XKStringExtension+Verify.swift
//  XKCategorySwift
//
//  Created by kenneth on 2021/12/8.
//

import Foundation

// MARK: - 验证
public extension String {
    // MARK: 是否电话（包含座机和手机）
    func xk_isPhone() -> Bool {
        return xk_isMobileNumber() || xk_isTelphoneNumber()
    }
    /*
     手机号码
     移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188,1705
     联通：130,131,132,152,155,156,185,186,1709
     电信：133,1349,153,180,189,1700
     NSString * MOBILE = "^1((3//d|5[0-35-9]|8[025-9])//d|70[059])\\d{7}$";//总况
     */

    // MARK: 是否为国内服务商
    func xk_isChineseMobile() -> Bool {
        /**
        10         * 中国移动：China Mobile
        11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188，1705
        12         */
        let CM = "^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d|705)\\d{7}$"
        /**
        15         * 中国联通：China Unicom
        16         * 130,131,132,152,155,156,185,186,1709
        17         */
        let CU = "^1((3[0-2]|5[256]|8[56])\\d|709)\\d{7}$"
        /**
        20         * 中国电信：China Telecom
        21         * 133,1349,153,180,189,1700
        22         */
        let CT = "^1((33|53|8[09])\\d|349|700)\\d{7}$"
        /**
        25         * 大陆地区固话及小灵通
        26         * 区号：010,020,021,022,023,024,025,027,028,029
        27         * 号码：七位或八位
        28         */
        let PHS = "^0(10|2[0-5789]|\\d{3})\\d{7,8}$"

        return xk_match(regex: CM) || xk_match(regex: CU) || xk_match(regex: CT) || xk_match(regex: PHS)
    }
    // MARK: 是否有效电话
    func xk_isMobileNumber() -> Bool {
        let mobile = "^(1)\\d{10}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", mobile)
        return predicate.evaluate(with: self)
    }
    // MARK: 验证是否座机
    func xk_isTelphoneNumber() -> Bool {
        let stringNumber  = "^(0\\d{2,3}-?\\d{7,8}$)"
        let predicate     = NSPredicate(format: "SELF MATCHES %@", stringNumber)
        let isPhone       = predicate.evaluate(with: self)
        let stringNumber1 = "^(\\d{7,8}$)"
        let predicate1    = NSPredicate(format: "SELF MATCHES %@", stringNumber1)
        let isPhone1      = predicate1.evaluate(with: self)
        return isPhone || isPhone1
    }
    // MARK: 是否邮箱
    func xk_isEmailAddress() -> Bool {
        return xk_match(regex: "[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}")
    }
    // MARK: 是否mac address
    func xk_isMacAddress() -> Bool {
        return xk_match(regex: "([A-Fa-f\\d]{2}:){5}[A-Fa-f\\d]{2}")
    }
    // MARK: 是否有效URL
    func xk_isValidURL() -> Bool {
        return xk_match(regex: "^((http)|(https))+:[^\\s]+\\.[^\\s]*$")
    }
    // MARK: 是否包含URL
    func xk_isContainsURL() -> Bool {
        let regular = XKRegularType.link.rawValue
        guard let expression = try? NSRegularExpression(pattern: regular, options: .caseInsensitive) else {
            return false
        }
        return expression.matches(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSRange(location: 0, length: count)).count > 0
    }
    // MARK: 是否只是中文
    func xk_justChinese() -> Bool {
        return xk_match(regex: "^[\\u4e00-\\u9fa5]+$")
    }
    // MARK: 是否有效邮政编码
    func xk_isValidPostalCode() -> Bool {
        return xk_match(regex: "^[0-8]\\d{5}(?!\\d)$")
    }
    // MARK: 验证字符串
    func xk_isValid(minLength: Int, maxLength: Int, containChinese: Bool, firstCanNotBeDigtal: Bool) -> Bool {
        let chinese = containChinese ? "\\u4e00-\\u9fa5" : ""
        let first   = firstCanNotBeDigtal ? "^[a-zA-Z_]" : ""
        let regex   = String(format: "%@[%@A-Za-z0-9_]{%d,%d}", first, chinese, minLength, maxLength)
        return xk_match(regex: regex)
    }

    /// 验证字符串
    /// - Parameters:
    ///   - minLength: 最小长度
    ///   - maxLength: 最大长度
    ///   - containChinese: 是否可以包含中文
    ///   - firstCanNotBeDigtal: 首字母是否可以为数字
    ///   - containDigtal: 是否可以有数字
    ///   - needContainLetter: 是否可以包含字母
    /// - Returns: 结果
    func xk_isValid(minLength: Int, maxLength: Int, containChinese: Bool, firstCanNotBeDigtal: Bool, containDigtal: Bool, needContainLetter: Bool) -> Bool {
        let chinese = containChinese ? "\\u4e00-\\u9fa5" : ""
        let first   = firstCanNotBeDigtal ? "^[a-zA-Z_]" : ""
        let lengthRegex = String(format: "(?=^.{%d,%d}$)", minLength, maxLength)
        let digtalRegex = containDigtal ? "(?=(.*\\d.*){1})" : ""
        let letterRegex = needContainLetter ? "(?=(.*[a-zA-Z].*){1})" : ""
        let characterRegex = String(format: "(?:%@[%@A-Za-z0-9]+)", first, chinese)

        let regex = lengthRegex + digtalRegex + letterRegex + characterRegex

        return xk_match(regex: regex)
    }
    // MARK: 是否为ip地址
    func xk_isIPAddress() -> Bool {
        let regex     = "^(\\d{1,3})\\.(\\d{1,3})\\.(\\d{1,3})\\.(\\d{1,3})$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        let result    = predicate.evaluate(with: self)
        if result {
            let componds = components(separatedBy: ",")
            for element in componds {
                if element.xk_toInt() ?? 0 > 255 {
                    return false
                }
            }
            return true
        }
        return false
    }
    // MARK: 是否身份证
    func xk_isIDCard() -> Bool {
        return xk_match(regex: "^(\\d{14}|\\d{17})(\\d|[xX])$")
    }
    // MARK: 精确验证身份证
    func xk_verifyIDCard() -> Bool {

        var value  = xk_trimBlankAndNewLines()
        value      = value.replacingOccurrences(of: " ", with: "")

        let length = value.count
        guard length == 15 || length == 18 else {
            return false
        }
        // 省份
        let areasArray = ["11", "12", "13", "14", "15", "21", "22", "23", "31", "32", "33", "34", "35", "36", "37", "41", "42", "43", "44", "45", "46", "50", "51", "52", "53", "54", "61", "62", "63", "64", "65", "71", "81", "82", "91"]

        let valueStart = value.xk_subTo(index: 1)

        var areaFlag = false
        for areaCode in areasArray {
            if areaCode == valueStart {
                areaFlag = true
                break
            }
        }
        guard areaFlag else {
            return false
        }

        var regularExpression = NSRegularExpression()
        var numberOfMatch = 0

        var year = 0

        if length == 15 {

            year = value.xk_sub(from: 6, to: 7).xk_toInt()! + 1900

            let pattern = year % 4 == 0 || (year % 100 == 0 && year % 4 == 0) ? "^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}$" : "^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}$"

            // 检查出生日期的合法性
            do {
                regularExpression = try NSRegularExpression(pattern: pattern, options: .caseInsensitive)
            } catch {

            }

            numberOfMatch = regularExpression.numberOfMatches(in: value, options: .reportProgress, range: NSRange(location: 0, length: value.count))

            return numberOfMatch > 0

        }
        // length == 18
        year = value.xk_sub(from: 6, to: 9).xk_toInt()!

        let pattern = year % 4 == 0 || (year % 100 == 0 && year % 4 == 0) ? "^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}[0-9Xx]$" : "^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}[0-9Xx]$"

        // 检查出生日期的合法性
        do {
            regularExpression = try NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        } catch {

        }

        numberOfMatch = regularExpression.numberOfMatches(in: value, options: .reportProgress, range: NSRange(location: 0, length: value.count))

        guard numberOfMatch > 0 else {
            return false
        }
        var s = (value.xk_sub(from: 0, to: 0).xk_toInt()! + value.xk_sub(from: 10, to: 10).xk_toInt()!) * 7
        s += (value.xk_sub(from: 1, to: 1).xk_toInt()! + value.xk_sub(from: 11, to: 11).xk_toInt()!) * 9
        s += (value.xk_sub(from: 2, to: 2).xk_toInt()! + value.xk_sub(from: 12, to: 12).xk_toInt()!) * 10
        s += (value.xk_sub(from: 3, to: 3).xk_toInt()! + value.xk_sub(from: 13, to: 13).xk_toInt()!) * 5
        s += (value.xk_sub(from: 4, to: 4).xk_toInt()! + value.xk_sub(from: 14, to: 14).xk_toInt()!) * 8
        s += (value.xk_sub(from: 5, to: 5).xk_toInt()! + value.xk_sub(from: 15, to: 15).xk_toInt()!) * 4
        s += (value.xk_sub(from: 6, to: 6).xk_toInt()! + value.xk_sub(from: 16, to: 16).xk_toInt()!) * 2
        s += value.xk_sub(from: 7, to: 7).xk_toInt()!
        s += value.xk_sub(from: 8, to: 8).xk_toInt()! * 6
        s += value.xk_sub(from: 9, to: 9).xk_toInt()! * 3

        let y   = s % 11
        var m   = "F"
        let jym = "10X98765432"
        m       = jym.xk_sub(from: y, to: y)
        return m == value.xk_sub(from: 17, to: 17)
    }

    // MARK: 检查银行卡是否有效
    func xk_isValidBankCard() -> Bool {

        let cardNumber = replacingOccurrences(of: " ", with: "")

        let lastNum = cardNumber.xk_subFrom(index: count - 2)
//        let forwardNum = cardNumber.xk_subTo(index: count - 3)

        var forwardArr = [String]()
        for element in cardNumber {
            forwardArr.append(String(element))
        }
        var forwardDescArr = [String]()
        for i in 0..<forwardArr.count-1 {
            forwardDescArr.append(forwardArr[(forwardArr.count-2) - i])
        }

        var arrOddNum  = [Int]()
        var arrOddNum2 = [Int]()
        var arrEvenNum = [Int]()

        for (index, element) in forwardDescArr.enumerated() {
            let number = element.xk_toInt()!
            if index % 2 != 0 {
                arrEvenNum.append(number)
            } else {

                if number * 2 < 9 {
                    arrOddNum.append(number * 2)
                } else {
                    let decadeNum = number * 2 / 10
                    let unitNum   = number * 2 % 10
                    arrOddNum2.append(unitNum)
                    arrOddNum2.append(decadeNum)
                }
            }
        }

        var sumOddNumTotal = 0
        for element in arrOddNum {
            sumOddNumTotal += element
        }
        var sumOddNum2Total = 0
        for element in arrOddNum2 {
            sumOddNum2Total += element
        }
        var sumEvenNumTotal = 0
        for element in arrEvenNum {
            sumEvenNumTotal += element
        }
        let lastNumber = lastNum.xk_toInt()!
        let luhmTotal  = lastNumber + sumEvenNumTotal + sumOddNum2Total + sumOddNumTotal

        return luhmTotal % 10 == 0
    }

    // MARK: 检查是否安装某个app
    func appInstalled() -> Bool {
        guard let url = URL(string: self) else { return false }
        return UIApplication.shared.canOpenURL(url)
    }
}
