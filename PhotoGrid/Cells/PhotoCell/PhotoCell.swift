//
//  PhotoCell.swift
//  PhotoGrid
//
//  Created by Soemin Thein on 20/08/2024.
//

import UIKit
import SDWebImage

class PhotoCell: UICollectionViewCell {
    
    @IBOutlet weak var photo: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.layoutIfNeeded()
    }
    
    func configure(with item: PhotoModel) {
        photo.sd_setImage(with: URL(string: item.resizedImageURL), placeholderImage: UIImage.placeholderImage)
    }
}
