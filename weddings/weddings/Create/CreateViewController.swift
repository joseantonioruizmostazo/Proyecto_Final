//
//  CreateViewController.swift
//  weddings
//
//  Created by José Ruiz on 2/4/19.
//  Copyright © 2019 macos. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth

class CreateViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    @IBOutlet weak var repeatPassTextField: UITextField!
    @IBOutlet weak var iconFlecha: UIImageView!
    @IBOutlet weak var backIconFlecha: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TextFields Style
        borderStyleTextField(textField: emailTextField)
        borderStyleTextField(textField: passTextField)
        borderStyleTextField(textField: repeatPassTextField)
        
        // Initialize iconFlecha imageview as a button
        let tapIconFlecha = UITapGestureRecognizer(target: self, action: #selector(iconFlechaTapped(tapIconFlecha:)))
        iconFlecha.isUserInteractionEnabled = true
        iconFlecha.addGestureRecognizer(tapIconFlecha)
        
        // Initialize BackIconFlecha imageview as a button
        let tapBackIconFlecha = UITapGestureRecognizer(target: self, action: #selector(backIconFlechaTapped(tapBackIconFlecha:)))
        backIconFlecha.isUserInteractionEnabled = true
        backIconFlecha.addGestureRecognizer(tapBackIconFlecha)
    }
    
    @objc func iconFlechaTapped(tapIconFlecha: UITapGestureRecognizer) {
        createUser(email: emailTextField.text!, password: passTextField.text!)
    }
    
    @objc func backIconFlechaTapped(tapBackIconFlecha: UITapGestureRecognizer) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as UIViewController
        present(vc, animated: true, completion: nil)
    }
    
    // Función pintar bordes textField
    func borderStyleTextField (textField: UITextField) {
        textField.layer.borderWidth = 1.5
        textField.layer.borderColor = UIColor.init(red: 17.0 / 255.0, green: 198.0 / 255.0, blue: 213.0 / 255.0, alpha: 1.0).cgColor
        textField.layer.cornerRadius = textField.frame.size.width / 40
    }
    
    // Función comprobar todos los posibles errores al rellenar los campos, si no existen errores avanza a CreateViewControllerOne pasando la información al siguiente viewController
    func createUser(email: String, password: String) {
        let myGroup = DispatchGroup()
        myGroup.enter()
        let db = Firestore.firestore()
        
        db.collection("usuario").whereField("Email", isEqualTo: emailTextField.text!)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        print("\(document.documentID) => \(document.data())")
                        
                        self.mostrarToastError(controller: self, message: "El usuario ya existe en la base de datos", seconds: 3)
                    }
                    myGroup.leave()
                }
        }
        myGroup.notify(queue: .main) {
            print("Finished all requests getting pin.")
            
            if (self.emailTextField.text?.isEmpty == true || self.passTextField.text?.isEmpty == true || self.repeatPassTextField.text?.isEmpty == true) {
                self.mostrarToastError(controller: self, message: "Debe rellenar todos los campos", seconds: 3)
                
            } else if (self.passTextField.text != self.repeatPassTextField.text) {
                self.mostrarToastError(controller: self, message: "Las contraseñas no coinciden", seconds: 3)
                
            } else if (self.passTextField.text!.count < 6 || self.repeatPassTextField.text!.count < 6) {
                self.mostrarToastError(controller: self, message: "La contraseña debe tener 6 o más caracteres", seconds: 3)
                
            } else if (self.emailTextField.text?.isValidEmail == false) {
                self.mostrarToastError(controller: self, message: "El campo email no tiene el formato correcto", seconds: 3)
                
            } else {
                // Después de todas las comprobaciones, si todo está OK pasará por aquí y deberá ir a CreateViewControllerOne pasando la información del Email y el repeatPassword
                
                // Cambiar de view controller
                let storyboard = UIStoryboard(name: "Create", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "CreateViewControllerOne") as! CreateViewControllerOne
                
                // Pasar datos del usuario
                vc.email = self.emailTextField.text
                vc.password = self.passTextField.text
                self.present(vc, animated: true, completion: nil)
            }
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

extension String {
    var isValidEmail: Bool {
        let regularExpressionForEmail = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let testEmail = NSPredicate(format:"SELF MATCHES %@", regularExpressionForEmail)
        return testEmail.evaluate(with: self)
    }
}
