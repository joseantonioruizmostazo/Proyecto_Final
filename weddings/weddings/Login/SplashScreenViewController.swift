//
//  SplashScreenViewController.swift
//  weddings
//
//  Created by José Ruiz on 27/3/19.
//  Copyright © 2019 macos. All rights reserved.
//

import UIKit

class SplashScreenViewController: UIViewController {
    
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var bottom: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController
        
        bottom.constant = self.view.frame.height / 3 - icon.frame.height
        
        UIView.animate(withDuration: 3, animations: {
            self.view.layoutIfNeeded()
            
        }) { (true) in
            sleep(2)
            self.present(vc!, animated: true) {
            }
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        bottom.constant = size.height / 2 - icon.frame.height / 2
        
        UIView.animate(withDuration: 2) {
            self.view.layoutIfNeeded()
        }
    }
}
