//
//  ContactoViewController.swift
//  weddings
//
//  Created by José Ruiz on 8/5/19.
//  Copyright © 2019 macos. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth

class ContactoViewController: UIViewController {

    @IBOutlet weak var backIconFlecha: UIImageView!
    @IBOutlet weak var coupleNames: UILabel!
    @IBOutlet weak var boyEmail: UILabel!
    @IBOutlet weak var boyPhone: UILabel!
    @IBOutlet weak var girlEmail: UILabel!
    @IBOutlet weak var girlPhone: UILabel!
    @IBOutlet weak var messageContacto: UILabel!
    
    public var pinChecked: String?
    private var bodaData : [String : Any] = [:]
    public var bodaDocumentId : String?
    public var nombresNovios : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messageContactoStyle()
        getContacto()
        
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
    
    // Función recoger datos de contacto del usuario a través de su Pin
    func getContacto() {
        let myGroup = DispatchGroup()
        myGroup.enter()
        
        let db = Firestore.firestore()
        
        db.collection("boda").whereField("Pin", isEqualTo: pinChecked!)
            .getDocuments() { (querySnapshot, err) in
                
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        self.bodaDocumentId = document.documentID
                        print("ID del documento boda")
                        print(self.bodaDocumentId!)
                        self.bodaData = document.data()
                        myGroup.leave()
                    }
                }
        }
        myGroup.notify(queue: .main) {
            print("Finished all requests getting bodaData.")
            print("Datos de la boda")
            print(self.bodaData)
            
            // Introducir los valores del documento convite en los labels correspondientes
            self.boyEmail.text = self.bodaData["EmailNovio"]! as? String
            self.boyEmail.text = self.boyEmail.text?.uppercased()
            
            self.boyPhone.text = self.bodaData["TlfNovio"]! as? String
            self.boyPhone.text = self.boyPhone.text?.uppercased()
            
            self.girlEmail.text = self.bodaData["EmailNovia"]! as? String
            self.girlEmail.text = self.girlEmail.text?.uppercased()
            
            self.girlPhone.text = self.bodaData["TlfNovia"]! as? String
            self.girlPhone.text = self.girlPhone.text?.uppercased()
            
            self.coupleNames.text = self.nombresNovios
        }
    }
    
    // Función estilo message contacto
    func messageContactoStyle() {
        let attributedString = NSMutableAttributedString(string: messageContacto.text!)
        
        // *** Create instance of `NSMutableParagraphStyle`
        let paragraphStyle = NSMutableParagraphStyle()
        
        // *** set LineSpacing property in points ***
        paragraphStyle.lineSpacing = 8 // Whatever line spacing you want in points
        
        // *** Apply attribute to string ***
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        
        // *** Set Attributed String to your label ***
        messageContacto.attributedText = attributedString
        messageContacto.textAlignment = .center
    }
}
