//
//  ModifyViewControllerOne.swift
//  weddings
//
//  Created by José Ruiz on 25/4/19.
//  Copyright © 2019 macos. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth

class ModifyViewControllerOne: UIViewController {
    
    @IBOutlet weak var coupleNamesTextField: UITextField!
    @IBOutlet weak var weddingDateTextField: UITextField!
    @IBOutlet weak var guestsTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var boyEmailTextField: UITextField!
    @IBOutlet weak var boyPhoneTextField: UITextField!
    @IBOutlet weak var girlEmailTextField: UITextField!
    @IBOutlet weak var girlPhoneTextField: UITextField!
    
    @IBOutlet weak var iconFlecha: UIImageView!
    
    private var datePicker: UIDatePicker?
    private var selectedCity: String?
    private let provincias = ["Álava","Albacete","Alicante","Almería","Asturias","Ávila","Badajoz","Barcelona","Burgos","Cáceres",
                               "Cádiz","Cantabria","Castellón","Ciudad Real","Córdoba","A Coruña","Cuenca","Gerona","Granada","Guadalajara",
                               "Guipúzcoa","Huelva","Huesca","Islas Baleares","Jaén","León","Lérida","Lugo","Madrid","Málaga","Murcia","Navarra",
                               "Ourense","Palencia","Las Palmas","Pontevedra","La Rioja","Salamanca","Segovia","Sevilla","Soria","Tarragona",
                               "Santa Cruz de Tenerife","Teruel","Toledo","Valencia","Valladolid","Vizcaya","Zamora","Zaragoza"]
    
    private var bodaData : [String : Any] = [:]
    private var userData : [String : Any] = [:]
    public var pin: String?
    public var email: String?
    public var bodaDocumentId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getPin()
        
        // TextFields Style
        borderStyleTextField(textField: coupleNamesTextField)
        borderStyleTextField(textField: weddingDateTextField)
        borderStyleTextField(textField: guestsTextField)
        borderStyleTextField(textField: cityTextField)
        borderStyleTextField(textField: boyEmailTextField)
        borderStyleTextField(textField: boyPhoneTextField)
        borderStyleTextField(textField: girlEmailTextField)
        borderStyleTextField(textField: girlPhoneTextField)
        
