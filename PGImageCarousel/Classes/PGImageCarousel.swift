//
//  PGImageCarousel.swift
//  iOSStarterKit
//
//  Created by Peyman Halfmoon on 2016-11-15.
//
//

import UIKit

class PGImageCarousel: UIView {
    // MARK: Outlets
    @IBOutlet fileprivate var contentView: UIView!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var pageIndicator: UIPageControl!
    
    // MARK: Properties
    var images = [UIImage]() {
        didSet {
            self.pageIndicator.isHidden = self.images.count <= 1
            self.resetCollection()
        }
    }
    var gridSize: Int = 1 {
        didSet {
            guard self.gridSize > 0 else {
                self.gridSize = 1
                return
            }
            self.resetCollection()
        }
    }
    
    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.sharedInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.sharedInit()
    }
    
    fileprivate func sharedInit() {
        self.loadViewFromNib()
        self.setupCollectionView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.imageCollectionView?.collectionViewLayout.invalidateLayout()
    }
    
    // MARK: Helpers
    fileprivate func loadViewFromNib() {
        let viewNib = UINib(nibName: String(describing: PGImageCarousel.self), bundle: nil)
        viewNib.instantiate(withOwner: self, options: nil)
        self.contentView.frame = self.bounds
        self.addSubview(self.contentView)
    }
    
    fileprivate func setupCollectionView() {
        self.registerCellNib()
        self.imageCollectionView.dataSource = self
        self.imageCollectionView.delegate = self
    }
    
    fileprivate func registerCellNib() {
        let imageCellNib = UINib(nibName: String(describing: PGImageCarouselCell.self), bundle: nil)
        self.imageCollectionView?.register(imageCellNib, forCellWithReuseIdentifier: String(describing: PGImageCarouselCell.self))
    }
    
    fileprivate func resetCollection() {
        self.pageIndicator.numberOfPages = self.images.count / (self.gridSize * self.gridSize)
        self.pageIndicator.frame.size = self.pageIndicator.size(forNumberOfPages: self.pageIndicator.numberOfPages)
        self.imageCollectionView.reloadData()
    }
}

// MARK: UICollectionViewDataSource
extension PGImageCarousel: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let carouCell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: PGImageCarouselCell.self), for: indexPath) as! PGImageCarouselCell
        carouCell.setImage(image: self.images[indexPath.row])
        
        return carouCell
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension PGImageCarousel: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let imageScale = 1.0 / CGFloat(self.gridSize)
        return collectionView.frame.size.applying(CGAffineTransform(scaleX: imageScale, y: imageScale))
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = Int(scrollView.contentOffset.x / self.frame.width)
        self.pageIndicator.currentPage = page
    }
}
