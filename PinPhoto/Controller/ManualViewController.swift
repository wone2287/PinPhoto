//
//  ManualViewController.swift
//  PinPhoto
//
//  Created by won heo on 2020/08/02.
//  Copyright © 2020 won heo. All rights reserved.
//

import UIKit

class ManualViewController: UIViewController {
    // MARK:- @IBOutlet Properties
    @IBOutlet private weak var manualCollectionView: UICollectionView!
    @IBOutlet private weak var manualPageControl: UIPageControl!
    
    // MARK:- Propertises
    private let assetNames: [String] = [
        "manual1", "manual2", "manual3", "manual4"
    ]
    
    private let manualTexts: [String] = [
        "먼저 아이템을 추가해주세요",
        "홈 화면에서 왼쪽으로 스크롤하고 \n위젯을 클릭해주세요",
        "사진 콕 위젯을 추가해주세요",
        "> 버튼을 누르고 사용해주세요"
    ]
    
    // MARK:- Methods
    static func storyboardInstance() -> ManualViewController? {
        let storyboard = UIStoryboard(name: ManualViewController.storyboardName(), bundle: nil)
        
        return storyboard.instantiateInitialViewController()
    }
    
    // MARK:- View Life Sycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.manualCollectionView.dataSource = self
        self.manualCollectionView.delegate = self
        self.manualPageControl.numberOfPages = assetNames.count
    }
    
    // MARK:- @IBAction Methods
    @IBAction func dismissButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK:- UICollectionView Data Source
extension ManualViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return assetNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "manualCell", for: indexPath) as? ManualCustomCell else {
            return UICollectionViewCell()
        }
        
        cell.manualImageView.image = UIImage(named: assetNames[indexPath.item])
        cell.manualTextLabel.text = manualTexts[indexPath.item]
        
        return cell
    }
}

// MARK:- UICollectionView Delegate
extension ManualViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let index = self.manualCollectionView.contentOffset.x / self.manualCollectionView.frame.size.width;
        
        self.manualPageControl.currentPage = Int(index)
    }
}

// MARK:- UICollectionView Delegate Flow Layout
extension ManualViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        let height = collectionView.bounds.height
        
        return CGSize(width: width, height: height)
    }
}