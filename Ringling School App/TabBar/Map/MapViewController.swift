//
//  MapViewController.swift
//  Ringling School App
//
//  Created by JJ Fila on 3/28/18.
//  Copyright © 2018 Ringling IT. All rights reserved.
//

import UIKit
import ImgurSession

class MapViewController: BaseTabBarViewController, UIScrollViewDelegate, IMGSessionDelegate {

    var mapImageView : UIImageView! = nil
    var mapPinContainer : MapPinContainer?
    var mapDetailViewController : DetailsViewerViewController? = nil
    var imgurImageGetter = ImgurImageGetter()
    var currentActivePin : MapPinImageView? {
        willSet {
            performPinGrowAnimation(mapPinImageViewSelected: currentActivePin, stretchSize: extraLargePinSize, endSize: normalPinSize)
            
            if let activeMapDetailViewController = mapDetailViewController {
                activeMapDetailViewController.animateOut(completion: {
                    activeMapDetailViewController.removeFromParentViewController()
                    activeMapDetailViewController.view.removeFromSuperview()
                })
            }
        }
        didSet {
            performPinGrowAnimation(mapPinImageViewSelected: currentActivePin, stretchSize: smallPinSize, endSize: largePinSize)
        }
    }
    
    let normalPinSize = CGSize(width: 50, height: 76.5)
    let smallPinSize = CGSize(width: 50 * 0.9, height: 76.5 * 0.9)
    let largePinSize = CGSize(width: 50 * 1.33, height: 76.5 * 1.33)
    let extraLargePinSize = CGSize(width: 50 * 1.67, height: 76.5 * 1.67)
    
    @IBOutlet weak var mapScrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let image = UIImage(named: RinglingAppConstants.Images.Map.CampusMap)!
        mapImageView = UIImageView(image: image)
        mapImageView.isUserInteractionEnabled = true
        mapImageView.frame = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        
        mapScrollView.addSubview(mapImageView)
        mapScrollView.contentSize = image.size

        mapScrollView.delaysContentTouches = true
        mapScrollView.canCancelContentTouches = false
        
