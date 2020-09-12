//
//  HomeNavigationController.swift
//  PinPhoto
//
//  Created by won heo on 2020/08/21.
//  Copyright © 2020 won heo. All rights reserved.
//

import UIKit
import YPImagePicker

class HomeNavigationController: UINavigationController {
    
    private lazy var config: YPImagePickerConfiguration = {
        var config = YPImagePickerConfiguration()
        config.showsPhotoFilters = false
        config.screens = [.library]
        config.targetImageSize = YPImageSize.cappedTo(size: view.frame.height)
        config.library.defaultMultipleSelection = false
        config.library.maxNumberOfItems = 15
        return config
    }()
    
    let addButtonView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemPink
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = false
        view.layer.cornerRadius = 25
        return view
    }()
    
    let plusImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "plus")
        imageView.tintColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presentAddButtonView()
    }
    
    override open var childForStatusBarHidden: UIViewController? { // for child vc status bar hidden
        return topViewController
    }
    
    func presentAddButtonView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(presentAddActionSheet))
        addButtonView.addGestureRecognizer(tapGesture)
        addButtonView.isUserInteractionEnabled = true
        addButtonView.addSubview(plusImageView)
        view.addSubview(addButtonView)
        prepareConstraint()
    }
    
    func dismissAddButtonView() {
        plusImageView.removeFromSuperview()
        addButtonView.removeFromSuperview()
    }
    
    private func prepareConstraint() {
        NSLayoutConstraint.activate([
            addButtonView.widthAnchor.constraint(equalToConstant: 50),
            addButtonView.heightAnchor.constraint(equalToConstant: 50),
            addButtonView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            addButtonView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -25)
        ])
        
        NSLayoutConstraint.activate([
            plusImageView.widthAnchor.constraint(equalToConstant: 30),
            plusImageView.heightAnchor.constraint(equalToConstant: 30),
            plusImageView.centerXAnchor.constraint(equalTo: addButtonView.centerXAnchor),
            plusImageView.centerYAnchor.constraint(equalTo: addButtonView.centerYAnchor)
        ])
    }
    
    @objc private func presentImagePikcer() {
        let picker = YPImagePicker(configuration: config)

        picker.didFinishPicking { [unowned picker] items, isNotSelect in
            guard let vc = SelectGroupViewController.storyboardInstance() else { return }
            
            if isNotSelect { // 사용자가 선택을 취소했을 때
                picker.dismiss(animated: true, completion: nil)
            }
            // 사용자가 선택을 완료했을 때
            vc.items = items
            picker.pushViewController(vc, animated: true)
        }

        present(picker, animated: true, completion: nil)
    }
    
    @objc private func presentAddActionSheet() {
        let actionMenu = UIAlertController(title: nil, message: "아이템 종류", preferredStyle: .actionSheet)
        
        ItemType.allCases.forEach { type in
            let action = UIAlertAction(title: type.title, style: .default, handler: { [weak self] _ in
                self?.presentAddItemType(type.value)
            })
            actionMenu.addAction(action)
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
        })

        actionMenu.addAction(cancelAction)
        present(actionMenu, animated: true)
    }
    
    private func presentaddTextItem() {
        guard let vc = CreateTextItemViewController.storyboardInstance() else {
            return
        }
        
        present(vc, animated: true)
    }
    
    private func presentAddItemType(_ type: Int) {
        switch type {
        case ItemType.image.value:
            presentImagePikcer()
        case ItemType.text.value:
            presentaddTextItem()
        default:
            break
        }
    }
}
