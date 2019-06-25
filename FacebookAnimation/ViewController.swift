//
//  ViewController.swift
//  FacebookAnimation
//
//  Created by win on 4/18/19.
//  Copyright © 2019 win. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let iconsContainerView : UIView = {
        let containerView = UIView()
        containerView.backgroundColor = .white
        
        let images = [UIImage(named: "blue_like"),UIImage(named: "red_heart"),UIImage(named: "cry_laugh"),UIImage(named: "surprised"),UIImage(named: "cry"),UIImage(named: "angry")]
        //configuration options
        let padding: CGFloat = 8
        let iconHeight: CGFloat = 50
        
        let arrangedSubViews = images.map({ (image) -> UIView in
            let imageView = UIImageView()
            imageView.image = image
            imageView.layer.cornerRadius = iconHeight / 2
            //required for hit testing
            imageView.isUserInteractionEnabled = true
            return imageView
        })
        let numIcons = CGFloat(arrangedSubViews.count)
        let iconWidth : CGFloat = numIcons * iconHeight + (numIcons + 1) * padding
        
        let stackView = UIStackView(arrangedSubviews: arrangedSubViews)
        stackView.distribution = .fillEqually
        stackView.spacing = padding
        stackView.layoutMargins = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        stackView.isLayoutMarginsRelativeArrangement = true
        
        containerView.frame = CGRect(x: 0, y: 0, width: iconWidth, height: iconHeight + 2 * padding)
        stackView.frame = containerView.frame
        
        //shadown
        containerView.layer.shadowColor = UIColor(white: 0.4, alpha: 0.4).cgColor
        containerView.layer.shadowRadius = 8
        containerView.layer.shadowOpacity = 0.5
        
        containerView.layer.cornerRadius =  containerView.frame.height / 2
        containerView.addSubview(stackView)
        
        return containerView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLongPressGesture()
    }
    fileprivate func setupLongPressGesture(){
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        view.addGestureRecognizer(longPress)
    }
    @objc func handleLongPress (gesture  : UILongPressGestureRecognizer){
        if gesture.state == .began {
            
            //tranform container box
            self.view.addSubview(iconsContainerView)
            let centerX = (view.frame.width - iconsContainerView.frame.width) / 2
            
            //alpha
            iconsContainerView.alpha = 0
            let positionY = gesture.location(in: self.view).y
            self.iconsContainerView.transform = CGAffineTransform(translationX: centerX, y: positionY)
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {[weak self] in
                self!.iconsContainerView.alpha = 1
                let positionY = gesture.location(in: self!.view).y - self!.iconsContainerView.frame.height
                self!.iconsContainerView.transform = CGAffineTransform(translationX: centerX, y: positionY)
                }, completion: nil)
            
        }else if gesture.state == .ended {
            // clear animation
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                let stackView = self.iconsContainerView.subviews.first
                stackView?.subviews.forEach({ (imageView) in
                    imageView.transform = .identity
                })
            }, completion: { (_) in
                self.iconsContainerView.removeFromSuperview()
            })
        }else if gesture.state == .changed {
            handleGestureChanged(gesture: gesture)
        }
    }
    fileprivate func handleGestureChanged(gesture : UILongPressGestureRecognizer){
        let pressLocation = gesture.location(in: self.iconsContainerView)
        let hitTestView = iconsContainerView.hitTest(pressLocation, with: nil)
        if hitTestView is UIImageView {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                let stackView = self.iconsContainerView.subviews.first
                stackView?.subviews.forEach({ (imageView) in
                    imageView.transform = .identity
                })
            }, completion: nil)
            hitTestView?.transform = CGAffineTransform(translationX: 0, y: -50)
        }
    }
}

