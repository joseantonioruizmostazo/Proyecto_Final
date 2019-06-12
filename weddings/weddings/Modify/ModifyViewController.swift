//
//  ModifyViewController.swift
//  weddings
//
//  Created by José Ruiz on 25/4/19.
//  Copyright © 2019 macos. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth
import SnackView
import RSLoadingView

class ModifyViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    @IBOutlet weak var backIconFlecha: UIImageView!
    @IBOutlet weak var iconFlecha: UIImageView!
    
    public var email: String?
    public var pin: String?
    private var userData: [String : Any] = [:]
    private var galleryDocumentsID: [String] = []
    var usuarioDocumentID: String?
    var enlaceDocumentID: String?
    var conviteDocumentID: String?
    var bodaDocumentID: String?
    var snackView: SnackView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TextFields Style
        borderStyleTextField(textField: emailTextField)
        borderStyleTextField(textField: passTextField)
        
        // Initialize iconFlecha imageview as a button
        let tapIconFlecha = UITapGestureRecognizer(target: self, action: #selector(iconFlechaTapped(tapIconFlecha:)))
        iconFlecha.isUserInteractionEnabled = true
        iconFlecha.addGestureRecognizer(tapIconFlecha)
        
        // Initialize BackIconFlecha imageview as a button
        let tapBackIconFlecha = UITapGestureRecognizer(target: self, action: #selector(backIconFlechaTapped(tapBackIconFlecha:)))
        backIconFlecha.isUserInteractionEnabled = true
        backIconFlecha.addGestureRecognizer(tapBackIconFlecha)
        
        RSLoadingView.hide(from: view)
    }
    
    // Botón flecha para loguearse
    @objc func iconFlechaTapped(tapIconFlecha: UITapGestureRecognizer) {
        loginUser(email: emailTextField.text!, password: passTextField.text!)
    }
    
    // Botón para borrar la boda y el usuario
    @IBAction func deleteWedding(_ sender: UIButton) {
        if (emailTextField.text?.isEmpty == true || passTextField.text?.isEmpty == true) {
            mostrarToastError(controller: self, message: "Debe rellenar todos los campos", seconds: 3)
        } else {
            // Después de todas las comprobaciones, si todo está OK pasará por aquí y saltará un alert pidiendo confirmación para borrar la boda y pulsando que sí la borrará.
            Auth.auth().signIn(withEmail: emailTextField.text!,password: passTextField.text!)
            { (user, error) in
                if error == nil {
                    self.snackView = self.createSnackView()
                    self.snackView?.show()
                } else {
                    self.mostrarToastError(controller: self, message: "Usuario o contraseña incorrectos", seconds: 3)
                }
            }
        }
    }
    
    // Botón para ir hacia atrás (login)
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
    
    // Función borrar boda
    func loginUserDeleteWedding(email: String, password: String) {
        if (emailTextField.text?.isEmpty == true || passTextField.text?.isEmpty == true) {
            mostrarToastError(controller: self, message: "Debe rellenar todos los campos", seconds: 3)
        } else {
            // Después de todas las comprobaciones, si todo está OK pasará por aquí y saltará un alert pidiendo confirmación para borrar la boda y pulsando que sí la borrará.
            Auth.auth().signIn(withEmail: emailTextField.text!,password: passTextField.text!)
            { (user, error) in
                if error == nil{
                    
                    //Borrar la boda tanto de base de datos como el usuario.
                    self.getPinAndUserID()
                    
                    user?.user.delete(completion: { (error) in
                        if error == nil {
                            print("***USUARIO ELIMINADO CON EXITO DEL AUTH")
                        } else {
                            print("***ERROR ELIMINAR USUARIO DEL AUTH")
                        }
                    })
                } else {
                    self.mostrarToastError(controller: self, message: "Usuario o contraseña incorrectos", seconds: 3)
                }
            }
        }
    }
    
    // Función comprobar todos los posibles errores el rellenar los campos, si no existen errores avanza a CreateViewControllerOne pasando la información al siguiente viewController
    func loginUser(email: String, password: String) {
        if (emailTextField.text?.isEmpty == true || passTextField.text?.isEmpty == true) {
            mostrarToastError(controller: self, message: "Debe rellenar todos los campos", seconds: 3)
        } else {
            // Después de todas las comprobaciones, si todo está OK pasará por aquí y deberá ir a CreateViewControllerOne pasando la información del Email y el repeatPassword
            Auth.auth().signIn(withEmail: emailTextField.text!,password: passTextField.text!)
            { (user, error) in
                if error == nil {
                    let storyboard = UIStoryboard(name: "Modify", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "ModifyViewControllerOne") as! ModifyViewControllerOne
                    vc.email = self.emailTextField.text
                    self.present(vc, animated: true, completion: nil)
                } else {
                    self.mostrarToastError(controller: self, message: "Usuario o contraseña incorrectos", seconds: 3)
                }
            }
        }
    }
    
    // Función Recoger pin del usuario a través de su Email
    func getPinAndUserID() {
        let myGroup = DispatchGroup()
        myGroup.enter()
        
        let db = Firestore.firestore()
        
        db.collection("usuario").whereField("Email", isEqualTo: emailTextField.text!)
            .getDocuments() { (querySnapshot, err) in
                
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        self.usuarioDocumentID = document.documentID
                        self.userData = document.data()
                        self.pin = self.userData["Pin"]! as? String
                    }
                }
                myGroup.leave()
        }
        myGroup.notify(queue: .main) {
            print("***Finished all requests getting pin.")
            self.getBodaID()
        }
    }
    
    // Función Recoger bodaID a través del pin
    func getBodaID() {
        let myGroup = DispatchGroup()
        myGroup.enter()
        
        let db = Firestore.firestore()
        
        db.collection("boda").whereField("Pin", isEqualTo: self.pin!)
            .getDocuments() { (querySnapshot, err) in
                
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        self.bodaDocumentID = document.documentID
                    }
                    myGroup.leave()
                }
        }
        myGroup.notify(queue: .main) {
            print("***Finished all requests getting bodaID.")
            self.getEnlaceID()
        }
    }
    
    // Función Recoger enlaceID a través del pin
    func getEnlaceID() {
        let myGroup = DispatchGroup()
        myGroup.enter()
        
        let db = Firestore.firestore()
        
        db.collection("enlace").whereField("Pin", isEqualTo: self.pin!)
            .getDocuments() { (querySnapshot, err) in
                
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        self.enlaceDocumentID = document.documentID
                    }
                    myGroup.leave()
                }
        }
        myGroup.notify(queue: .main) {
            print("***Finished all requests getting enlaceID.")
            self.getConviteID()
        }
    }
    
    // Función Recoger conviteID a través del pin
    func getConviteID() {
        let myGroup = DispatchGroup()
        myGroup.enter()
        
        let db = Firestore.firestore()
        
        db.collection("convite").whereField("Pin", isEqualTo: self.pin!)
            .getDocuments() { (querySnapshot, err) in
                
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        self.conviteDocumentID = document.documentID
                    }
                    myGroup.leave()
                }
        }
        myGroup.notify(queue: .main) {
            print("***Finished all requests getting conviteID.")
            self.getGalleryDocumentsID()
        }
    }
    
    // Función Recoger gallery documentsID
    func getGalleryDocumentsID() {
        let myGroup = DispatchGroup()
        myGroup.enter()
        
        let db = Firestore.firestore()
        db.collection("gallery").document(pin!).collection(pin!).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    //print("\(document.documentID) => \(document.data())")
                    self.galleryDocumentsID.append(document.documentID)
                    print("***")
                    print(self.galleryDocumentsID)
                }
                myGroup.leave()
            }
        }
        
        myGroup.notify(queue: .main) {
            print("***Finished all requests getting gallery documents ID.")
            self.deleteDocumentsWeddingGalleryDDBB()
        }
    }
    
    
    
    // Borra cada tabla de BBDD
    func deleteDocumentsWeddingGalleryDDBB() {
        let myGroup = DispatchGroup()
        myGroup.enter()
        
        let db = Firestore.firestore()
        
        for document in galleryDocumentsID {
            db.collection("gallery").document(pin!).collection(pin!).document(document).delete() { err in
                if let err = err {
                    print("Error removing document: \(err)")
                } else {
                    print("Document successfully removed!")
                }
            }
        }
        myGroup.leave()
        
        myGroup.notify(queue: .main) {
            print("***Finished all requests deleting documents galleryDDBB.")
            self.deleteWeddingGalleryDDBB()
        }
    }
    
    func deleteWeddingGalleryDDBB() {
        let myGroup = DispatchGroup()
        myGroup.enter()
        
        let db = Firestore.firestore()
        db.collection("gallery").document(pin!).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
            myGroup.leave()
        }
        myGroup.notify(queue: .main) {
            print("***Finished all requests deleting galleryDDBB.")
            self.deleteWeddingUsuarioDDBB()
        }
    }
    
    func deleteWeddingUsuarioDDBB() {
        let myGroup = DispatchGroup()
        myGroup.enter()
        
        let db = Firestore.firestore()
        db.collection("usuario").document(usuarioDocumentID!).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
            myGroup.leave()
        }
        myGroup.notify(queue: .main) {
            print("***Finished all requests deleting usuarioDDBB.")
            self.deleteWeddingBodaDDBB()
        }
    }
    
    func deleteWeddingBodaDDBB() {
        let myGroup = DispatchGroup()
        myGroup.enter()
        
        let db = Firestore.firestore()
        db.collection("boda").document(bodaDocumentID!).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
            myGroup.leave()
        }
        myGroup.notify(queue: .main) {
            print("***Finished all requests deleting bodaDDBB.")
            self.deleteWeddingEnlaceDDBB()
        }
    }
    
    func deleteWeddingEnlaceDDBB() {
        let myGroup = DispatchGroup()
        myGroup.enter()
        
        let db = Firestore.firestore()
        db.collection("enlace").document(enlaceDocumentID!).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
            myGroup.leave()
        }
        myGroup.notify(queue: .main) {
            print("***Finished all requests deleting enlaceDDBB.")
            self.deleteWeddingConviteDDBB()
        }
    }
    func deleteWeddingConviteDDBB() {
        let myGroup = DispatchGroup()
        myGroup.enter()
        
        let db = Firestore.firestore()
        db.collection("convite").document(conviteDocumentID!).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
            myGroup.leave()
        }
        myGroup.notify(queue: .main) {
            print("***Finished all requests deleting conviteDDBB.")
            self.snackView?.close()
            self.stopSpinner()
            self.mostrarMessageDeleteWedding(controller: self, message: "Boda borrada correctamente", seconds: 2)
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
    
    func mostrarMessageDeleteWedding(controller:UIViewController, message:String, seconds:Double){
        let alert = UIAlertController (title: nil, message: message, preferredStyle: .alert)
        
        alert.view.backgroundColor = UIColor.cyan
        alert.view.layer.cornerRadius = 15
        
        let messageFont = [kCTFontAttributeName: UIFont(name: "Noteworthy-Light", size: 20.0)!]
        let messageAttrString = NSMutableAttributedString(string: message, attributes: messageFont as [NSAttributedString.Key : Any])
        
        alert.setValue(messageAttrString, forKey: "attributedMessage")
        controller.present(alert, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds){
            alert.dismiss(animated: true)
            
            // Después de borrar la boda irá a la pantalla de login
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as UIViewController
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    // Función crear snackView
    func createSnackView() -> SnackView {
        //SVItem array
        let items: Array<SVItem>!
        
        //Define all the view you want to display
        let description = SVDescriptionItem(withDescription: "¿Estás seguro que deseas borrar el usuario junto con la boda?, si lo haces se perderán todos los datos.")
        let deleteButton = SVButtonItem(withTitle: "Borrar boda") {
            self.loginUserDeleteWedding(email: self.emailTextField.text!, password: self.passTextField.text!)
            self.startSpinner()
            print("*** SE INICIA EL BORRADO CON EL BOTON BORRAR BODA")
        }
        
        //Populate the SVItem array
        items = [description, deleteButton]
        
        //Present the alert on screen.
        return SnackView(withTitle: "¡ATENCIÓN!", andCloseButtonTitle: "Cancelar", andItems: items)
    }
}
