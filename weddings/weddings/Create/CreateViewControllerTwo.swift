//
//  CreateViewControllerTwo.swift
//  weddings
//
//  Created by José Ruiz on 5/4/19.
//  Copyright © 2019 macos. All rights reserved.
//

import UIKit

class CreateViewControllerTwo: UIViewController {
    
    @IBOutlet weak var iconFlecha: UIImageView!
    @IBOutlet weak var messageEnlaceTextField: UITextField!
    @IBOutlet weak var dayEnlaceTextField: UITextField!
    @IBOutlet weak var hourEnlaceTextField: UITextField!
    @IBOutlet weak var placeEnlaceTextField: UITextField!
    @IBOutlet weak var adressEnlaceTextField: UITextField!
    
    // Variable datos del usuario
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    // Función iconFlecha
    @objc func iconFlechaTapped(tapIconFlecha: UITapGestureRecognizer) {
        filtroTextFields()
        let storyboard = UIStoryboard(name: "Create", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "CreateViewControllerThree") as! CreateViewControllerThree
        
        // Pasar datos del usuario
        vc.email = email
        vc.password = password
        
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
