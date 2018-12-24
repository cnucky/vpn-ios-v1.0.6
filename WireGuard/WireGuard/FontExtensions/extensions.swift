//
//  extensions.swift
//  near-u
//
//  Created by Cheng Kok Chun on 17/07/2017.
//  Copyright © 2017 Junjunjun. All rights reserved.
//

import UIKit

/*
 print("font \(UIFont.familyNames())")
 
 for family in UIFont.familyNames()
 {
 print("\(family)")
 
 for name in UIFont.fontNamesForFamilyName(family)
 {
 print("   \(name)")
 }
 }
 
 Roboto Condensed
 RobotoCondensed-Bold
 RobotoCondensed-Light
 RobotoCondensed-BoldItalic
 RobotoCondensed-Italic
 RobotoCondensed-Regular
 RobotoCondensed-LightItalic
 
 */

extension UILabel {
    public var substituteFontName : String {
        get {
            return self.font.fontName;
        }
        set {
            let fontNameToTest = self.font.fontName.lowercased();
            var fontName = newValue;
            if fontNameToTest.range(of: "bold") != nil {
                fontName += "-Bold";
            } else if fontNameToTest.range(of: "medium") != nil {
                fontName += "-Medium";
            } else if fontNameToTest.range(of: "light") != nil {
                fontName += "-Light";
            } else if fontNameToTest.range(of: "ultralight") != nil {
                fontName += "-UltraLight";
            }
            self.font = UIFont(name: fontName, size: self.font.pointSize)
        }
    }
}

//extension UIButton {
//    public var substituteFontName : String {
//        get {
//            return (self.titleLabel?.font.fontName)!;
//        }
//        set {
//            let fontNameToTest = self.titleLabel?.font.fontName.lowercased
//            var fontName = newValue;
//
//            if fontNameToTest!().range(of: "Regular") != nil {
//                fontName += "-Regular";
//            }
//
//            self.titleLabel?.font = UIFont(name: fontName, size: (self.titleLabel?.font.pointSize)!)!
//        }
//    }
//}

//extension UIButton {
//    public var substituteFontName : String {
//        get {
//            return self.font?.fontName ?? "";
//        }
//        set {
//            let fontNameToTest = self.font?.fontName.lowercased() ?? "";
//            var fontName = newValue;
//            if fontNameToTest.range(of: "bold") != nil {
//                fontName += "-Bold";
//            } else if fontNameToTest.range(of: "medium") != nil {
//                fontName += "-Medium";
//            } else if fontNameToTest.range(of: "light") != nil {
//                fontName += "-Light";
//            } else if fontNameToTest.range(of: "ultralight") != nil {
//                fontName += "-UltraLight";
//            }
//            self.font = UIFont(name: fontName, size: self.font?.pointSize ?? 17)
//        }
//    }
//}

extension UITextField {
    public var substituteFontName : String {
        get {
            return self.font?.fontName ?? "";
        }
        set {
            let fontNameToTest = self.font?.fontName.lowercased() ?? "";
            var fontName = newValue;
            if fontNameToTest.range(of: "bold") != nil {
                fontName += "-Bold";
            } else if fontNameToTest.range(of: "medium") != nil {
                fontName += "-Medium";
            } else if fontNameToTest.range(of: "light") != nil {
                fontName += "-Light";
            } else if fontNameToTest.range(of: "ultralight") != nil {
                fontName += "-UltraLight";
            }
            self.font = UIFont(name: fontName, size: self.font?.pointSize ?? 17)
        }
    }
}

extension UITextView {
    public var substituteFontName : String {
        get {
            return self.font?.fontName ?? "";
        }
        set {
            let fontNameToTest = self.font?.fontName.lowercased() ?? "";
            var fontName = newValue;
            if fontNameToTest.range(of: "bold") != nil {
                fontName += "-Bold";
            } else if fontNameToTest.range(of: "medium") != nil {
                fontName += "-Medium";
            } else if fontNameToTest.range(of: "light") != nil {
                fontName += "-Light";
            } else if fontNameToTest.range(of: "ultralight") != nil {
                fontName += "-UltraLight";
            }
            self.font = UIFont(name: fontName, size: self.font?.pointSize ?? 17)
        }
    }
}
