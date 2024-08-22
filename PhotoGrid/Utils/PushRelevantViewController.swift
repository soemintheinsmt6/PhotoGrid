//
//  PushRelevantViewController.swift
//  PhotoGrid
//
//  Created by Soemin Thein on 21/08/2024.
//

import UIKit

extension UIViewController {
    
    func pushPhotoDetailsViewController(image: String) {
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "photoDetailsVC") as? PhotoDetailsViewController {
            vc.downloadURL = image
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
