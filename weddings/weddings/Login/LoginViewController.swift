//
//  LoginViewController.swift
//  weddings
//
//  Created by José Ruiz on 27/3/19.
//  Copyright © 2019 macos. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth

class LoginViewController: UIViewController {
    
    @IBOutlet weak var pinTextField: UITextField!
    @IBOutlet weak var iconFlecha: UIImageView!
    @IBOutlet weak var iconLapiz: UIImageView!
    @IBOutlet weak var iconCheck: UIImageView!
    
    private var pinData : [String : Any] = [:]
    private var pinArray: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getPines()
        
        // pinTextField Style
        pinTextField.layer.borderWidth = 1.5
        pinTextField.layer.borderColor = UIColor.init(red: 17.0 / 255.0, green: 198.0 / 255.0, blue: 213.0 / 255.0, alpha: 1.0).cgColor
        pinTextField.layer.cornerRadius = pinTextField.frame.size.width / 40
        
        // Initialize iconFlecha imageview as a button
        let tapIconFlecha = UITapGestureRecognizer(target: self, action: #selector(iconFlechaTapped(tapIconFlecha:)))
        iconFlecha.isUserInteractionEnabled = true
        iconFlecha.addGestureRecognizer(tapIconFlecha)
        
        // Initialize iconLapiz imageview as a button
        let tapIconLapiz = UITapGestureRecognizer(target: self, action: #selector(iconLapizTapped(tapIconLapiz:)))
        iconLapiz.isUserInteractionEnabled = true
        iconLapiz.addGestureRecognizer(tapIconLapiz)
        
        // Initialize iconCheck imageview as a button
        let tapIconCheck = UITapGestureRecognizer(target: self, action: #selector(iconCheckTapped(tapIconCheck:)))
        iconCheck.isUserInteractionEnabled = true
        iconCheck.addGestureRecognizer(tapIconCheck)
        
    }
    
    @objc func iconFlechaTapped(tapIconFlecha: UITapGestureRecognizer) {
        let storyboard = UIStoryboard(name: "Create", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "CreateViewController") as UIViewController
        present(vc, animated: true, completion: nil)
    }
    
    @objc func iconLapizTapped(tapIconLapiz: UITapGestureRecognizer) {
        let storyboard = UIStoryboard(name: "Modify", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ModifyViewController") as UIViewController
        present(vc, animated: true, completion: nil)
    }
    
    @objc func iconCheckTapped(tapIconCheck: UITapGestureRecognizer) {
        print(pinTextField.text!)
        
        if pinTextField.text?.isEmpty == true {
            mostrarToastError(controller: self, message: "Debe introducir un pin", seconds: 3)
        }
        
        if pinArray.contains(pinTextField.text!) {
            let storyboard = UIStoryboard(name: "Pin", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "PinMainViewController") as! PinMainViewController
            vc.pinChecked = pinTextField.text
            present(vc, animated: true, completion: nil)
            
        } else {
            mostrarToastError(controller: self, message: "El pin introducido no existe, si no recuerda el pin pregunte a los novios", seconds: 4)
        }
    }

    // Función traer pines de base de datos
    func getPines() {
        let myGroup = DispatchGroup()
        myGroup.enter()
        
        let db = Firestore.firestore()
        
        db.collection("usuario").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    self.pinData = document.data()
                    self.pinArray.append(self.pinData["Pin"] as! String)
                    print(self.pinArray)
                }
                myGroup.leave()
            }
        }
        
        myGroup.notify(queue: .main) {
            print("Finished all requests getting pin.")
            
        }
    }
   
    func mostrarToastError(controller:UIViewController, message:String, seconds:Double){
        let alert = UIAlertController (title: nil, message: message, preferredStyle: .alert)
        
        alert.view.backgroundColor = UIColor.cyan
        alert.view.layer.cornerRadius = 15
        
        let messageFont = [kCTFontAttributeName: UIFont(name: "Noteworthy-Light", size: 20.0)!]
        let messageAttrString = NSMutableAttributedString(string: message, attributes: messageFont as [NSAttributedString.Key : Any])
        
        alert.setValue(messageAttrString, forKey: "attributedMessage")
        controller.present(alert, animated: true)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds){
            alert.dismiss(animated: true)
        }
    }
}
