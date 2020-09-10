//
//  HomeHeaderViewCell.swift
//  PinPhoto
//
//  Created by won heo on 2020/09/09.
//  Copyright © 2020 won heo. All rights reserved.
//

import UIKit

class HomeHeaderViewCell: UICollectionViewCell {
    @IBOutlet private weak var headerImageView: UIImageView!
    var disabledHighlightedAnimation: Bool = false

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 10
        reset()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        reset()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        animate(isHighlighted: true)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        animate(isHighlighted: false)
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        animate(isHighlighted: false)
    }
    
    private func animate(isHighlighted: Bool) {
        if disabledHighlightedAnimation {
            return
        }
        
        UIView.animate(withDuration: 0.3) {
            if isHighlighted {
                self.contentView.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            }
            else {
                self.contentView.transform = .identity
            }
        }
    }
    
    func update(at item: Item?) {
        guard let item = item else { return }
        headerImageView.image = item.contentImage?.image
    }
    
    private func reset() {
        headerImageView.image = nil
    }
    
    func freezeAnimations() {
        disabledHighlightedAnimation = true
        layer.removeAllAnimations()
    }

    func unfreezeAnimations() {
        disabledHighlightedAnimation = false
    }
}
