//
//  PGImageCarousel.swift
//  iOSStarterKit
//
//  Created by Peyman Halfmoon on 2016-11-15.
//
//

import UIKit

/**
 UIComponent for a quick image carousel. Can be initialized through nibs or code.
 Features include:
 - Scrollable image carousel
 - page indicator
 - continous scroll
 - variable grid size
 - delegate callbacks
 */
public class PGImageCarousel: UIView {
    // MARK: Outlets
    @IBOutlet private var contentView: UIView!
    
    /**
     Collection view of images.
    */
    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    /**
     Page indicator shows page number of currently viewed image.
     */
    @IBOutlet weak var pageIndicator: UIPageControl!
    
    // MARK: Public Properties
    /**
     The object that acts as the delegate of the image carousel.
     
     The delegate must adopt the PGImageCarouselDelegate protocol. 
     The image carousel maintains a weak reference to the delegate object.
     
     The delegate object is responsible for managing selection behavior 
     and interactions with individual items.
     */
    public weak var delegate: PGImageCarouselDelegate?
    
    /**
     The images inside the image carousel. 
     
     Reloads carousel on setting, unless the autoReloads property is false.
     */
    public var images = [UIImage]() {
        didSet {
            guard let firstImage = self.images.first, let lastImage = self.images.last else {
                self.imagesWithCopies = []
                self.autoReload()
                return
            }
            self.pageIndicator.isHidden = self.images.count <= 1
            var images = self.images
            images.insert(lastImage, at: 0)
            images.append(firstImage)
            self.imagesWithCopies = images
            self.autoReload()
        }
    }
    /**
     Defines the grid size for image carousel. 1 means 1x1 grid -> 1 image per 
     carousel page, 2 means 2x2 grid -> 4 images per carousel page etc.
     
     @Discussion Recommended to hide page indicator if gridSize is greater 1.
     
     Reloads carousel on setting, unless the autoReloads property is false.
     */
    public var gridSize = 1 {
        didSet {
            guard self.gridSize > 0 else {
                self.gridSize = 1
                self.autoReload()
                return
            }
            self.autoReload()
        }
    }
    
    /**
     If set to true, carousel images are on an infinte loop and user can swipe 
     in one direction without limit.
     
     Reloads carousel on setting, unless the autoReloads property is false
     */
    public var hasInfiniteScroll = true {
        didSet {
            if oldValue != self.hasInfiniteScroll {
                self.autoReload()
            }
        }
    }
    
    /**
     Defines if image carousel reloads data on changing properties
     */
    public var autoReloads = true
    // MARK: Private Properties
    private var imagesWithCopies = [UIImage]()
    fileprivate var displayImages: [UIImage] {
        if self.hasInfiniteScroll {
            return self.imagesWithCopies
        } else {
            return self.images
        }
    }
    private var bundle: Bundle {
        return Bundle(for: self.classForCoder)
    }
    
    // MARK: Configure
    /**
     Reloads image carousel. Includes images, page control and infiniteScroll
     */
    public func reload() {
        self.resetCollection()
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
    
    private func autoReload() {
        if self.autoReloads {
            self.resetCollection()
        }
    }
}

// MARK: UICollectionViewDataSource
extension PGImageCarousel: UICollectionViewDataSource {
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
extension PGImageCarousel: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let imageScale = 1.0 / CGFloat(self.gridSize)
        return collectionView.frame.size.applying(CGAffineTransform(scaleX: imageScale, y: imageScale))
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let imageNumber = Int(scrollView.contentOffset.x / self.frame.width)
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
