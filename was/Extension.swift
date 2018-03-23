//
//  Extension.swift
//  was
//
//  Created by Raül Duaigües on 16/02/2018.
//  Copyright © 2018 Raül Duaigües. All rights reserved.
//

import UIKit

enum UIUserInterfaceIdiom: Int {
    case undefined
    case phone
    case pad
}


struct ScreenSize {                                                     //instanciate lengths and sizes of screen
    static let width = UIScreen.main.bounds.size.width
    static let heigth = UIScreen.main.bounds.size.width
    static let maxLength = max(ScreenSize.width, ScreenSize.heigth)
    static let minLength = max(ScreenSize.width, ScreenSize.heigth)
}

struct DeviceType {
    static let isiPhone7 = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.maxLength == 667.0 //size iphone7
}

extension UIColor {                                                     //create a easy color selection function
    convenience init(red: Int, green: Int, blue: Int) {
        let newRed = CGFloat(red)/255
        let newGreen = CGFloat(green)/255
        let newBlue = CGFloat(blue)/255
        
        self.init(red: newRed, green: newGreen, blue: newBlue, alpha: 1.0)
        
    }
}

public extension Float {                                                //take a random number between a min and max
    public static func random() -> Float {
        return Float(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    public static func random(_ min:Float, max: Float) -> Float {
        return Float.random() * (max - min) + min
    }
}

extension Int {                                                         //convert degrees to radiants
    var DegreesToRadians: Double { return Double(self) * .pi/180}
}




