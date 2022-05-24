//
//  SaveAnimateView.swift
//  StartProject-ios
//
//  Created by Stepan Kirillov on 5/24/22.
//  Copyright © 2021 TEKHNOKRATIYA. All rights reserved.
//

import UIKit

class SaveAnimateView: UIView {
    private var text = ""
    private var image: UIImage = Asset.profileImage.image
    private let boxWidth: CGFloat = 120
    private let boxHeight: CGFloat = 120
    private let boxCornerRadius: CGFloat = 10
    private let textFontSize: CGFloat = 16
    private let transformStartScale: CGFloat = 1.5
    private let duration: TimeInterval = 0.4
    
    class func animate(
        inView view: UIView,
        image: UIImage,
        text: String,
        animated: Bool
    ) {
        let hudView = SaveAnimateView()
        hudView.text = text
        hudView.image = image
        hudView.frame = view.bounds
        hudView.isOpaque = false
        view.addSubview(hudView)
        view.isUserInteractionEnabled = false
        hudView.show(animated: animated)
    }
    
    override func draw(_ rect: CGRect) {
        
        let boxRect = CGRect(x: round((bounds.size.width - boxWidth) / 2),
                             y: round((bounds.size.height - boxHeight) / 2),
                             width: boxWidth,
                             height: boxHeight)
        
        let roundedRect = UIBezierPath(roundedRect: boxRect, cornerRadius: boxCornerRadius)
        Asset.Colors.grayTextHalfTranparent.color.setFill()
        roundedRect.fill()
        
        let imageView = configureImageView()
        imageView.draw(imageView.frame)
        
        let attribs = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: textFontSize),
                       NSAttributedString.Key.foregroundColor: UIColor.white]
        let textSize = text.size(withAttributes: attribs)
        
        let textPoint = CGPoint(x: center.x - round(textSize.width / 2),
                                y: center.y - round(textSize.height / 2) + boxHeight / 4)
        text.draw(at: textPoint, withAttributes: attribs)
    }
    
    private func show(animated: Bool) {
        if animated {
            alpha = 0
            transform = CGAffineTransform(scaleX: transformStartScale, y: transformStartScale)
            
            UIView.animate(
                withDuration: duration,
                delay: 0,
                usingSpringWithDamping: 1,
                initialSpringVelocity: 1,
                options: [],
                animations: { [weak self] in
                    self?.alpha = 1
                    self?.transform = CGAffineTransform.identity
                },
                completion: { [weak self] _ in
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        self?.superview?.isUserInteractionEnabled = true
                        self?.removeFromSuperview()
                    }
                })
        }
    }
    
    private func configureImageView() -> UIImageView {
        let imageViewHeight = boxHeight / 2
        let imageViewWidth = boxHeight / 2
        let imageView = UIImageView(
            frame: CGRect(
                x: 0,
                y: 0,
                width: imageViewWidth,
                height: imageViewHeight
            )
        )
        addSubview(imageView)
        imageView.image = image
        let imageViewLeftYCoordinate = center.y - round(imageView.bounds.height / 2) - boxHeight / 8
        let imageViewLeftXCoordinate = center.x - round(imageView.bounds.width / 2)
        imageView.frame.origin = CGPoint(x: imageViewLeftXCoordinate,
                                         y: imageViewLeftYCoordinate)
        return imageView
    }
}
