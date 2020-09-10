//
//  GroupViewController.swift
//  PinPhoto
//
//  Created by won heo on 2020/09/01.
//  Copyright © 2020 won heo. All rights reserved.
//

import UIKit

class GroupViewController: UIViewController {
    @IBOutlet private weak var groupTableView: UITableView!
    @IBOutlet private weak var inputTextField: UITextField!
    @IBOutlet private weak var inputViewBottom: NSLayoutConstraint!
    
    let groupViewModel = GroupViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // iOS 9 이상 부터 블록 기반의 옵저버를 제외하고, 자동으로 처리해줌.
        // deinit 에서 Observer 제거 필요 X
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardAction(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardAction(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        view.isUserInteractionEnabled = true
        
        groupTableView.dataSource = self
        groupTableView.delegate = self
        groupTableView.dragInteractionEnabled = true
        groupViewModel.load()
    }
    
    @IBAction func editButtonTapped(_ sender: UIBarButtonItem) {
        groupTableView.isEditing = !groupTableView.isEditing
        groupTableView.setEditing(groupTableView.isEditing, animated: true)
    }
    
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        guard let text = inputTextField.text, !text.isEmpty else { return }
        inputTextField.text = ""
        dismissKeyboard()
        
        groupViewModel.add(name: text)
        groupViewModel.load()
        groupTableView.reloadSections(IndexSet(0...0), with: .fade)
    }
    
    @objc private func keyboardAction(_ notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        
        guard let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
        if notification.name == UIResponder.keyboardWillShowNotification {
            let adjustmentHeight = keyboardFrame.height - view.safeAreaInsets.bottom
            inputViewBottom.constant = adjustmentHeight
        } else {
            inputViewBottom.constant = 0
        }
    }
    
    @objc private func dismissKeyboard() {
        inputTextField.resignFirstResponder()
    }
}

extension GroupViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return groupViewModel.groups.count - 1
        default:
            return 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "groupCell") else { return UITableViewCell() }
            let group = groupViewModel.groups[0]
            cell.textLabel?.text = group.name
            cell.detailTextLabel?.text = "\(group.numberOfItem)"
            cell.textLabel?.textColor = .systemPink
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "groupCell") else { return UITableViewCell() }
            let group = groupViewModel.groups[indexPath.row + 1]
            cell.textLabel?.text = group.name
            cell.detailTextLabel?.text = "\(group.numberOfItem)"
            return cell
        default:
            break
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "위젯"
        case 1:
            return "분류"
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 1 {
            return true
        } else {
            return false
        }
    }
}

extension GroupViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if sourceIndexPath.section == destinationIndexPath.section {
            groupViewModel.swap(sourceIndexPath, destinationIndexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        return sourceIndexPath.section != proposedDestinationIndexPath.section ? sourceIndexPath : proposedDestinationIndexPath
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return indexPath.section == 0 ? .none : .delete
    }
}

extension GroupViewController: GroupObserver {
    var groupIdentifier: String {
        get {
            return GroupViewController.observerName()
        }
    }
    
    func updateGroup() {
        OperationQueue.main.addOperation {
            self.groupTableView.reloadData()
        }
    }
}
