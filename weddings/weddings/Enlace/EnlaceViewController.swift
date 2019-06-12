//
//  EnlaceViewController.swift
//  weddings
//
//  Created by José Ruiz on 7/5/19.
//  Copyright © 2019 macos. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth

class EnlaceViewController: UIViewController {
    
    
    @IBOutlet weak var backIconFlecha: UIImageView!
    @IBOutlet weak var messageEnlace: UILabel!
    @IBOutlet weak var dayEnlace: UILabel!
    @IBOutlet weak var hourEnlace: UILabel!
    @IBOutlet weak var placeEnlace: UILabel!
    @IBOutlet weak var adressEnlace: UILabel!
    @IBOutlet weak var coupleNames: UILabel!
    
    public var pinChecked: String?
    private var enlaceData : [String : Any] = [:]
    public var enlaceDocumentId : String?
    public var nombresNovios : String?

    override func viewDidLoad() {
        super.viewDidLoad()
        getEnlace()
        messageEnlaceStyle()
        
        // Initialize BackIconFlecha imageview as a button
        let tapBackIconFlecha = UITapGestureRecognizer(target: self, action: #selector(backIconFlechaTapped(tapBackIconFlecha:)))
        backIconFlecha.isUserInteractionEnabled = true
        backIconFlecha.addGestureRecognizer(tapBackIconFlecha)
    }
    
    // Función volver al PinMainViewController
    @objc func backIconFlechaTapped(tapBackIconFlecha: UITapGestureRecognizer) {
        let storyboard = UIStoryboard(name: "Pin", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "PinMainViewController") as! PinMainViewController
        vc.pinChecked = pinChecked
        present(vc, animated: true, completion: nil)
    }
    
    // Función recoger datos del enlace del usuario a través de su Pin
    func getEnlace() {
        let myGroup = DispatchGroup()
        myGroup.enter()
        
        let db = Firestore.firestore()
        
        db.collection("enlace").whereField("Pin", isEqualTo: pinChecked!)
            .getDocuments() { (querySnapshot, err) in
                
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        self.enlaceDocumentId = document.documentID
                        print("ID del documento enlace")
                        print(self.enlaceDocumentId!)
                        self.enlaceData = document.data()
                        myGroup.leave()
                    }
                }
        }
        myGroup.notify(queue: .main) {
            print("Finished all requests getting enlaceData.")
            print("Datos del enlace")
            print(self.enlaceData)
            
            // Introducir los valores del documento enlace en los labels correspondientes
            self.messageEnlace.text = self.enlaceData["MensajeEnlace"]! as? String
            self.messageEnlace.text = self.messageEnlace.text?.uppercased()
            self.dayEnlace.text = self.enlaceData["DiaEnlace"]! as? String
            self.dayEnlace.text = self.dayEnlace.text?.uppercased()
            self.hourEnlace.text = self.enlaceData["HoraEnlace"]! as? String
            self.hourEnlace.text = self.hourEnlace.text?.uppercased()
            self.placeEnlace.text = self.enlaceData["LugarEnlace"]! as? String
            self.placeEnlace.text = self.placeEnlace.text?.uppercased()
            self.adressEnlace.text = self.enlaceData["DireccionEnlace"]! as? String
            self.adressEnlace.text = self.adressEnlace.text?.uppercased()
            self.coupleNames.text = self.nombresNovios
        }
    }
    
    // Función estilo messageEnlace
    func messageEnlaceStyle() {
        let attributedString = NSMutableAttributedString(string: messageEnlace.text!)
        
        // *** Create instance of `NSMutableParagraphStyle`
        let paragraphStyle = NSMutableParagraphStyle()
        
        // *** set LineSpacing property in points ***
        paragraphStyle.lineSpacing = 8 // Whatever line spacing you want in points
        
        // *** Apply attribute to string ***
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        
        // *** Set Attributed String to your label ***
        messageEnlace.attributedText = attributedString
        messageEnlace.textAlignment = .center
    }
}
