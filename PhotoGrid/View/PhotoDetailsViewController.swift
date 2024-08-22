//
//  PhotoDetailsViewController.swift
//  PhotoGrid
//
//  Created by Soemin Thein on 21/08/2024.
//

import UIKit
import SDWebImage

class PhotoDetailsViewController: UIViewController {
    
    var downloadURL = String()
    
    @IBOutlet weak var photo: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    private func setupView() {
        photo.sd_imageIndicator = SDWebImageActivityIndicator.gray
        photo.sd_setImage(with: URL(string: downloadURL), placeholderImage: UIImage.placeholderImage)
        photo.enableZoom()
    }
    
}
