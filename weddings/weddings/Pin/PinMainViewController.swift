//
//  PinMainViewController.swift
//  weddings
//
//  Created by José Ruiz on 29/4/19.
//  Copyright © 2019 macos. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth

class PinMainViewController: UIViewController {
    
    @IBOutlet weak var backIconFlecha: UIImageView!
    @IBOutlet weak var iconEnlace: UIImageView!
    @IBOutlet weak var iconConvite: UIImageView!
    @IBOutlet weak var iconCamara: UIImageView!
    @IBOutlet weak var iconPhoneMail: UIImageView!
    @IBOutlet weak var coupleNamesLabel: UILabel!
    
    private var bodaData: [String : Any] = [:]
    public var bodaDocumentId: String?
    public var pinChecked: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getBoda()
        
        // Initialize BackIconFlecha imageview as a button
        let tapBackIconFlecha = UITapGestureRecognizer(target: self, action: #selector(backIconFlechaTapped(tapBackIconFlecha:)))
        backIconFlecha.isUserInteractionEnabled = true
        backIconFlecha.addGestureRecognizer(tapBackIconFlecha)
        
        // Initialize iconEnlace imageview as a button
        let tapIconEnlace = UITapGestureRecognizer(target: self, action: #selector(iconEnlaceTapped(tapIconEnlace:)))
        iconEnlace.isUserInteractionEnabled = true
        iconEnlace.addGestureRecognizer(tapIconEnlace)
        
        // Initialize iconConvite imageview as a button
        let tapIconConvite = UITapGestureRecognizer(target: self, action: #selector(iconConviteTapped(tapIconConvite:)))
        iconConvite.isUserInteractionEnabled = true
        iconConvite.addGestureRecognizer(tapIconConvite)
        
        // Initialize iconCamara imageview as a button
        let tapIconCamara = UITapGestureRecognizer(target: self, action: #selector(iconCamaraTapped(tapIconCamara:)))
        iconCamara.isUserInteractionEnabled = true
        iconCamara.addGestureRecognizer(tapIconCamara)
        
        // Initialize iconPhoneMail imageview as a button
        let tapIconPhoneMail = UITapGestureRecognizer(target: self, action: #selector(iconPhoneMailTapped(tapIconPhoneMail:)))
        iconPhoneMail.isUserInteractionEnabled = true
        iconPhoneMail.addGestureRecognizer(tapIconPhoneMail)
    }
    
    // Función recoger datos de la boda del usuario a través de su Pin
    func getBoda() {
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
            
            // Introducir los valores del documento boda en los textFields correspondientes
            self.coupleNamesLabel.text = self.bodaData["NombresNovios"]! as? String
            self.coupleNamesLabel.text = self.coupleNamesLabel.text?.uppercased()
        }
    }
    
    // Función volver al Main
    @objc func backIconFlechaTapped(tapBackIconFlecha: UITapGestureRecognizer) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as UIViewController
        present(vc, animated: true, completion: nil)
    }
    
    // Función ir a información del enlace
    @objc func iconEnlaceTapped(tapIconEnlace: UITapGestureRecognizer) {
        let storyboard = UIStoryboard(name: "Enlace", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "EnlaceViewController") as! EnlaceViewController
        vc.pinChecked = pinChecked
        vc.nombresNovios = coupleNamesLabel.text
        present(vc, animated: true, completion: nil)
    }
    
    // Función ir a información del convite
    @objc func iconConviteTapped(tapIconConvite: UITapGestureRecognizer) {
        let storyboard = UIStoryboard(name: "Convite", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ConviteViewController") as! ConviteViewController
        vc.pinChecked = pinChecked
        vc.nombresNovios = coupleNamesLabel.text
        present(vc, animated: true, completion: nil)
    }
    
    // Función ir a la galería de fotos
    @objc func iconCamaraTapped(tapIconCamara: UITapGestureRecognizer) {
        let storyboard = UIStoryboard(name: "Fotos", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "FotosViewController") as! FotosViewController
        vc.pinChecked = pinChecked
        vc.nombresNovios = coupleNamesLabel.text
        present(vc, animated: true, completion: nil)
    }
    
    // Función ir a información de los novios
    @objc func iconPhoneMailTapped(tapIconPhoneMail: UITapGestureRecognizer) {
        let storyboard = UIStoryboard(name: "Contacto", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ContactoViewController") as! ContactoViewController
        vc.pinChecked = pinChecked
        vc.nombresNovios = coupleNamesLabel.text
        present(vc, animated: true, completion: nil)
    }
}
