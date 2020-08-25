//
//  EditImageItemViewController.swift
//  PinPhoto
//
//  Created by won heo on 2020/07/31.
//  Copyright © 2020 won heo. All rights reserved.
//

import UIKit

class EditImageItemViewController: UIViewController {
    // MARK:- @IBOutlet Properties
    @IBOutlet private weak var itemScrollView: UIScrollView!
    @IBOutlet private weak var itemImageView: UIImageView!
    
    // MARK:- Propertises
    var itemViewModel: ItemViewModel?
    var item: Item?
    
    private var shouldBackgroundViewDark: Bool = false {
        didSet {
            if shouldBackgroundViewDark {
                view.backgroundColor = UIColor.black
            } else {
                view.backgroundColor = UIColor.systemBackground
            }
        }
    }
    
    private var isStatusBarHidden: Bool = false {
        didSet {
            setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return isStatusBarHidden
    }

    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return UIStatusBarAnimation.slide
    }
    
    // MARk:- View Life Sycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = itemViewModel?.creationData(date: item?.updateDate)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        self.itemImageView.addGestureRecognizer(tapGesture)

        self.itemImageView.isUserInteractionEnabled = true
        self.itemImageView.image = itemViewModel?.convertDataToImage(data: item?.contentImage)
        
        self.itemScrollView.alwaysBounceVertical = false
        self.itemScrollView.alwaysBounceHorizontal = false
        
        self.itemScrollView.minimumZoomScale = 1.0
        self.itemScrollView.maximumZoomScale = 3.0
        self.itemScrollView.contentInsetAdjustmentBehavior = .never
        self.itemScrollView.delegate = self
    }

    // MARK:- Methods
    static func storyboardInstance() -> EditImageItemViewController? {
        let storyboard = UIStoryboard(name: EditImageItemViewController.storyboardName(), bundle: nil)
        
        return storyboard.instantiateInitialViewController()
    }
    
    @objc private func imageTapped() {
        isStatusBarHidden.toggle()
        shouldBackgroundViewDark.toggle()
        tabBarController?.tabBar.isHidden.toggle()
        navigationController?.navigationBar.isHidden.toggle()
        navigationController?.interactivePopGestureRecognizer?.isEnabled.toggle()
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
                
                let conditionLeft = newWidth*scrollView.zoomScale > itemImageView.frame.width
                
                let left = 0.5 * (conditionLeft ? newWidth - itemImageView.frame.width : (scrollView.frame.width - scrollView.contentSize.width))
                
                let conditionTop = newHeight*scrollView.zoomScale > itemImageView.frame.height
                
                let top = 0.5 * (conditionTop ? newHeight - itemImageView.frame.height : (scrollView.frame.height - scrollView.contentSize.height))
                
                scrollView.contentInset = UIEdgeInsets(top: top, left: left, bottom: top, right: left)
            }
        } else {
            scrollView.contentInset = .zero
        }
    }
}
