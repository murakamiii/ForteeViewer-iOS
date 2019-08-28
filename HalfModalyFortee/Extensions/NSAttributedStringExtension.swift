//
//  NSAttributedStringExtension.swift
//  HalfModalyFortee
//
//  Created by murakami Taichi on 2019/08/28.
//  Copyright © 2019 murakammm. All rights reserved.
//

import Foundation
import UIKit

extension NSAttributedString {
    convenience init(string: String, lineSpacing: CGFloat, alignment: NSTextAlignment) {
        var attributes: [NSAttributedString.Key: Any] = [:]
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.alignment = alignment
        attributes.updateValue(paragraphStyle, forKey: .paragraphStyle)
        self.init(string: string, attributes: attributes)
    }
}
