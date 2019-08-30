//
//  ViewController.swift
//  redenvelop
//
//  Created by chaostong on 2019/8/30.
//  Copyright © 2019 chaostong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red:0.36, green:0.79, blue:0.96, alpha:1.00)
        
        let redEnvelopButton = UIButton.init(frame: CGRect.init(x: self.view.bounds.size.width - 80, y: self.view.bounds.size.height - 120, width: 48, height: 48))
        redEnvelopButton.addTarget(self, action: #selector(openRedPacketAction), for: .touchUpInside)
        redEnvelopButton.setImage(UIImage.init(named: "red_packet"), for: .normal)
        self.view.addSubview(redEnvelopButton)
    }

    @objc func openRedPacketAction() {
        let red = RedEnvelopView.init()
        red.callBackClosure = {
            let vc = UIViewController.init()
            vc.view.backgroundColor = .white
            self.navigationController?.pushViewController(vc, animated: false)
        }
    }
}

