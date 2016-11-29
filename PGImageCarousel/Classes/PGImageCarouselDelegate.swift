//
//  PGImageCarouselDelegate.swift
//  Pods
//
//  Created by Peyman Halfmoon on 2016-11-28.
//
//

import Foundation

public protocol PGImageCarouselDelegate: class {
    func didSelectImage(at index: Int)
    func didScrollToImage(at index: Int)
}

public extension PGImageCarouselDelegate {
    func didSelectImage(at index: Int) {}
    func didScrollToImage(at index: Int) {}
}
