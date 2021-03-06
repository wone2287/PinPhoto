//
//  EditImageItemViewController.swift
//  PinPhoto
//
//  Created by won heo on 2020/07/31.
//  Copyright © 2020 won heo. All rights reserved.
//

import UIKit

final class EditImageItemViewController: UIViewController {
    // MARK:- @IBOutlet Properties
    @IBOutlet private weak var itemScrollView: UIScrollView!
    @IBOutlet private weak var itemImageView: UIImageView!
    
    // MARK:- Propertises
    private var shouldBackgroundViewDark: Bool = false {
        didSet {
            if shouldBackgroundViewDark {
                view.backgroundColor = UIColor.black
                navigationController?.interactivePopGestureRecognizer?.isEnabled = false
            } else {
                view.backgroundColor = UIColor.systemBackground
                navigationController?.interactivePopGestureRecognizer?.isEnabled = true
            }
        }
    }
    
    private var isStatusBarHidden: Bool = false {
        didSet {
            setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    var item: Item?
    
    override var prefersStatusBarHidden: Bool {
        return isStatusBarHidden
    }

    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return UIStatusBarAnimation.slide
    }
    
    // MARk:- View Life Sycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = item?.updateDate.title
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        itemImageView.addGestureRecognizer(tapGesture)
        
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(imageDoubleTapped(_:)))
        doubleTapGesture.numberOfTouchesRequired = 1
        doubleTapGesture.numberOfTapsRequired = 2
        
        itemImageView.addGestureRecognizer(doubleTapGesture)
        itemImageView.isUserInteractionEnabled = true
        itemImageView.image = item?.contentImage?.image
        
        itemScrollView.alwaysBounceVertical = false
        itemScrollView.alwaysBounceHorizontal = false
        
        itemScrollView.minimumZoomScale = 1.0
        itemScrollView.maximumZoomScale = 3.0
        itemScrollView.contentInsetAdjustmentBehavior = .never
        itemScrollView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let navVc = navigationController as? HomeNavigationController else { return }
        navVc.dismissAddButtonView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let navVc = navigationController as? HomeNavigationController else { return }
        navVc.presentAddButtonView()
    }

    // MARK:- Methods
    static func storyboardInstance() -> EditImageItemViewController? {
        let storyboard = UIStoryboard(name: EditImageItemViewController.storyboardName(), bundle: nil)
        
        return storyboard.instantiateInitialViewController()
    }
    
    private func zoomRectangle(scale: CGFloat, center: CGPoint) -> CGRect {
        var zoomRect = CGRect.zero
        zoomRect.size.height = itemImageView.frame.size.height / scale
        zoomRect.size.width  = itemImageView.frame.size.width  / scale
        zoomRect.origin.x = max(center.x - (zoomRect.size.width / 2), 0)
        zoomRect.origin.y = max(center.y - (zoomRect.size.height / 2), 0)
        
        return zoomRect
    }
    
    @objc private func imageTapped() {
        isStatusBarHidden.toggle()
        shouldBackgroundViewDark.toggle()
        tabBarController?.tabBar.isHidden.toggle()
        navigationController?.navigationBar.isHidden.toggle()
    }
    
    @objc private func imageDoubleTapped(_ sender: UITapGestureRecognizer) {
        if itemScrollView.zoomScale == itemScrollView.minimumZoomScale {
            itemScrollView.zoom(to: zoomRectangle(scale: itemScrollView.maximumZoomScale, center: sender.location(in: sender.view)), animated: true)
        } else {
            itemScrollView.setZoomScale(itemScrollView.minimumZoomScale, animated: true)
        }
    }
}

// MARK:- UIScrollView Delegate
extension EditImageItemViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return itemImageView
    }

    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        if !isStatusBarHidden {
            isStatusBarHidden.toggle()
            shouldBackgroundViewDark.toggle()
            tabBarController?.tabBar.isHidden.toggle()
            navigationController?.navigationBar.isHidden.toggle()
        }
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        if scrollView.zoomScale > 1 {
            if let image = itemImageView.image {
                let ratioWidth = itemImageView.frame.width / image.size.width
                let ratioHeight = itemImageView.frame.height / image.size.height
                
                let ratio = ratioWidth < ratioHeight ? ratioWidth : ratioHeight
                let newWidth = image.size.width * ratio
                let newHeight = image.size.height * ratio
                
                let conditionLeft = newWidth * scrollView.zoomScale > itemImageView.frame.width
                
                let left = 0.5 * (conditionLeft ? newWidth - itemImageView.frame.width : (scrollView.frame.width - scrollView.contentSize.width))
                
                let conditionTop = newHeight * scrollView.zoomScale > itemImageView.frame.height
                
                let top = 0.5 * (conditionTop ? newHeight - itemImageView.frame.height : (scrollView.frame.height - scrollView.contentSize.height))
                
                scrollView.contentInset = UIEdgeInsets(top: top, left: left, bottom: top, right: left)
            }
        } else {
            scrollView.contentInset = .zero
        }
    }
}
