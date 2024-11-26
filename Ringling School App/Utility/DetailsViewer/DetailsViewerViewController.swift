//
//  DetailsViewerViewController.swift
//  Ringling School App
//
//  Created by JJ Fila on 6/4/18.
//  Copyright © 2018 Ringling IT. All rights reserved.
//

import UIKit

class DetailsViewerViewController: UIViewController {
    
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var mainImageView: UIImageView!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var scrollView: UIScrollView!
    
    @IBOutlet private weak var detailsDrawerView: DetailsDrawerView!
    @IBOutlet private weak var topLayoutConstraint: NSLayoutConstraint!
    @IBOutlet private weak var contentViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollViewTopLayoutConstraint: NSLayoutConstraint! // height of drawer gripper
    
    private let middleSnapPositionOffset : CGFloat = 193 // height of photo plus top of drawer
    private let bottomSnapPositionOffset : CGFloat = 0    
    private let photoVerticalSpacing : CGFloat = 5
    private let generalVerticalSpacing : CGFloat = 25
    
    private var detailsViewerSnapper : DetailsViewerSnapper!
    
    private var startingPanConstant : CGFloat = 0
    private var startingScrollConstant : CGFloat = 0
    private var detailViewSnappedFirstTime = false
    private var disableScrollingInScrollView = true        
    
    private var extraPhotosImageViews = [UIImageView]()
    
    private let classCreationTimeReference = NSDate.timeIntervalSinceReferenceDate
    
    var drawerYPosition : CGFloat {
        get {
            return topLayoutConstraint.constant
        }
    }
    
    var titleText : String = "Title" {
        didSet {
            titleLabel?.text = titleText
        }
    }
    
    var mainImage : UIImage? {
        didSet {
            mainImageView.image = mainImage
            animateInIfLongDelay(forImageView: mainImageView)
        }
    }
    
    var descriptionText : String = "Description" {
        didSet {
            descriptionLabel?.text = descriptionText
            descriptionLabel?.sizeToFit()
        }
    }
    
    // Setup
    
    private func setupUI() {
        titleLabel?.text = titleText
        mainImageView.clipsToBounds = true
        mainImageView.image = mainImage
        descriptionLabel?.text = descriptionText
        descriptionLabel?.sizeToFit()
        mainImageView.backgroundColor = RinglingAppConstants.Colors.ImagePlaceholderColor
    }
    
    private func resetAndRealignPhotos() {
        for photoImageView in extraPhotosImageViews {
            photoImageView.removeFromSuperview()
        }
        
        realignAllPhotos()
    }
    
    private func addPhotosToContentViewAndRealign(_ photos: [UIImage]) {
        for photo in photos {
            let imageView = UIImageView(image: photo)
            let ratio = photo.size.width / photo.size.height
            imageView.frame.size = CGSize(width: view.frame.width, height: view.frame.width / ratio)
            extraPhotosImageViews.append(imageView)
            contentView.addSubview(imageView)
        }

        realignAllPhotos()
    }
    
    private func realignAllPhotos() {
        var nextPhotoYPosition = descriptionLabel.frame.maxY + generalVerticalSpacing
        for photoImageView in extraPhotosImageViews {
            photoImageView.frame.origin = CGPoint(x: photoImageView.frame.origin.x, y: nextPhotoYPosition)
            nextPhotoYPosition = photoImageView.frame.maxY + photoVerticalSpacing
        }
        
        contentViewHeightConstraint.constant = nextPhotoYPosition
        
        addWhiteSpaceIfNeeded()
    }
    
    private func addWhiteSpaceIfNeeded() {
        // if the content does not fill the page, increasing the hight of the view to the bottom adds just enough white space
        if (contentViewHeightConstraint.constant < view.frame.maxY) {
            contentViewHeightConstraint.constant = view.frame.maxY
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setupUI()
        resetAndRealignPhotos()
        
        topLayoutConstraint.constant = view.frame.maxY
        view.layoutIfNeeded()
        
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(panGesture(_:)))
        view.addGestureRecognizer(gesture)
        scrollView.isUserInteractionEnabled = false
        
        disableScrollingInScrollView = true
    }
    
    override func viewSafeAreaInsetsDidChange() {
        // Note: we need to account for the height of the top safe area inset because a height of 0 snaps to the safe area for the detailsViewSnapper
        let middleSnapPosition = view.frame.maxY - view.safeAreaInsets.bottom - middleSnapPositionOffset - view.safeAreaInsets.top - scrollViewTopLayoutConstraint.constant
        let bottomSnapPosition = view.frame.maxY - view.safeAreaInsets.bottom - view.safeAreaInsets.top - scrollViewTopLayoutConstraint.constant
        
        if (detailViewSnappedFirstTime == false) {
            detailsViewerSnapper = DetailsViewerSnapper(topSnapPosition: 0,
                                                        middleSnapPosition: middleSnapPosition,
                                                        bottomSnapPosition: bottomSnapPosition,
                                                        offScreenBottomSnapPosition: view.frame.maxY)
            
            detailsViewerSnapper.snapViewAndAnimate(view, toSnapPosition: .MiddleSnapPosition, withLayoutConstraint: topLayoutConstraint, completion: {})
            detailViewSnappedFirstTime = true
        } else {
            detailsViewerSnapper.middleSnapPosition = middleSnapPosition
            detailsViewerSnapper.bottomSnapPosition = bottomSnapPosition
        }
    }
    
