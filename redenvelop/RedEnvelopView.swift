//
//  RedEnvelopView.swift
//  redenvelop
//
//  Created by chaostong on 2019/8/30.
//  Copyright © 2019 chaostong. All rights reserved.
//

import Foundation
import UIKit

class RedEnvelopView: UIViewController {
    
    var callBackClosure: (() -> ())? = nil
    
    lazy var alertWindow: UIWindow = {
        let alertWindow = UIWindow.init(frame: UIScreen.main.bounds)
        alertWindow.windowLevel = UIWindow.Level.alert
        alertWindow.backgroundColor = UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.5)
        alertWindow.makeKeyAndVisible()
        alertWindow.rootViewController = self
        return alertWindow
    }()
    
    lazy var backgroundTop: UIImageView = {
        let image = UIImage(named: "redenvelop_top")!
        let width = UIScreen.main.bounds.width - 32*2
        let height = width * (image.size.height / image.size.width)
        let iv = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: width, height: height))
        iv.image = image
        return iv
    }()
    
    lazy var backgroundBottom: UIImageView = {
        let image = UIImage(named: "redenvelop_bottom")!
        let width = UIScreen.main.bounds.width - 32*2
        let height = width * (image.size.height / image.size.width)
        let iv = UIImageView.init(frame: CGRect.init(x: 0, y: self.backgroundTop.frame.height - 60, width: width, height: height))
        iv.image = image
        return iv
    }()
    
    lazy var backgroundImageView: UIView = {
        let image = UIImage.init(named: "redpacket_bg")!
        let width = UIScreen.main.bounds.width - 32*2
        let height = width * (image.size.height / image.size.width)
        let iv = UIView.init(frame: CGRect.init(x: 32, y: UIScreen.main.bounds.height/2 - height/2, width: width, height: height))
//        iv.image = image
        iv.transform = CGAffineTransform.init(scaleX: 0.05, y: 0.05)
        UIView.animate(withDuration: 0.15, animations: {
            iv.transform = CGAffineTransform.init(scaleX: 1.05, y: 1.05)
        }, completion: { (finish) in
            UIView.animate(withDuration: 0.15, animations: {
                iv.transform = CGAffineTransform.init(scaleX: 0.95, y: 0.95)
            }, completion: { (finsh) in
                UIView.animate(withDuration: 0.15, animations: {
                    iv.transform = CGAffineTransform.init(scaleX: 1, y: 1)
                })
            })
        })
        return iv
    }()
    
    lazy var openButton: UIButton = {
        let btn = UIButton.init(frame: CGRect.init(x: self.backgroundImageView.frame.size.width/2-50, y: self.backgroundImageView.frame.size.height/2, width: 100, height: 100))
        btn.addTarget(self, action: #selector(openRedPacketAction), for: .touchUpInside)
        btn.setImage(UIImage(named: "redpacket_open_btn"), for: .normal)
        btn.layer.zPosition = 100
        return btn
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        
        self.alertWindow.addSubview(self.view)
        self.alertWindow.addSubview(backgroundImageView)
        backgroundImageView.addSubview(backgroundTop)
        backgroundImageView.insertSubview(backgroundBottom, belowSubview: backgroundTop)
        backgroundImageView.addSubview(openButton)
        
        let tapGes = UITapGestureRecognizer.init(target: self, action: #selector(closeViewAction))
        tapGes.delegate = self
        self.view.addGestureRecognizer(tapGes)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func closeViewAction() {
        UIView.animate(withDuration: 0.2, animations: {
            self.backgroundImageView.transform = CGAffineTransform.init(scaleX: 0.2, y: 0.2)
        }) { (finished) in
            UIView.animate(withDuration: 0.08, animations: {
                self.backgroundImageView.transform = CGAffineTransform.init(scaleX: 0.25, y: 0.25)
            }, completion: { (finished) in
                self.alertWindow.removeFromSuperview()
                self.alertWindow.rootViewController = nil
            })
        }
    }
    
    @objc func openRedPacketAction() {
        openButton.isEnabled = false
        self.view.isUserInteractionEnabled = false
        
        self.callBackClosure!()
        openButton.layer.add(confirmViewRotateInfo(), forKey: "transform")
    }
    
    func confirmViewRotateInfo() -> CAKeyframeAnimation {
        let theAnimation = CAKeyframeAnimation(keyPath: "transform")
        theAnimation.values = [NSValue.init(caTransform3D: CATransform3DMakeRotation(0, 0, 0.5, 0)),
        NSValue.init(caTransform3D: CATransform3DMakeRotation(3.13, 0, 0.5, 0)),
        NSValue.init(caTransform3D: CATransform3DMakeRotation(6.28, 0, 0.5, 0))]
        theAnimation.isCumulative = true
        theAnimation.duration = 0.4
        theAnimation.repeatCount = 3
        theAnimation.isRemovedOnCompletion = true
        theAnimation.fillMode = .forwards
        theAnimation.delegate = self
        return theAnimation
    }
    
}


extension RedEnvelopView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if openButton.point(inside: touch.location(in: openButton), with: nil) {
            openRedPacketAction()
            return false
        }
        return !backgroundImageView.point(inside: touch.location(in: backgroundImageView), with: nil)
    }
}
//ios 8 适配
//#if __IPHONE_OS_VERSION_MAX_ALLOWED < 100000
//// CAAnimationDelegate is not available before iOS 10 SDK
//@interface WSRedPacketView ()<UIGestureRecognizerDelegate>
//#else
extension RedEnvelopView: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if (flag) {
            self.openButton.isHidden = true
            UIView.animate(withDuration: 0.5, animations: {
                self.openButton.isHidden = true
                self.backgroundTop.center.y -= self.view.bounds.height
                self.backgroundBottom.center.y += self.view.bounds.height
            }) { (finished) in
                self.alertWindow.removeFromSuperview()
                self.alertWindow.rootViewController = nil
            }
        }
    }
}

func delay(_ delay:Double, closure:@escaping ()->()) {
    DispatchQueue.main.asyncAfter(
        deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
}
