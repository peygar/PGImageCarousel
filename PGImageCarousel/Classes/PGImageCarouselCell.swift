//
//  PGImageCarouselCell.swift
//  iOSStarterKit
//
//  Created by Peyman Halfmoon on 2016-11-15.
//
//

import UIKit

class PGImageCarouselCell: UICollectionViewCell {

    @IBOutlet private weak var imageView: UIImageView!
    
    func setImage(image: UIImage) {
        self.imageView.image = image
    }
}
