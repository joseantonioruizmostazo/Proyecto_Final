//
//  CreateViewControllerThree.swift
//  weddings
//
//  Created by José Ruiz on 7/4/19.
//  Copyright © 2019 macos. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth
import RSLoadingView

class CreateViewControllerThree: UIViewController {
    
    @IBOutlet weak var iconFlecha: UIImageView!
    @IBOutlet weak var messageConviteTextField: UITextField!
    @IBOutlet weak var placeConviteTextField: UITextField!
    @IBOutlet weak var hourCocktailConviteTextField: UITextField!
    @IBOutlet weak var hourDinnerConviteTextField: UITextField!
    @IBOutlet weak var adressConviteTextField: UITextField!
    @IBOutlet weak var transportConviteTextField: UITextField!
    @IBOutlet weak var hourTransportConviteTextField: UITextField!
    
    private var pinData : [String : Any] = [:]
    private var pinArray: [String] = []
    public var emailLow: String?
    
    // Variables Datos del usuario
    public var email: String?
    public var password: String?
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getPines()
        
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
        
        RSLoadingView.hide(from: view)
    }
    
    // Función IConFlecha
    @objc func iconFlechaTapped(tapIconFlecha: UITapGestureRecognizer) {
        filtroTextFields()
        startSpinner()
        createUser(email: email!, password: password!)
        
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
    
    // Funcion Custom spinner start indications
    func startSpinner() {
        let loadingView = RSLoadingView(effectType: RSLoadingView.Effect.twins)
        loadingView.mainColor = .cyan
        loadingView.shouldDimBackground = true
        loadingView.dimBackgroundColor = UIColor.black.withAlphaComponent(0.6)
        loadingView.isBlocking = true
        loadingView.shouldTapToDismiss = false
        loadingView.show(on: view)
    }
    
    // Funcion Custom spinner stop indications
    func stopSpinner() {
        RSLoadingView.hide(from: view)
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
    
    // Función generar PIN
    func randomPin(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    // Función createUser
    func createUser(email: String, password: String) {
        emailLow = email.lowercased()
        Auth.auth().createUser(withEmail: emailLow ?? "", password: password) { (result, error) in
            if (error == nil) {
                // User created
                print("User created")
                // Sign in user
                self.signInUser(email: self.emailLow ?? "", password: password)
            } else {
                print(error?.localizedDescription) // Email,contraseña no válidos o usuario en uso
            }
        }
    }
    
    // Función singInUser
    func signInUser(email: String, password: String) {
        Auth.auth().signIn(withEmail: emailLow ?? "", password: password) { (user, error) in
            if error == nil {
                // Signed in
                print("User signed in")
                
                var pin = ""
                repeat {
                    // Generar pin
                    pin = self.randomPin(length: 9)
                } while (self.pinArray.contains(pin))

                let db = Firestore.firestore()
                
                db.collection("usuario").addDocument(data: ["Pin" : pin, "Email" : self.emailLow])
                db.collection("boda").addDocument(data: ["Pin" : pin, "NombresNovios" : self.nombresNovios!, "FechaBoda" : self.fechaBoda!, "Invitados" : self.invitados!, "Ciudad" : self.ciudad!, "EmailNovio" : self.emailNovio!, "TlfNovio" : self.tlfNovio!, "EmailNovia" : self.emailNovia!, "TlfNovia" : self.tlfNovia!])
                db.collection("enlace").addDocument(data: ["Pin" : pin, "MensajeEnlace" : self.mensajeEnlace!, "DiaEnlace" : self.diaEnlace!, "HoraEnlace" : self.horaEnlace!, "LugarEnlace" : self.lugarEnlace!, "DireccionEnlace" : self.direccionEnlace!])
                db.collection("convite").addDocument(data: ["Pin" : pin, "MensajeConvite" : self.messageConviteTextField.text!, "LugarConvite" : self.placeConviteTextField.text!, "HoraCoctelConvite" : self.hourCocktailConviteTextField.text!, "HoraCenaConvite" : self.hourDinnerConviteTextField.text!, "DireccionConvite" : self.adressConviteTextField.text!, "TransporteConvite" : self.transportConviteTextField.text!, "HoraTransporteConvite" : self.hourTransportConviteTextField.text!])
                
                self.stopSpinner()
                
                // Cambiar de view controller
                let storyboard = UIStoryboard(name: "Create", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "CreateCompleteViewController") as! CreateCompleteViewController
                vc.pin = pin
                self.present(vc, animated: true, completion: nil)
                
            } else if (error?._code == AuthErrorCode.userNotFound.rawValue) {
                self.stopSpinner()
                self.createUser(email: self.emailLow ?? "", password: password)
            } else {
                self.stopSpinner()
                print(error)
                print(error?.localizedDescription)
            }
        }
    }
}
