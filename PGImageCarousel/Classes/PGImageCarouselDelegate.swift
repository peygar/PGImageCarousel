//
//  PGImageCarouselDelegate.swift
//  Pods
//
//  Created by Peyman Halfmoon on 2016-11-28.
//
//

import Foundation

/**
 The object that acts as the delegate of the image carousel.
 
 The delegate must adopt the PGImageCarouselDelegate protocol.
 The image carousel maintains a weak reference to the delegate object.
 
 The delegate object is responsible for managing selection behavior
 and interactions with individual items.
 
 
 Functions:
 - (optional) didSelectImage(at index: Int)
 - (optional) didScrollToImage(at index: Int)
 */
public protocol PGImageCarouselDelegate: class {
    /**
     (Optional) Called when user selects an image in image carousel.
     - parameter index: index of the image selected
     */
    func didSelectImage(at index: Int)
    
    /**
     (Optional) Called when user stops scrolling on image carousel
     - parameter index: index of the image selected
     */
    func didScrollToImage(at index: Int)
}

public extension PGImageCarouselDelegate {
    /**
     (Optional) Called when user selects an image in image carousel.
     - parameter index: index of the image selected
     */
    func didSelectImage(at index: Int) {}
    
    /**
     (Optional) Called when user stops scrolling on image carousel
     - parameter index: index of the image selected
     */
    func didScrollToImage(at index: Int) {}
}