        let singleTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(scrollViewTapped(_:)))
        singleTapRecognizer.numberOfTapsRequired = 1
        singleTapRecognizer.numberOfTouchesRequired = 1
        mapScrollView.addGestureRecognizer(singleTapRecognizer)
        
        let doubleTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(scrollViewDoubleTapped(_:)))
        doubleTapRecognizer.numberOfTapsRequired = 2
        doubleTapRecognizer.numberOfTouchesRequired = 1
        mapScrollView.addGestureRecognizer(doubleTapRecognizer)
        
        let scrollViewFrame = mapScrollView.frame
        let scaleWidth = scrollViewFrame.size.width / mapScrollView.contentSize.width
        let scaleHeight = scrollViewFrame.size.height / mapScrollView.contentSize.height
        let minScale = max(scaleWidth, scaleHeight)
        mapScrollView.minimumZoomScale = minScale
        mapScrollView.backgroundColor = RinglingAppConstants.Colors.MapBackgroundColor

        if let mapXmlUrl = Bundle.main.url(forResource: RinglingAppConstants.Miscellaneous.MapDataFileName, withExtension: RinglingAppConstants.Miscellaneous.MapDataExtension) {
            mapPinContainer = MapPinContainer.importXml(fileUrl: mapXmlUrl)
        }

        configureViewFromModel()

        centerScrollViewViewingAreaWithinBounds()
        
        mapScrollView.maximumZoomScale = 1.0
        mapScrollView.zoomScale = minScale;
        
        showCenterOfScrollViewContent()
    }
    
    // Private
    
    private func addPinView(withId id: Int, withName name: String, atLocation location:CGPoint) {
        
        let mapPinImage = UIImage(named:RinglingAppConstants.Images.Map.MapPin)! // keep this in memory?
        let mapPinImageFrame = CGRect(x: location.x - mapPinImage.size.width * 0.5, y: mapImageView.frame.size.height - location.y - mapPinImage.size.height, width: mapPinImage.size.width, height: mapPinImage.size.height)
        let mapPinImageView = MapPinImageView(frame: mapPinImageFrame, id: id)
        mapPinImageView.image = mapPinImage
        mapPinImageView.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(mapPinTapped (_:)))
        mapPinImageView.addGestureRecognizer(tapGestureRecognizer)
        
        mapImageView.addSubview(mapPinImageView)
    }
    
    private func configureViewFromModel() {
        if let unwrappedMapPinContainer = mapPinContainer {
            for (id, mapPin) in unwrappedMapPinContainer.mapPins {
                addPinView(withId: id.hashValue, withName:mapPin.name, atLocation: mapPin.location)
            }
        }
    }
    
    // effectively scrolls the scrollview so that the content is in the center
    private func showCenterOfScrollViewContent() {
        mapScrollView.contentOffset = CGPoint(x: max((mapScrollView.contentSize.width - mapScrollView.frame.width) * 0.5, 0),
                                              y: max((mapScrollView.contentSize.height - mapScrollView.frame.height) * 0.5, 0))
    }
    
    // moves the viewing area of the scroll view to be in the center of the frame
    private func centerScrollViewViewingAreaWithinBounds() {
        let boundsSize = mapScrollView.bounds.size
        var contentsFrame = mapImageView.frame
        
        if contentsFrame.size.width < boundsSize.width {
            contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) * 0.5
        } else {
            contentsFrame.origin.x = 0.0
            
        }
        
        if contentsFrame.size.height < boundsSize.height {
            contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) * 0.5
            
        } else {
            contentsFrame.origin.y = 0.0
        }
        
        mapImageView.frame = contentsFrame
    }
    
    private func performPinGrowAnimation(mapPinImageViewSelected: MapPinImageView?, stretchSize: CGSize, endSize: CGSize) {
        if let mapPinImageViewSelectedUnwrapped = mapPinImageViewSelected {
            UIView.animate(withDuration: 0.07, delay: 0.0, options: [.curveEaseOut, .allowUserInteraction] , animations: {
                let currentFrame = mapPinImageViewSelectedUnwrapped.frame
                mapPinImageViewSelectedUnwrapped.frame = CGRect(x: currentFrame.origin.x - (stretchSize.width - currentFrame.size.width) * 0.5, y: currentFrame.origin.y - (stretchSize.height - currentFrame.size.height), width: stretchSize.width, height: stretchSize.height)
            }) { finished in
                UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 3, options: [.curveEaseOut, .allowUserInteraction], animations: {
                    let currentFrame = mapPinImageViewSelectedUnwrapped.frame
                    mapPinImageViewSelectedUnwrapped.frame = CGRect(x: currentFrame.origin.x - (endSize.width - currentFrame.size.width) * 0.5, y: currentFrame.origin.y - (endSize.height - currentFrame.size.height), width: endSize.width, height: endSize.height)
                })
            }
        }
    }
    
    private func scrollAndZoomIfNotVisible(_ scrollView: UIScrollView, toPin pinView: MapPinImageView) {
        let drawerYPosition = mapDetailViewController?.drawerYPosition ?? view.frame.maxY
            
        let pinTipPoint = CGPoint(x: pinView.bounds.origin.x + pinView.bounds.size.width * 0.5, y: pinView.bounds.maxY)
        let convertedPoint = pinView.convert(pinTipPoint, to: scrollView.superview!)
        
        // Only scroll if the pin is below the drawer y position
        if (convertedPoint.y > drawerYPosition)
        {
            scrollView.scrollAndZoomIfNeeded(toPoint: convertedPoint)            
        }
    }
    
    private func select(pin pinView: MapPinImageView) {
        currentActivePin = pinView
        
        // TODO: add this to didSet?
        let newMapDetailViewController = (storyboard?.instantiateViewController(withIdentifier: "DetailsViewerViewController") as! DetailsViewerViewController)
        
        newMapDetailViewController.titleText = mapPinContainer?.mapPins[pinView.id]?.name ?? "Building Name Unavailable"
        newMapDetailViewController.descriptionText = mapPinContainer?.mapPins[pinView.id]?.description ?? ""
        
        if let imgurAlbumId = mapPinContainer?.mapPins[pinView.id]?.imgurAlbumId {
            imgurImageGetter.getAlbumCoverFromImgur(fromAlbumId: imgurAlbumId, completion: { coverImage in
                if let unwrappedCoverImage = coverImage {
                    newMapDetailViewController.mainImage = unwrappedCoverImage
                } else {
                    newMapDetailViewController.mainImage = UIImage(named: RinglingAppConstants.Images.Map.BuildingUnavailableImage)!
                }
            })
            
            imgurImageGetter.getAlbumImagesFromImgur(fromAlbumId: imgurAlbumId) { images in // TODO: get each image separately??
                newMapDetailViewController.add(photos: images)
            }
        }
        
        self.addChildViewController(newMapDetailViewController)
        view.addSubview(newMapDetailViewController.view)
        
        mapDetailViewController = newMapDetailViewController
        
        scrollAndZoomIfNotVisible(mapScrollView, toPin: pinView)
    }
    
    private func reselect(pin pinView: MapPinImageView) {
        performPinGrowAnimation(mapPinImageViewSelected: pinView, stretchSize: normalPinSize, endSize: largePinSize)
        mapDetailViewController?.animate(toSnapPosition: .MiddleSnapPosition)
    }
    
    // Main
    
    @objc func mapPinTapped(_ sender: UITapGestureRecognizer) {
        
        if let mapPinView = sender.view as? MapPinImageView {
            if (currentActivePin?.id !=  mapPinContainer?.mapPins[mapPinView.id]?.id) {
                select(pin: mapPinView)
            } else {
                reselect(pin: mapPinView)
            }
        }
    }
    
    @objc func scrollViewTapped(_ sender: UITapGestureRecognizer) {
        currentActivePin = nil
    }
    
    @objc func scrollViewDoubleTapped(_ sender: UITapGestureRecognizer) {
        let pointInView = sender.location(in: mapImageView)
        
        var newZoomScale = mapScrollView.zoomScale * 1.5
        newZoomScale = min(newZoomScale, mapScrollView.maximumZoomScale)        
        let scrollViewSize = mapScrollView.bounds.size
        let w = scrollViewSize.width / newZoomScale
        let h = scrollViewSize.height / newZoomScale
        
        let x = pointInView.x - (w * 0.5)
        let y = pointInView.y - (h * 0.5)
        let rectToZoomTo = CGRect(x: x, y: y, width: w, height: h);
        
        mapScrollView.zoom(to: rectToZoomTo, animated: true)
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return mapImageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        centerScrollViewViewingAreaWithinBounds()
    }
}
