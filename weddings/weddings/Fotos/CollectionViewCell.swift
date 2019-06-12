//
//  CollectionViewCell.swift
//  weddings
//
//  Created by José Ruiz on 28/5/19.
//  Copyright © 2019 macos. All rights reserved.
//

import UIKit
import Kingfisher

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imgCell: UIImageView!
    
    public var urlDeLaImagen = ""
    
    var galleryModel: GalleryModel? {
        didSet {
            let url = URL(string: galleryModel?.imageUrl ?? "")
            
            if let url = url as? URL {
                KingfisherManager.shared.retrieveImage(with: url as Resource, options: nil, progressBlock: nil) { (image, error, cache, imageURL) in
                    self.imgCell.image = image
                    self.imgCell.kf.indicatorType = .activity
                    self.urlDeLaImagen = imageURL?.absoluteString ?? ""
                }
            }
        }
    }
}
