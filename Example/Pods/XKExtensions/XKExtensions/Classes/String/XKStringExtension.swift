//
//  String extension_xk.swift
//  Pods
//
//  Created by Nicholas on 2020/5/26.
//

import Foundation
import CommonCrypto

// swiftlint:disable compiler_protocol_init

enum XKRegularType: String {

    case link = "((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)"

    static func regular(type: NSTextCheckingResult.CheckingType) -> String? {
        switch type {
        case .link:
            return XKRegularType.link.rawValue
        default:
            return nil
        }
    }
}

// MARK: - 常用
public extension String {

    func xk_toInt() -> Int? {
        return Int(self)
    }
    func xk_toFloat() -> Float? {
        return Float(self)
    }
    func xk_toDouble() -> Double? {
        return Double(self)
    }
    func xk_toCGFloat() -> CGFloat? {
        guard let float = xk_toFloat() else { return nil }
        return CGFloat(float)
    }

    // MARK: 截取 to index 包括index下的
    func xk_subTo(index: Int) -> String {
        var toIndex = index + 1
        if toIndex < 0 {
            toIndex = 0
        }
        if toIndex > count {
            toIndex = count
        }
        return String(prefix(toIndex))
    }
    // MARK: 截取 from index
    func xk_subFrom(index: Int) -> String {
        var fromIndex = index
        if fromIndex > count {
            fromIndex = count
        }
        fromIndex = count - fromIndex
        return String(suffix(fromIndex))
    }
    // MARK: 从后截取 length：长度
    func xk_suffix(length: Int) -> String {
        var toLength = length
        if toLength < 0 {
            toLength = 0
        }
        if toLength > count {
            toLength = count
        }
        return String(suffix(toLength))
    }
    // MARK: 截取一段
    /// 截取一段
    /// - Parameters:
    ///   - from: 开始截取的下标
    ///   - to: 结束截取的下标
    /// - Returns: 截取结果
    func xk_sub(from: Int, to: Int) -> String {
        var fromIndex = from
        if fromIndex < 0 {
            fromIndex = 0
        }
        if fromIndex > count {
            fromIndex = count
        }
        var toIndex = to
        if toIndex < 0 {
            toIndex = 0
        }
        if toIndex > count {
            toIndex = count
        }
        if toIndex < fromIndex {
            toIndex = fromIndex
        }

        let fromText = xk_subFrom(index: fromIndex)

        let toText   = fromText.xk_subTo(index: toIndex - fromIndex)

        return toText
    }
    // MARK: 去除两端的空白字符
    func xk_trimBlank() -> String {
        return trimmingCharacters(in: CharacterSet.whitespaces)
    }
    // MARK: 去除两端空白和多出的换行
    func xk_trimBlankAndNewLines() -> String {
        return trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    // MARK: 格式化价格
    /// 格式化价格，当以x.00结尾时，显示x。以x.x0结尾时，显示x.x
    /// - Parameters:
    ///   - price: 价格
    ///   - mode: 模式 默认为plain： plain, 四舍五入，down, 只舍不入， up, 只入不舍， bankers 四舍六入, 中间值时, 取最近的,保持保留最后一位为偶数
    /// - Returns: 格式化后的价格
     static func xk_formatterPrice(price: Double, mode: NSDecimalNumber.RoundingMode = .plain) -> String {
        var number    = NSDecimalNumber(floatLiteral: price)
        let handler   = NSDecimalNumberHandler(roundingMode: mode, scale: 2, raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: false)
        number        = number.rounding(accordingToBehavior: handler)
        var priceText = number.stringValue
        if priceText.hasSuffix(".00") {
            priceText = priceText.replacingOccurrences(of: ".00", with: "")
        } else if priceText.hasSuffix(".0") {
            priceText = priceText.xk_subTo(index: priceText.count-2)
        }

        return priceText
    }
    // MARK: 转换为拼音
    func xk_convertToPinyin() -> String {

        let mutableName = NSMutableString(string: self) as CFMutableString

        var range = CFRangeMake(0, count)

        // 汉字转换为拼音,并去除音调
        if !CFStringTransform(mutableName, &range, kCFStringTransformMandarinLatin, false) ||
            !CFStringTransform(mutableName, &range, kCFStringTransformStripDiacritics, false) {
            return ""
        }

        let pinyin = (mutableName as String).replacingOccurrences(of: " ", with: "")

        return pinyin
    }
    // MARK: 获取带声调拼音
    func xk_convertToTonePinyin() -> String {
        let mutableString = NSMutableString(string: self) as CFMutableString
        CFStringTransform(mutableString, nil, kCFStringTransformMandarinLatin, false)
        return mutableString as String
    }
    // MARK: 不带声调拼音，有空格
    func xk_removeTone() -> String {

        let mutableName = NSMutableString(string: self) as CFMutableString
        var range = CFRangeMake(0, count)
        if !CFStringTransform(mutableName, &range, kCFStringTransformMandarinLatin, false) ||
            !CFStringTransform(mutableName, &range, kCFStringTransformStripDiacritics, false) {
            return ""
        }
        return mutableName as String
    }
    // MARK: 拼音首字母，默认大写
    func xk_firstLetterOfPinyin(uppercased: Bool = true) -> String {

        guard count > 0 else {
            return ""
        }

        let mutableName = NSMutableString(string: self) as CFMutableString

        var range = CFRangeMake(0, 1)

        // 汉字转换为拼音,并去除音调
        if !CFStringTransform(mutableName, &range, kCFStringTransformMandarinLatin, false) ||
            !CFStringTransform(mutableName, &range, kCFStringTransformStripDiacritics, false) {
            return ""
        }

        let letter = (mutableName as String).xk_subTo(index: 0)

        return uppercased ? letter.uppercased() : letter
    }
    // MARK: 是否为emoji
    func xk_isEmoji() -> Bool {

        let text         = self as NSString
        let characterset = NSCharacterSet(range: NSRange(location: 0xFE00, length: 16)).inverted
        guard text.rangeOfCharacter(from: characterset).location == NSNotFound else {
            return true
        }

        let high: unichar = text.character(at: 0)
        if 0xD800 < high && high <= 0xDBFF {
            let low: unichar = text.character(at: 1)
            let codePoint = Int(((high - 0xD800) * 0x400) + (low - 0xDC00)) + 0x10000

            return (0x1D000 <= codePoint && codePoint <= 0x1F9FF)
        }

        return (0x2100 <= high && high <= 0x27BF)
    }
    // MARK: 是否包含emoji
    func xk_containEmoji() -> Bool {

        for element in self {

            let text = String(element)

            guard text.xk_isEmoji() == false else {
                return true
            }
        }
        return false
    }
    // MARK: 移除emoji
    func xk_removeEmoji() -> String {

        let text = self as NSString
        var resultText = ""
        text.enumerateSubstrings(in: NSRange(location: 0, length: text.length), options: .byComposedCharacterSequences) { (tmpString, _, _, _) in

            if let subText = tmpString {
                resultText.append(subText.xk_isEmoji() ? "" : subText)
            }
        }
        return resultText
    }
    // MARK: 获取随机字符串
     static func xk_randomText(length: Int) -> String {
        var text = ""
        for _ in 0..<length {
            let number = arc4random() % 10
            text.append(String(format: "%d", number))
        }

        return text
    }
    // MARK: h5转换为attributedText
    func xk_convertH5ToAttributedString(width: CGFloat = UIScreen.main.bounds.width - 20.0) -> NSAttributedString {

        let text = String(format: "<head><style>img{max-width:%fpx;height:auto !important;}</style></head>", width)
        let tmpStr = text + self
        guard let data = tmpStr.data(using: .unicode) else { return NSAttributedString() }
        do {
            let attributedString = try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
            return attributedString
        } catch {

        }

        return NSAttributedString()
    }
    // MARK: 转换H5以适应WKWebView
    func xk_convertH5ToFitWKWebView(width: CGFloat = UIScreen.main.bounds.width - 20.0) -> String {
        let header = String(format: "<header><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'></header><head><style>img{max-width:%fpx !important;}</style></head>", width)
        return header + self
    }
    // MARK: URLEncode
    func xk_urlEncoded() -> String {
        return addingPercentEncoding(withAllowedCharacters: CharacterSet(charactersIn: "!*'\"();:@&=+$,/?%#[]% ").inverted) ?? self
    }
    // MARK: 复制到剪切板
    func xk_copyToPasteboard() {
        let pasteboard = UIPasteboard.general
        pasteboard.string = self
    }
    // MARK: 将字符串转为日期
    func xk_convertToDate(formatter: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formatter
        return dateFormatter.date(from: self)
    }
    // MARK: 正则判断
    func xk_match(regex: String) -> Bool {
        // SELF MATCHES 一定是大写
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: self)
    }
    // MARK: 验证字符串是否符合
    func xk_validateWithCharacterSet(inString: String) -> Bool {

        let characterSet = CharacterSet(charactersIn: inString)
        var i = 0
        while i < count {
            let string = xk_sub(from: i, to: i)
            let range  = string.rangeOfCharacter(from: characterSet)
            if range == nil {
                return false
            }
            i += 1
        }
        return true
    }
    // MARK: 是否包含中文
    func xk_containChinese() -> Bool {

        let text = self as NSString
        for i in 0..<text.length {
            let character = text.character(at: i)
            if character > 0x4e00 && character < 0x9fff {
                return true
            }
        }
        return false
    }
    // MARK: 处理字符串中的中文
    func xk_encodeChinese() -> String {
        let hasChinese = xk_containChinese()
        guard hasChinese else {
            return self
        }
        return self.addingPercentEncoding(withAllowedCharacters: CharacterSet(charactersIn: "`#%^{}\"[]|\\<> ").inverted) ?? self
    }
    // MARK: 打电话
    func xk_phone() {
        DispatchQueue.main.async {

            let phone = "telprompt://" + self
            guard let url = URL(string: phone) else { return }
            guard UIApplication.shared.canOpenURL(url) else { return }
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                // Fallback on earlier versions
                UIApplication.shared.openURL(url)
            }
        }
    }
    // MARK: 判断是否为数字
    func xk_isNumber() -> Bool {
        guard count > 0 else {
            return false
        }
        let filtered = components(separatedBy: CharacterSet(charactersIn: "0123456789.").inverted).joined(separator: "")
        if filtered != self {
            return false
        }

        return true
    }
    // MARK: 筛选字符串
    func xk_fliterNumber() -> String {
        var text = ""
        for element in self {
            let letter = String(element)
            if letter.xk_isNumber() {
                text.append(letter)
            }
        }
        return text
    }

    // MARK: 获取范围
    func xk_range(ofText text: String) -> NSRange {
        return (self as NSString).range(of: text)
    }
    // MARK: 添加占位空格
    func xk_appendSpace(_ length: Int) -> Self {
        guard length > 0 else {
            return self
        }
        var space = ""
        for _ in 0..<length {
            space += "\u{3000}"
        }
        return appending(space)
    }
    // MARK: 添加占位空格 - 半格
    func xk_appendHalfSpace(_ length: Int) -> Self {
        guard length > 0 else {
            return self
        }
        var space = ""
        for _ in 0..<length {
            space += "\u{2000}"
        }
        return appending(space)
    }

}
// MARK: - 加密
public extension String {