        // Initialize iconFlecha imageview as a button
        let tapIconFlecha = UITapGestureRecognizer(target: self, action: #selector(iconFlechaTapped(tapIconFlecha:)))
        iconFlecha.isUserInteractionEnabled = true
        iconFlecha.addGestureRecognizer(tapIconFlecha)
        
        // Initialize DatePicker
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        datePicker?.addTarget(self, action: #selector(CreateViewControllerOne.dateChanged(datePicker:)), for: .valueChanged)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(CreateViewControllerOne.viewTapped(gestureRecognizer:)))
        view.addGestureRecognizer(tapGesture)
        
        weddingDateTextField.inputView = datePicker
        
        // CityPicker
        createCityPicker()
        createToolbar()
    }
    
    // Función Recoger pin del usuario a través de su Email
    func getPin() {
        let myGroup = DispatchGroup()
        myGroup.enter()
        
        let db = Firestore.firestore()

        db.collection("usuario").whereField("Email", isEqualTo: email!)
            .getDocuments() { (querySnapshot, err) in
                
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        self.userData = document.data()
                        print("Datos del usuario")
                        print(self.userData)
                        print(self.userData["Pin"]!)
                        self.pin = self.userData["Pin"]! as? String
                        myGroup.leave()
                    }
                }
        }
        myGroup.notify(queue: .main) {
            print("Finished all requests getting pin.")
            self.getBoda()
        }
    }
    
    // Función recoger datos de la boda del usuario a través de su Pin
    func getBoda() {
        let myGroup = DispatchGroup()
        myGroup.enter()
        print("prueba")
        
        let db = Firestore.firestore()
        
        db.collection("boda").whereField("Pin", isEqualTo: pin!)
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
            
            self.coupleNamesTextField.text = self.bodaData["NombresNovios"]! as? String
            self.weddingDateTextField.text = self.bodaData["FechaBoda"]! as? String
            self.guestsTextField.text = self.bodaData["Invitados"]! as? String
            self.cityTextField.text = self.bodaData["Ciudad"]! as? String
            self.boyEmailTextField.text = self.bodaData["EmailNovio"]! as? String
            self.boyPhoneTextField.text = self.bodaData["TlfNovio"]! as? String
            self.girlEmailTextField.text = self.bodaData["EmailNovia"]! as? String
            self.girlPhoneTextField.text = self.bodaData["TlfNovia"]! as? String
        }
    }
    
    // Función pintar bordes textField
    func borderStyleTextField (textField: UITextField) {
        textField.layer.borderWidth = 1.5
        textField.layer.borderColor = UIColor.init(red: 17.0 / 255.0, green: 198.0 / 255.0, blue: 213.0 / 255.0, alpha: 1.0).cgColor
        textField.layer.cornerRadius = textField.frame.size.width / 40
    }
    
    // Funciones datePicker
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @objc func dateChanged(datePicker: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        
        weddingDateTextField.text = dateFormatter.string(from: datePicker.date)
        view.endEditing(true)
    }
    
    // Función iconFlecha
    @objc func iconFlechaTapped(tapIconFlecha: UITapGestureRecognizer) {
        
        filtroTextFields()
        let storyboard = UIStoryboard(name: "Modify", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ModifyViewControllerTwo") as! ModifyViewControllerTwo
        
        // Pasar datos de la boda
        vc.nombresNovios = coupleNamesTextField.text
        vc.fechaBoda = weddingDateTextField.text
        vc.invitados = guestsTextField.text
        vc.ciudad = cityTextField.text
        vc.emailNovio = boyEmailTextField.text
        vc.tlfNovio = boyPhoneTextField.text
        vc.emailNovia = girlEmailTextField.text
        vc.tlfNovia = girlPhoneTextField.text
        
        // Pasar id del documento boda
        vc.bodaDocumentId = bodaDocumentId
        
        // Pasar Pin
        vc.pin = pin
        
        present(vc, animated: true, completion: nil)
    }
    
    // Funciones PickerView
    func createCityPicker() {
        let cityPicker = UIPickerView()
        cityPicker.delegate = self
        
        cityTextField.inputView = cityPicker
        
        //Customizations
        cityPicker.backgroundColor = UIColor.init(red: 249.0 / 255.0, green: 228.0 / 255.0, blue: 255.0 / 255.0, alpha: 1.0)
    }
    
    func createToolbar() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        //Customizations
        toolBar.barTintColor = UIColor.init(red: 199.0 / 255.0, green: 251.0 / 255.0, blue: 255.0 / 255.0, alpha: 1.0)
        toolBar.tintColor = .black
        
        let doneButton = UIBarButtonItem(title: "Hecho", style: .plain, target: self, action: #selector(CreateViewControllerOne.dismissKeyboard))
        
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        doneButton.setTitleTextAttributes([NSAttributedString.Key.font : UIFont(name: "Noteworthy-Light", size: 20) ?? ""], for: .normal)
        
        cityTextField.inputAccessoryView = toolBar
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension ModifyViewControllerOne: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return provincias.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return provincias[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCity = provincias[row]
        cityTextField.text = selectedCity
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label: UILabel
        
        if let view = view as? UILabel {
            label = view
        } else {
            label = UILabel()
        }
        
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont(name: "Noteworthy-Light", size: 20)
        
        label.text = provincias[row]
        
        return label
    }
    
    // Función comprobar campos
    func filtroTextFields() {
        if(coupleNamesTextField.text?.isEmpty == true || weddingDateTextField.text?.isEmpty == true || guestsTextField.text?.isEmpty == true
            || cityTextField.text?.isEmpty == true || boyEmailTextField.text?.isEmpty == true || boyPhoneTextField.text?.isEmpty == true ||
            girlEmailTextField.text?.isEmpty == true || girlPhoneTextField.text?.isEmpty == true){
            
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
