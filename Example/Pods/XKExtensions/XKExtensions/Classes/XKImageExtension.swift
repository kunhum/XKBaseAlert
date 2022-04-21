//
//  XKImageExtension.swift
//  XKCategorySwift
//
//  Created by kenneth on 2022/2/23.
//

// swiftlint:disable superfluous_disable_command
import Foundation

public extension UIImage {

    static func gif(assetName: String, bundle: Bundle? = nil) -> UIImage? {
        var tmpData: Data?
        if let bundle = bundle {
            tmpData = NSDataAsset(name: assetName, bundle: bundle)?.data
        } else {
            tmpData = NSDataAsset(name: assetName)?.data
        }
        guard let data = tmpData else { return nil }
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else { return nil }

        return animatedImageWithSource(source)
    }

}

extension UIImage {

    class func animatedImageWithSource(_ source: CGImageSource) -> UIImage? {
        let count  = CGImageSourceGetCount(source)
        var images = [CGImage]()
        var delays = [Int]()

        // Fill arrays
        for i in 0..<count {
            // Add image
            if let image = CGImageSourceCreateImageAtIndex(source, i, nil) { images.append(image) }

            // At it's delay in cs
            let delaySeconds = UIImage.delayForImageAtIndex(Int(i), source: source)
            delays.append(Int(delaySeconds * 1_000.0)) // Seconds to ms
        }

        // Calculate full duration
        let duration: Int = {
            var sum = 0
            for val: Int in delays { sum += val }
            return sum
        }()

        // Get frames
        let gcd    = gcdForArray(delays)
        var frames = [UIImage]()

        var frame: UIImage
        var frameCount: Int
        for i in 0..<count {
            frame      = UIImage(cgImage: images[Int(i)])
            frameCount = Int(delays[Int(i)] / gcd)
            for _ in 0..<frameCount { frames.append(frame) }
        }

        // Heyhey
        let animation = UIImage.animatedImage(with: frames, duration: Double(duration) / 1_000.0)
        return animation
    }

    class func delayForImageAtIndex(_ index: Int, source: CGImageSource) -> Double {
        var delay = 0.1

        // Get dictionaries
        let cfProperties         = CGImageSourceCopyPropertiesAtIndex(source, index, nil)
        let gifPropertiesPointer = UnsafeMutablePointer<UnsafeRawPointer?>.allocate(capacity: 0)
        defer { gifPropertiesPointer.deallocate() }

        if CFDictionaryGetValueIfPresent(cfProperties, Unmanaged.passUnretained(kCGImagePropertyGIFDictionary).toOpaque(), gifPropertiesPointer) == false { return delay }

        let gifProperties: CFDictionary = unsafeBitCast(gifPropertiesPointer.pointee, to: CFDictionary.self)

        // Get delay time
        var delayObject: AnyObject = unsafeBitCast(CFDictionaryGetValue(gifProperties,
                Unmanaged.passUnretained(kCGImagePropertyGIFUnclampedDelayTime).toOpaque()), to: AnyObject.self)
        if delayObject.doubleValue == 0 {
            delayObject = unsafeBitCast(CFDictionaryGetValue(gifProperties,
                Unmanaged.passUnretained(kCGImagePropertyGIFDelayTime).toOpaque()), to: AnyObject.self)
        }

        if let delayObject = delayObject as? Double, delayObject > 0 {
            delay = delayObject
        } else {
            delay = 0.1 // Make sure they're not too fast
        }

        return delay
    }

    class func gcdForArray(_ array: [Int]) -> Int {
        if array.isEmpty {
            return 1
        }

        var gcd = array[0]

        for val in array {
            gcd = UIImage.gcdForPair(val, gcd)
        }

        return gcd
    }

    class func gcdForPair(_ a: Int?, _ b: Int?) -> Int {
        var a = a
        var b = b

        // Check if one of them is nil
        if b == nil || a == nil {
            if b != nil {
                return b ?? 0
            } else if a != nil {
                return a ?? 0
            } else {
                return 0
            }
        }

        // Swap for modulo
        if (a ?? 0) < (b ?? 0) {
            let c = a
            a = b
            b = c
        }

        // Get greatest common divisor
        var rest: Int
        while true {
            rest = (a ?? 0) % (b ?? 0)

            if rest == 0 {
                return b ?? 0 // Found it
            } else {
                a = b
                b = rest
            }
        }
    }
}
