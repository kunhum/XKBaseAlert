//
//  XKNumberExtension.swift
//  XKCategorySwift
//
//  Created by kenneth on 2022/3/3.
//

// swiftlint:disable identifier_name
import Foundation

let Angle = { arc in
    return Double.pi / 180.0 * arc
}

public enum DoubleRoundedUnit: Double {
    /// 亿
    case hundredMillion = 100_000_000.0
    /// 万
    case tenThousand = 10_000.0
}

public extension CGFloat {
    var angle: CGFloat {
        return CGFloat(Double(self).angle)
    }
}

public extension Double {

    var angle: Double {
        return Angle(self)
    }

    var symbol: String {
        return self > 0.0 ? "+" : ""
    }

    var unit: String {
        return fabs(self) >= DoubleRoundedUnit.hundredMillion.rawValue ? "亿" : "万"
    }

    /// 格式化距离，返回*m，*km
    var distance: String {
        guard self > 1_000.0 else {
            return "\(self)" + "m"
        }
        return String(format: "%.1fkm", self / 1_000.0)
    }

    func rounded(byUnit unit: DoubleRoundedUnit, compareNumber: Int = 5) -> Int {

        let value            = self / unit.rawValue
        let roundedValue     = value.rounded(.awayFromZero)
        let valueComponenets = String(format: "%.1f", roundedValue / 10.0).components(separatedBy: ".")

        var lastValue  = valueComponenets.last?.xk_toInt() ?? 0
        var firstValue = Swift.abs(valueComponenets.first?.xk_toInt() ?? 0)

        guard lastValue != 0 else {
            return Int(roundedValue)
        }

        if lastValue > compareNumber {
            lastValue  = 0
            firstValue += 1
        } else {
            lastValue = compareNumber
        }

        let intValue = ([firstValue, lastValue] as NSArray).componentsJoined(by: "").xk_toInt() ?? 0

        return (value < 0.0) ? intValue * -1 : intValue
    }

    func digitText(_ number: Int, needFormatterPrice: Bool = false) -> String {
        var value = self
        if needFormatterPrice {
            value = fabs(self) >= 100_000_000.0 ? self / 100_000_000.0 : self / 10_000.0
        }
        switch number {
        case 0:
            return String(format: "%.0f", value)
        case 1:
            return String(format: "%.1f", value)
        case 2:
            return String(format: "%.2f", value)
        default:
            debugPrint("未实现相关方法")
            return ""
        }

    }

}
