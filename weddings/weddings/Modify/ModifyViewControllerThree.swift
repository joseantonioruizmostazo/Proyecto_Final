//
//  ModifyViewControllerThree.swift
//  weddings
//
//  Created by José Ruiz on 26/4/19.
//  Copyright © 2019 macos. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth

class ModifyViewControllerThree: UIViewController {
    
    @IBOutlet weak var iconFlecha: UIImageView!
    @IBOutlet weak var messageConviteTextField: UITextField!
    @IBOutlet weak var placeConviteTextField: UITextField!
    @IBOutlet weak var hourCocktailConviteTextField: UITextField!
    @IBOutlet weak var hourDinnerConviteTextField: UITextField!
    @IBOutlet weak var adressConviteTextField: UITextField!
    @IBOutlet weak var transportConviteTextField: UITextField!
    @IBOutlet weak var hourTransportConviteTextField: UITextField!
    
    
    // Variables datos de la boda
    public var nombresNovios: String?
    public var fechaBoda: String?
    public var invitados: String?
    public var ciudad: String?
    public var emailNovio: String?
    public var tlfNovio: String?
    public var emailNovia: String?
    public var tlfNovia: String?
    
    // Variables datos del enlace
    public var mensajeEnlace: String?
    public var diaEnlace: String?
    public var horaEnlace: String?
    public var lugarEnlace: String?
    public var direccionEnlace: String?
    
    // Variables DocumentIDs
    public var bodaDocumentId: String?
    public var enlaceDocumentId: String?
    public var conviteDocumentId: String?
    
    // Variable Pin
    public var pin: String?
    
    private var conviteData : [String : Any] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getConvite()
        
        print("Datos de la boda")
        print(nombresNovios!)
        print(fechaBoda!)
        print(invitados!)
        print(ciudad!)
        print(emailNovio!)
        print(tlfNovio!)
        print(emailNovia!)
        print(tlfNovia!)
        print("Datos del enlace")
        print(mensajeEnlace!)
        print(diaEnlace!)
        print(horaEnlace!)
        print(lugarEnlace!)
        print(direccionEnlace!)
        print("Datos del convite")
        print(messageConviteTextField.text!)
        print(placeConviteTextField.text!)
        print(hourCocktailConviteTextField.text!)
        print(hourDinnerConviteTextField.text!)
        print(adressConviteTextField.text!)
        print(transportConviteTextField.text!)
        print(hourTransportConviteTextField.text!)
        print("Datos del pin")
        print(pin!)
        
        
        borderStyleTextField(textField: messageConviteTextField)
        borderStyleTextField(textField: placeConviteTextField)
        borderStyleTextField(textField: hourCocktailConviteTextField)
        borderStyleTextField(textField: hourDinnerConviteTextField)
        borderStyleTextField(textField: adressConviteTextField)
        borderStyleTextField(textField: transportConviteTextField)
        borderStyleTextField(textField: hourTransportConviteTextField)
        
        // Initialize iconFlecha imageview as a button
        let tapIconFlecha = UITapGestureRecognizer(target: self, action: #selector(iconFlechaTapped(tapIconFlecha:)))
        iconFlecha.isUserInteractionEnabled = true
        iconFlecha.addGestureRecognizer(tapIconFlecha)
    }
    
