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
        imageCarousel.delegate = self
        
        
        let button = UIButton(type: .roundedRect)
        button.frame = CGRect(x: 50, y: 400, width: 100, height: 20)
        button.setTitle("Button", for: .normal)
        button.addTarget(self, action: #selector(self.foo), for: .touchUpInside)
        self.view.addSubview(button)
        
        label = UILabel()
        label.frame = CGRect(x: 50, y: 500, width: 100, height: 20)
        label.text = "index: 0"
        self.view.addSubview(label)
    }
    
    func foo() {
        
    }
    
    func didScrollToImage(at index: Int) {
        label.text = "index: \(index)"
    }
}

