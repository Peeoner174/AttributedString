import UIKit
import Foundation

struct AttributedString: ExpressibleByStringInterpolation {
    
    struct StringInterpolation: StringInterpolationProtocol {
        var output = NSMutableAttributedString()
        var baseAttributes: [NSAttributedString.Key: Any] = [:]
        
        init(literalCapacity: Int, interpolationCount: Int) { }
        
        mutating func apply(color: UIColor?, background: UIColor?, style: UIFont?, strikethrough: Bool?, to any: Any) {
            baseAttributes[.backgroundColor] = background
            baseAttributes[.foregroundColor] = color
            baseAttributes[.font] = style
            baseAttributes[.strikethroughStyle] = (strikethrough ?? false) ? NSNumber(value: NSUnderlineStyle.single.rawValue) : nil
            appendLiteral("\(any)")
            baseAttributes = [:]
        }
        
        mutating func appendLiteral(_ literal: String) {
            let attributedString = NSAttributedString(string: literal, attributes: baseAttributes)
            output.append(attributedString)
        }
        
        mutating func appendInterpolation(_ any: Any, color: UIColor? = nil, background: UIColor? = nil, style: UIFont? = nil, strikethrough: Bool? = nil) {
            apply(color: color, background: background, style: style, strikethrough: strikethrough, to: any)
        }
        
    }
    
    let value: NSAttributedString
    
    init(stringLiteral value: String) {
        self.value = NSAttributedString(string: value)
    }
    
    init(stringInterpolation: StringInterpolation) {
        self.value = stringInterpolation.output
    }
    
}

extension NSAttributedString {
    static public func +(lhs: NSAttributedString, rhs: NSAttributedString) -> NSAttributedString {
        let newAttributedString = lhs.mutableCopy() as! NSMutableAttributedString
        newAttributedString.append(rhs)
        return newAttributedString
    }
}


// MARK: - Examples of realization

func formCrossedOutPriceAndRedDiscount(price: String, discountPrice: String) -> NSAttributedString {
    let price: AttributedString = "\(price, color: UIColor.black.withAlphaComponent(0.5), style: UIFont.systemFont(ofSize: 15.0, weight: .bold), strikethrough: true)"
    let discountPrice: AttributedString = "\(discountPrice, color: UIColor.red)"
    let result: NSAttributedString = price.value + NSAttributedString(string: "\n") + discountPrice.value
    
    return result
}

formCrossedOutPriceAndRedDiscount(price: "16", discountPrice: "17")



