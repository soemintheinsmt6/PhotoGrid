//
//  UIViewController-Extension.swift
//  PhotoGrid
//
//  Created by Soemin Thein on 20/08/2024.
//

import UIKit

extension UIViewController {
    
    var screenWidth: CGFloat {
        view.window?.windowScene?.screen.bounds.width ?? 1
    }
    
    var screenHeight: CGFloat {
        view.window?.windowScene?.screen.bounds.height ?? 1
    }
}

