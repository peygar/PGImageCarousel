//
//  PGImageCarousel.swift
//  iOSStarterKit
//
//  Created by Peyman Halfmoon on 2016-11-15.
//
//

import UIKit

public class PGImageCarousel: UIView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    // MARK: Outlets
    @IBOutlet fileprivate var contentView: UIView!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var pageIndicator: UIPageControl!
    
    // MARK: Public Properties
    public var delegate: PGImageCarouselDelegate?
    public var images = [UIImage]() {
        didSet {
            guard let firstImage = self.images.first, let lastImage = self.images.last else {
                self.imagesWithCopies = []
                return
            }
            self.pageIndicator.isHidden = self.images.count <= 1
            var images = self.images
            images.insert(lastImage, at: 0)
            images.append(firstImage)
            self.imagesWithCopies = images
            self.resetCollection()
        }
    }
    public var gridSize: Int = 1 {
        didSet {
            guard self.gridSize > 0 else {
                self.gridSize = 1
                return
            }
            self.resetCollection()
        }
    }
    public var hasInfiniteScroll = true {
        didSet {
            if oldValue != self.hasInfiniteScroll {
                self.resetCollection()
            }
        }
    }
    // MARK: Private Properties
    private var bundle: Bundle {
        return Bundle(for: self.classForCoder)
    }
    private var imagesWithCopies = [UIImage]()
    fileprivate var displayImages: [UIImage] {
        if self.hasInfiniteScroll {
            return self.imagesWithCopies
        } else {
            return self.images
        }
    }
    
    // MARK: Init
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.sharedInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.sharedInit()
    }
    
    private func sharedInit() {
        self.loadViewFromNib()
        self.setupCollectionView()
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        self.imageCollectionView?.collectionViewLayout.invalidateLayout()
    }
    // MARK: Configure
    
    // MARK: Helpers
    private func loadViewFromNib() {
        self.bundle.loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)
        self.contentView.frame = self.bounds
        self.addSubview(self.contentView)
    }
    
    private func setupCollectionView() {
        self.registerCellNib()
        self.imageCollectionView.dataSource = self
        self.imageCollectionView.delegate = self
    }
    
    private func registerCellNib() {
        let imageCellNib = UINib(nibName: String(describing: PGImageCarouselCell.self), bundle: self.bundle)
        self.imageCollectionView?.register(imageCellNib, forCellWithReuseIdentifier: String(describing: PGImageCarouselCell.self))
    }
    
    private func resetCollection() {
        self.pageIndicator.numberOfPages = self.images.count / (self.gridSize * self.gridSize)
        self.pageIndicator.frame.size = self.pageIndicator.size(forNumberOfPages: self.pageIndicator.numberOfPages)
        self.imageCollectionView.reloadData()
        DispatchQueue.main.async {
            let firstImageIndexPath = IndexPath(item: self.hasInfiniteScroll ? 1 : 0, section: 0)
            self.imageCollectionView.scrollToItem(at: firstImageIndexPath, at: .centeredHorizontally, animated: false)
        }
    }
}

// MARK: UICollectionViewDataSource
private extension PGImageCarousel {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.displayImages.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let carouCell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: PGImageCarouselCell.self), for: indexPath) as! PGImageCarouselCell
        carouCell.setImage(image: self.displayImages[indexPath.row])
        
        return carouCell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.didSelectImage(at: indexPath.item - 1)
    }
}

// MARK: UICollectionViewDelegateFlowLayout
private extension PGImageCarousel {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let imageScale = 1.0 / CGFloat(self.gridSize)
        return collectionView.frame.size.applying(CGAffineTransform(scaleX: imageScale, y: imageScale))
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        var imageNumber = Int(scrollView.contentOffset.x / self.frame.width)
        var page: Int
        if self.hasInfiniteScroll {
            if imageNumber == 0 {
                page = self.displayImages.count - 3
                self.imageCollectionView.scrollToItem(at: IndexPath(item: page + 1, section: 0), at: .centeredHorizontally, animated: false)
            } else if imageNumber == self.displayImages.count - 1 {
                page = 0
                self.imageCollectionView.scrollToItem(at: IndexPath(item: page + 1, section: 0), at: .centeredHorizontally, animated: false)
            } else {
                page = imageNumber - 1
            }
        } else {
            page = imageNumber
        }
        self.pageIndicator.currentPage = page
        self.delegate?.didScrollToImage(at: page)
    }
}