    func xk_MD5() -> String {

        let str       = cString(using: String.Encoding.utf8)
        let strLen    = CUnsignedInt(lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result    = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        CC_MD5(str!, strLen, result)
        let hash      = NSMutableString()
        for i in 0 ..< digestLen {
            hash.appendFormat("%02x", result[i])
        }
        result.deinitialize(count: count)

        return String(format: hash as String)
    }
    func xk_base64() -> String? {
        let data = self.data(using: .utf8)
        return data?.base64EncodedString()
    }
     static func xk_decode(base64: String) -> String? {
        guard let data = Data(base64Encoded: base64) else { return nil }
        return String(data: data, encoding: .utf8)
    }
    func xk_SHA1() -> String? {

        guard let data = self.data(using: String.Encoding.utf8) else { return nil }
        var digest  = [UInt8](repeating: 0, count: Int(CC_SHA1_DIGEST_LENGTH))
        let newData = NSData.init(data: data)
        CC_SHA1(newData.bytes, CC_LONG(data.count), &digest)
        let output = NSMutableString(capacity: Int(CC_SHA1_DIGEST_LENGTH))
        for byte in digest {
            output.appendFormat("%02x", byte)
        }
        return output as String
    }
}

 public extension String {

   func height(forFont font: UIFont = UIFont.systemFont(ofSize: 12.0), width: CGFloat, mode: NSLineBreakMode = .byWordWrapping) -> CGFloat {

        let result = size(forFont: font, size: CGSize(width: width, height: CGFloat(HUGE)), mode: mode)

        return result.height
    }

   func width(forFont font: UIFont = UIFont.systemFont(ofSize: 12.0), mode: NSLineBreakMode = .byWordWrapping) -> CGFloat {

        let result = size(forFont: font, size: CGSize(width: CGFloat(HUGE), height: CGFloat(HUGE)), mode: mode)

        return result.width
    }

   func size(forFont font: UIFont = UIFont.systemFont(ofSize: 12.0), size: CGSize = CGSize.zero, mode: NSLineBreakMode = .byWordWrapping) -> CGSize {

        let text = self as NSString

        var result: CGSize

        var attributeds = [NSAttributedString.Key: Any]()

        attributeds[.font] = font

        if mode != .byWordWrapping {
            let style = NSMutableParagraphStyle()
            style.lineBreakMode = mode
            attributeds[.paragraphStyle] = style
        }

        let rect = text.boundingRect(with: size, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: attributeds, context: nil)

        result = rect.size

        return result
    }

}
