//
//  CreateCompleteViewController.swift
//  weddings
//
//  Created by José Ruiz on 8/4/19.
//  Copyright © 2019 macos. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth

class CreateCompleteViewController: UIViewController {
    
    @IBOutlet weak var iconFlecha: UIImageView!
    @IBOutlet weak var pinLabel: UILabel!
    
    public var pin: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        pinLabel.text = pin
        
        // Initialize iconFlecha imageview as a button
        let tapIconFlecha = UITapGestureRecognizer(target: self, action: #selector(iconFlechaTapped(tapIconFlecha:)))
        iconFlecha.isUserInteractionEnabled = true
        iconFlecha.addGestureRecognizer(tapIconFlecha)
    }
    
    // Función IConFlecha
    @objc func iconFlechaTapped(tapIconFlecha: UITapGestureRecognizer) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as UIViewController
        present(vc, animated: true, completion: nil)
    }
}

