//
//  ModifyViewControllerTwo.swift
//  weddings
//
//  Created by José Ruiz on 26/4/19.
//  Copyright © 2019 macos. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth

class ModifyViewControllerTwo: UIViewController {
    
    @IBOutlet weak var iconFlecha: UIImageView!
    @IBOutlet weak var messageEnlaceTextField: UITextField!
    @IBOutlet weak var dayEnlaceTextField: UITextField!
    @IBOutlet weak var hourEnlaceTextField: UITextField!
    @IBOutlet weak var placeEnlaceTextField: UITextField!
    @IBOutlet weak var adressEnlaceTextField: UITextField!
    
    // Variables datos de la boda
    public var nombresNovios: String?
    public var fechaBoda: String?
    public var invitados: String?
    public var ciudad: String?
    public var emailNovio: String?
    public var tlfNovio: String?
    public var emailNovia: String?
    public var tlfNovia: String?
    
    // Variable Pin
    public var pin: String?
    
    // Variables DocumentIDs
    public var bodaDocumentId: String?
    public var enlaceDocumentId: String?
    
    private var enlaceData : [String : Any] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        getEnlace()
        
        borderStyleTextField(textField: messageEnlaceTextField)
        borderStyleTextField(textField: dayEnlaceTextField)
        borderStyleTextField(textField: hourEnlaceTextField)
        borderStyleTextField(textField: placeEnlaceTextField)
        borderStyleTextField(textField: adressEnlaceTextField)
        
        // Initialize iconFlecha imageview as a button
        let tapIconFlecha = UITapGestureRecognizer(target: self, action: #selector(iconFlechaTapped(tapIconFlecha:)))
        iconFlecha.isUserInteractionEnabled = true
        iconFlecha.addGestureRecognizer(tapIconFlecha)
    }
    
    // Función recoger datos del enlace del usuario a través de su Pin
    func getEnlace() {
        let myGroup = DispatchGroup()
        myGroup.enter()
        
        let db = Firestore.firestore()
        db.collection("enlace").whereField("Pin", isEqualTo: pin!)
            .getDocuments() { (querySnapshot, err) in
                
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        self.enlaceDocumentId = document.documentID
                        self.enlaceData = document.data()
                        myGroup.leave()
                    }
                }
        }
        myGroup.notify(queue: .main) {
            print("Datos del enlace")
            print(self.enlaceData)
            
            // Introducir los valores del documento enlace en los textFields correspondientes
            self.messageEnlaceTextField.text = self.enlaceData["MensajeEnlace"]! as? String
            self.dayEnlaceTextField.text = self.enlaceData["DiaEnlace"]! as? String
            self.hourEnlaceTextField.text = self.enlaceData["HoraEnlace"]! as? String
            self.placeEnlaceTextField.text = self.enlaceData["LugarEnlace"]! as? String
            self.adressEnlaceTextField.text = self.enlaceData["DireccionEnlace"]! as? String
        }
    }
    
    // Función iconFlecha
    @objc func iconFlechaTapped(tapIconFlecha: UITapGestureRecognizer) {
        filtroTextFields()
        let storyboard = UIStoryboard(name: "Modify", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ModifyViewControllerThree") as! ModifyViewControllerThree
        
        // Pasar datos de la boda
        vc.nombresNovios = nombresNovios
        vc.fechaBoda = fechaBoda
        vc.invitados = invitados
        vc.ciudad = ciudad
        vc.emailNovio = emailNovio
        vc.tlfNovio = tlfNovio
        vc.emailNovia = emailNovia
        vc.tlfNovia = tlfNovia
        
        // Pasar datos del enlace
        vc.mensajeEnlace = messageEnlaceTextField.text
        vc.diaEnlace = dayEnlaceTextField.text
        vc.horaEnlace = hourEnlaceTextField.text
        vc.lugarEnlace = placeEnlaceTextField.text
        vc.direccionEnlace = adressEnlaceTextField.text
        
        // Pasar Pin
        vc.pin = pin
        
        // Pasar id de los documentos boda y enlace
        vc.bodaDocumentId = bodaDocumentId
        vc.enlaceDocumentId = enlaceDocumentId
        
        present(vc, animated: true, completion: nil)
    }
    
    // Función pintar bordes textField
    func borderStyleTextField (textField: UITextField) {
        textField.layer.borderWidth = 1.5
        textField.layer.borderColor = UIColor.init(red: 17.0 / 255.0, green: 198.0 / 255.0, blue: 213.0 / 255.0, alpha: 1.0).cgColor
        textField.layer.cornerRadius = textField.frame.size.width / 40
    }
    
    // Función comprobar campos
    func filtroTextFields() {
        if(messageEnlaceTextField.text?.isEmpty == true || dayEnlaceTextField.text?.isEmpty == true || hourEnlaceTextField.text?.isEmpty == true
            || placeEnlaceTextField.text?.isEmpty == true || adressEnlaceTextField.text?.isEmpty == true){
            
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
}
