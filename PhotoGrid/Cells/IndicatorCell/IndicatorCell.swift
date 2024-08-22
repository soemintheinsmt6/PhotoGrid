//
//  IndicatorCell.swift
//  PhotoGrid
//
//  Created by Soemin Thein on 20/08/2024.
//

import UIKit

class IndicatorCell: UICollectionViewCell {
    
    private var inidicator : UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.style = .medium
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layoutIfNeeded()
        inidicator.startAnimating()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setup() {
        inidicator.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(inidicator)
        NSLayoutConstraint.activate([
            inidicator.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            inidicator.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        inidicator.startAnimating()
    }
}