    // main functionality
    
    private func animateInIfLongDelay(forImageView imageView: UIImageView) {
        let imageCreationTimeReference = NSDate.timeIntervalSinceReferenceDate
        let timeDifference = imageCreationTimeReference - classCreationTimeReference
        if (timeDifference >= 0.15) {
            let backgroundTransition = CATransition()
            backgroundTransition.duration = 0.5
            backgroundTransition.type = kCATransitionFade
            backgroundTransition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            mainImageView.layer.add(backgroundTransition, forKey: kCATransitionReveal)
        }
    }
    
    private func panAndReturnIfShouldStillBeInScrollState(withTranslation translation : CGPoint) -> Bool {
        let endingScrollConstant = scrollView.contentOffset.y
        let endingPanConstant = max(translation.y + startingPanConstant + endingScrollConstant - startingScrollConstant, 0)
        topLayoutConstraint.constant = endingPanConstant
        if (endingPanConstant == 0) { // the drawer is at the top and the swipe is up
            return false
        } else {
            return true
        }
    }
    
    private func scrollAndReturnIfShouldStillBeInScrollState(withTranslation translation : CGPoint) -> Bool {
        let endingPanConstant = topLayoutConstraint.constant
        let endingScrollConstant = max(-1 * translation.y + startingScrollConstant + endingPanConstant - startingPanConstant, 0)
        scrollView.setContentOffset(CGPoint(x: 0, y: endingScrollConstant), animated: false)
        if (endingScrollConstant == 0) { // the drawer is at the top and the swipe is down
            return true
        } else { // the drawer is at the top
            return false
        }
    }
    
    private func simulateScrollInertia(withVelocity velocity : CGPoint) {  // velocity in points/second
        UIView.animate(withDuration: 1.2, delay: 0, options: [.allowUserInteraction, .curveEaseOut, .beginFromCurrentState], animations: {
            let finalScrollDestination = min(max(0, self.scrollView.contentOffset.y - (velocity.y * 0.40)), self.contentView.frame.height - self.detailsDrawerView.frame.height)
            self.scrollView.setContentOffset(CGPoint(x: 0, y: finalScrollDestination), animated: false)
        })
    }
    
    private func stopScrollIntertiaAnimationIfNeeded() {
        if (scrollView.layer.animationKeys() != nil) // checks if there are any animations currently in progress
        {
            if let presentationLayer = scrollView.layer.presentation() {
                let scrollPosition = presentationLayer.bounds.origin
                scrollView.layer.removeAllAnimations()
                scrollView.setContentOffset(scrollPosition, animated: false)
            }
        }
    }
    
    // Main functionality
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        stopScrollIntertiaAnimationIfNeeded()
    }
    
    @objc private func panGesture(_ recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            startingPanConstant = topLayoutConstraint.constant
            startingScrollConstant = scrollView.contentOffset.y
        case .changed:
            if (disableScrollingInScrollView == false)
            {
                disableScrollingInScrollView = scrollAndReturnIfShouldStillBeInScrollState(withTranslation: recognizer.translation(in: view))
            } else {
                disableScrollingInScrollView = panAndReturnIfShouldStillBeInScrollState(withTranslation: recognizer.translation(in: view))
            }
        default: // should enter this state at the end of the swipe/pan
            if (!disableScrollingInScrollView) {
                simulateScrollInertia(withVelocity: recognizer.velocity(in: view))
            } else {
                detailsViewerSnapper.snapViewAndAnimate(view, withSwipeVelocity: recognizer.velocity(in: view), withLayoutConstraint: topLayoutConstraint, completion: {})
            }
            break
        }
    }
    
    func animateOut(completion: @escaping () -> Void) {
        detailsViewerSnapper.snapViewAndAnimate(view, toSnapPosition: .OffScreenBottomSnapPosition, withLayoutConstraint: topLayoutConstraint, completion: completion)
    }
    
    func animate(toSnapPosition snapPosition: DetailsViewerSnapper.SnapPosition) {
        detailsViewerSnapper.snapViewAndAnimate(view, toSnapPosition: snapPosition, withLayoutConstraint: topLayoutConstraint, completion: {})
    }
    
    func add(photos : [UIImage]) {
        addPhotosToContentViewAndRealign(photos)
    }
}
