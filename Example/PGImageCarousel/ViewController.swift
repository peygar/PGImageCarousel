//
//  ViewController.swift
//  PGImageCarousel
//
//  Created by Peyman Gardideh on 11/20/2016.
//  Copyright (c) 2016 Peyman Gardideh. All rights reserved.
//

import UIKit
import PGImageCarousel

class ViewController: UIViewController, PGImageCarouselDelegate {
    
    var imageCarousel: PGImageCarousel!
    var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageCarousel = PGImageCarousel(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 300))
        imageCarousel.images = [#imageLiteral(resourceName: "testImage1"), #imageLiteral(resourceName: "testImage2"), #imageLiteral(resourceName: "testimage3")]
        self.view.addSubview(imageCarousel)
        imageCarousel.hasInfiniteScroll = false
        imageCarousel.delegate = self
        self.view.addSubview(label)
    }
}

