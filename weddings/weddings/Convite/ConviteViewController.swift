//
//  ConviteViewController.swift
//  weddings
//
//  Created by José Ruiz on 7/5/19.
//  Copyright © 2019 macos. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth

class ConviteViewController: UIViewController {
    
    @IBOutlet weak var backIconFlecha: UIImageView!
    @IBOutlet weak var coupleNames: UILabel!
    @IBOutlet weak var messageConvite: UILabel!
    @IBOutlet weak var placeConvite: UILabel!
    @IBOutlet weak var hourCoctelConvite: UILabel!
    @IBOutlet weak var hourDinnerConvite: UILabel!
    @IBOutlet weak var adressConvite: UILabel!
    @IBOutlet weak var transportConvite: UILabel!
    @IBOutlet weak var hourTransportConvite: UILabel!
    
    
    public var pinChecked: String?
    private var conviteData : [String : Any] = [:]
    public var conviteDocumentId : String?
    public var nombresNovios : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getConvite()
        messageConviteStyle()
        
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
    
    // Función recoger datos del convite del usuario a través de su Pin
    func getConvite() {
        let myGroup = DispatchGroup()
        myGroup.enter()
        
        let db = Firestore.firestore()
        
        db.collection("convite").whereField("Pin", isEqualTo: pinChecked!)
            .getDocuments() { (querySnapshot, err) in
                
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        self.conviteDocumentId = document.documentID
                        print("ID del documento convite")
                        print(self.conviteDocumentId!)
                        self.conviteData = document.data()
                        myGroup.leave()
                    }
                }
        }
        myGroup.notify(queue: .main) {
            print("Finished all requests getting conviteData.")
            print("Datos del convite")
            print(self.conviteData)
            
            // Introducir los valores del documento convite en los labels correspondientes
            self.messageConvite.text = self.conviteData["MensajeConvite"]! as? String
            self.messageConvite.text = self.messageConvite.text?.uppercased()
            
            self.placeConvite.text = self.conviteData["LugarConvite"]! as? String
            self.placeConvite.text = self.placeConvite.text?.uppercased()
            
            self.hourCoctelConvite.text = self.conviteData["HoraCoctelConvite"]! as? String
            self.hourCoctelConvite.text = self.hourCoctelConvite.text?.uppercased()
            
            self.hourDinnerConvite.text = self.conviteData["HoraCenaConvite"]! as? String
            self.hourDinnerConvite.text = self.hourDinnerConvite.text?.uppercased()
            
            self.adressConvite.text = self.conviteData["DireccionConvite"]! as? String
            self.adressConvite.text = self.adressConvite.text?.uppercased()
            
            self.transportConvite.text = self.conviteData["TransporteConvite"]! as? String
            self.transportConvite.text = self.transportConvite.text?.uppercased()
            
            self.hourTransportConvite.text = self.conviteData["HoraTransporteConvite"]! as? String
            self.hourTransportConvite.text = self.hourTransportConvite.text?.uppercased()
            
            self.coupleNames.text = self.nombresNovios
        }
    }
    
    // Función estilo messageFotos
    func messageConviteStyle() {
        let attributedString = NSMutableAttributedString(string: messageConvite.text!)
        
        // *** Create instance of `NSMutableParagraphStyle`
        let paragraphStyle = NSMutableParagraphStyle()
        
        // *** set LineSpacing property in points ***
        paragraphStyle.lineSpacing = 8 // Whatever line spacing you want in points
        
        // *** Apply attribute to string ***
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        
        // *** Set Attributed String to your label ***
        messageConvite.attributedText = attributedString
        messageConvite.textAlignment = .center
    }
}
