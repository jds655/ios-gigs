//
//  Styling.swift
//  ios-gigs
//
//  Created by Joshua Sharp on 9/5/19.
//  Copyright © 2019 Lambda. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    convenience init(rgb:UInt, alpha:CGFloat = 1.0) {
        self.init(
            red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgb & 0x0000FF) / 255.0,
            alpha: CGFloat(alpha)
        )
    }
}

let viewBGColor = UIColor(rgb: 0x231942)
let viewTintColor = UIColor(rgb: 0xe0b1cb)

struct ColorPallet {
    let name            : String
    let screenBGColor   : UIColor
    let textBGColor     : UIColor
    let textFGColor     : UIColor
    let buttonBGColor   : UIColor
    let buttonFGColor   : UIColor
    let controlBGCOlor  : UIColor
    let controlFGColor  : UIColor
}


func viewSetStyling (on view: UIView) {
    view.backgroundColor = viewBGColor
    view.tintColor = viewTintColor
}

class customView: UIView {

}

class customButton: UIButton {
    
}

class customLabel: UILabel {
    
}

class customTextField: UITextField {
    
}
