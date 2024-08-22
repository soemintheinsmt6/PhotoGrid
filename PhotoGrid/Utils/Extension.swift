//
//  Extension.swift
//  PhotoGrid
//
//  Created by Soemin Thein on 20/08/2024.
//

import UIKit

extension UIImage {
    
    static var placeholderImage: UIImage? {
        UIImage(named: "placeholder")
    }
}


extension UIImageView {
    func enableZoom() {
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(startZooming(_:)))
        isUserInteractionEnabled = true
        addGestureRecognizer(pinchGesture)
    }
    
    @objc private func startZooming(_ sender: UIPinchGestureRecognizer) {
        let scaleResult = sender.view?.transform.scaledBy(x: sender.scale, y: sender.scale)
        guard let scale = scaleResult, scale.a > 1, scale.d > 1 else { return }
        sender.view?.transform = scale
        sender.scale = 1
    }
}


extension UIViewController {
    
    var screenWidth: CGFloat {
        view.window?.windowScene?.screen.bounds.width ?? 1
    }
    
    var screenHeight: CGFloat {
        view.window?.windowScene?.screen.bounds.height ?? 1
    }
}

