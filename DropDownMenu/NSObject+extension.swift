//
//  NSObject+extension.swift
//  DropDownMenu
//
//  Created by admin on 10/4/18.
//  Copyright © 2018 cuongnv. All rights reserved.
//

import UIKit

extension NSObject {
    
    var className1: String {
        return String(describing: type(of: self))
    }
    
    
    public var className: String {
        return String(describing: type(of: self))
    }
}
