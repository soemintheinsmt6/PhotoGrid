//
//  PushRelevantViewController.swift
//  PhotoGrid
//
//  Created by Soemin Thein on 21/08/2024.
//

import UIKit

extension UIViewController {
    
    func pushPhotoDetailsViewController(image: String) {
        let vc = PhotoDetailsViewController(nibName: "PhotoDetailsViewController", bundle: nil)
        vc.downloadURL = image
        navigationController?.pushViewController(vc, animated: true)
    }
}
