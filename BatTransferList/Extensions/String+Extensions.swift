//
//  String+Extensions.swift
//  Architecture
//
//  Created by Siamak on 4/18/23.
//

import Foundation
import UIKit
/// An extension to format strings in *camel case*.
extension String {
    /// A collection of all the words in the string by separating out any punctuation and spaces.
    var words: [String] {
        return components(separatedBy: CharacterSet.alphanumerics.inverted).filter { !$0.isEmpty }
    }

    /// Returns a copy of the string with the first word beginning lowercased, and the first
    /// letter of each word thereafter is capitalized, with no intervening spaces or punctuation,
    /// e.g., "theQuickBrownFoxJumpsOverTheLazyDog".
    ///
    /// *Lower camel case* (or, illustratively, *camelCase*) is also known as *Dromendary case*.
    func lowerCamelCased() -> String {
        guard !self.isEmpty else {
            return ""
        }
        let words = self.words
        let first = words.first!.lowercased()
        let rest = words.dropFirst().map { $0.capitalized }
        return ([first] + rest).joined()
    }

    /// Returns a copy of the string with the first letter of each word capitalized, with no
    /// intervening spaces or punctuation, e.g., "TheQuickBrownFoxJumpsOverTheLazyDog".
    ///
    /// *Upper camel case* (or, illustratively, *CamelCase*) is also known as *Pascal case*.
    func upperCamelCased() -> String {
        return self.words.map { $0.capitalized }.joined()
    }
    
    func localized() -> String {
        return NSLocalizedString(self, comment: self)
    }
    
    func height(withConstrainedWidth width: CGFloat, _ font: UIFont?) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        if let font = font {
            let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
            return ceil(boundingBox.height)
        } else {
            let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: nil, context: nil)
            return ceil(boundingBox.height)
        }
    }
}