    // Función recoger datos del convite del usuario a través de su Pin
    func getConvite() {
        let myGroup = DispatchGroup()
        myGroup.enter()
        
        let db = Firestore.firestore()
        db.collection("convite").whereField("Pin", isEqualTo: pin!)
            .getDocuments() { (querySnapshot, err) in
                
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        self.conviteDocumentId = document.documentID
                        self.conviteData = document.data()
                        myGroup.leave()
                    }
                }
        }
        myGroup.notify(queue: .main) {
            print("Datos del convite")
            print(self.conviteData)
            
            // Introducir los valores del documento enlace en los textFields correspondientes
            self.messageConviteTextField.text = self.conviteData["MensajeConvite"]! as? String
            self.placeConviteTextField.text = self.conviteData["LugarConvite"]! as? String
            self.hourCocktailConviteTextField.text = self.conviteData["HoraCoctelConvite"]! as? String
            self.hourDinnerConviteTextField.text = self.conviteData["HoraCenaConvite"]! as? String
            self.adressConviteTextField.text = self.conviteData["DireccionConvite"]! as? String
            self.transportConviteTextField.text = self.conviteData["TransporteConvite"]! as? String
            self.hourTransportConviteTextField.text = self.conviteData["HoraTransporteConvite"]! as? String
        }
    }
    
    // Función IConFlecha
    @objc func iconFlechaTapped(tapIconFlecha: UITapGestureRecognizer) {
        filtroTextFields()
        setBodaData()
        setEnlaceData()
        setConviteData()
        
        // Cambiar de view controller
        let storyboard = UIStoryboard(name: "Modify", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ModifyCompleteViewController") as! ModifyCompleteViewController
        vc.pin = pin
        self.present(vc, animated: true, completion: nil)
    }
    
    // Función pintar bordes textField
    func borderStyleTextField (textField: UITextField) {
        textField.layer.borderWidth = 1.5
        textField.layer.borderColor = UIColor.init(red: 17.0 / 255.0, green: 198.0 / 255.0, blue: 213.0 / 255.0, alpha: 1.0).cgColor
        textField.layer.cornerRadius = textField.frame.size.width / 40
    }
    
    // Función comprobar campos
    func filtroTextFields() {
        if(messageConviteTextField.text?.isEmpty == true || placeConviteTextField.text?.isEmpty == true || hourCocktailConviteTextField.text?.isEmpty == true
            || hourDinnerConviteTextField.text?.isEmpty == true || adressConviteTextField.text?.isEmpty == true || transportConviteTextField.text?.isEmpty == true
            || hourTransportConviteTextField.text?.isEmpty == true){
            
            mostrarToastError(controller: self, message: "", seconds: 3)
        }
    }
    
    func mostrarToastError(controller:UIViewController, message:String, seconds:Double){
        let alert = UIAlertController (title: nil, message: message, preferredStyle: .alert)
        
        alert.view.backgroundColor = UIColor.cyan
        alert.view.layer.cornerRadius = 15
        
        let messageFont = [kCTFontAttributeName: UIFont(name: "Noteworthy-Light", size: 20.0)!]
        let messageAttrString = NSMutableAttributedString(string: "Debe rellenar todos los campos", attributes: messageFont as [NSAttributedString.Key : Any])
        
        alert.setValue(messageAttrString, forKey: "attributedMessage")
        controller.present(alert, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds){
            alert.dismiss(animated: true)
        }
    }
    
    func setBodaData() {
        let db = Firestore.firestore()
        let updateBoda = db.collection("boda").document(bodaDocumentId!)
        
        updateBoda.updateData([
            "NombresNovios": nombresNovios!,
            "FechaBoda": fechaBoda!,
            "Invitados": invitados!,
            "Ciudad": ciudad!,
            "EmailNovio": emailNovio!,
            "TlfNovio": tlfNovio!,
            "EmailNovia": emailNovia!,
            "TlfNovia": tlfNovia!
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
    }
    
    func setEnlaceData() {
        let db = Firestore.firestore()
        let updateEnlace = db.collection("enlace").document(enlaceDocumentId!)
        
        updateEnlace.updateData([
            "MensajeEnlace": mensajeEnlace!,
            "DiaEnlace": diaEnlace!,
            "HoraEnlace": horaEnlace!,
            "LugarEnlace": lugarEnlace!,
            "DireccionEnlace": direccionEnlace!
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
    }
    
    func setConviteData() {
        let db = Firestore.firestore()
        let updateConvite = db.collection("convite").document(conviteDocumentId!)
        
        updateConvite.updateData([
            "MensajeConvite": messageConviteTextField.text!,
            "LugarConvite": placeConviteTextField.text!,
            "HoraCoctelConvite": hourCocktailConviteTextField.text!,
            "HoraCenaConvite": hourDinnerConviteTextField.text!,
            "DireccionConvite": adressConviteTextField.text!,
            "TransporteConvite": transportConviteTextField.text!,
            "HoraTransporteConvite": hourTransportConviteTextField.text!
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
    }
}
