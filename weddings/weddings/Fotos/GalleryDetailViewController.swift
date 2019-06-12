//
//  GalleryDetailViewController.swift
//  weddings
//
//  Created by José Ruiz on 29/5/19.
//  Copyright © 2019 macos. All rights reserved.
//

import UIKit
import SnackView
import Firebase
import FirebaseFirestore
import FirebaseAuth

class GalleryDetailViewController: UIViewController {

    @IBOutlet weak var backIconFlecha: UIImageView!
    @IBOutlet weak var coupleNames: UILabel!
    @IBOutlet weak var imageDetail: UIImageView!
    @IBOutlet weak var trashIcon: UIImageView!
    
    var image = UIImage()
    public var pinChecked: String?
    public var nombresNovios: String?
    public var urlImagen: String?
    public var imageDocumentID: String?
    var snackView: SnackView?
    var arrUserData: [String : Any] = [:]
    var confirmEmail: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUrls()
        getEmail()
        
        // Initialize BackIconFlecha imageview as a button
        let tapBackIconFlecha = UITapGestureRecognizer(target: self, action: #selector(backIconFlechaTapped(tapBackIconFlecha:)))
        backIconFlecha.isUserInteractionEnabled = true
        backIconFlecha.addGestureRecognizer(tapBackIconFlecha)
        
        // Initialize trashIcon imageview as a button
        let tapTrashIcon = UITapGestureRecognizer(target: self, action: #selector(trashIconTapped(tapTrashIcon:)))
        trashIcon.isUserInteractionEnabled = true
        trashIcon.addGestureRecognizer(tapTrashIcon)
        
        imageDetail.image = image
        coupleNames.text = nombresNovios
    }
    
    @IBAction func savePhotoClick(_ sender: UIButton) {
        saveImgOnPhone()
    }
    
    // Función crear snackView
    func createSnackView() -> SnackView {
        //SVItem array
        let items: Array<SVItem>!
        
        //Define all the view you want to display
        let description = SVDescriptionItem(withDescription: "Sólo los novios pueden borrar fotos, utilizando el email y la contraseña.")
        let email = SVTextFieldItem(withPlaceholder: "Email", isSecureField: false)
        let password = SVTextFieldItem(withPlaceholder: "Contraseña", isSecureField: true)
        let deleteButton = SVButtonItem(withTitle: "Borrar foto") {
            self.loginUser(email: email.text ?? "", password: password.text ?? "")
        }
        
        //Populate the SVItem array
        items = [description, email, password, deleteButton]
        
        //Present the alert on screen.
        return SnackView(withTitle: "¡ATENCIÓN!", andCloseButtonTitle: "Cancelar", andItems: items)
    }
    
    // Función volver al GalleryViewController
    @objc func backIconFlechaTapped(tapBackIconFlecha: UITapGestureRecognizer) {
        let storyboard = UIStoryboard(name: "Fotos", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "GalleryViewController") as! GalleryViewController
        vc.pinChecked = pinChecked
        vc.nombresNovios = nombresNovios
        present(vc, animated: true, completion: nil)
    }
    
    func saveImgOnPhone() {
        let imageData = imageDetail.image?.jpegData(compressionQuality: 0.2)
        let compresedImage = UIImage(data: imageData!)
        UIImageWriteToSavedPhotosAlbum(compresedImage!, nil, nil, nil)
        
        self.mostrarMessageDeleteOrSavePhoto(controller: self, message: "Foto guardada correctamente", seconds: 2)
    }
    
    func mostrarMessageDeleteOrSavePhoto(controller:UIViewController, message:String, seconds:Double){
        let alert = UIAlertController (title: nil, message: message, preferredStyle: .alert)

        alert.view.backgroundColor = UIColor.cyan
        alert.view.layer.cornerRadius = 15
        
        let messageFont = [kCTFontAttributeName: UIFont(name: "Noteworthy-Light", size: 20.0)!]
        let messageAttrString = NSMutableAttributedString(string: message, attributes: messageFont as [NSAttributedString.Key : Any])
        
        alert.setValue(messageAttrString, forKey: "attributedMessage")
        controller.present(alert, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds){
            alert.dismiss(animated: true)
            
            let storyboard = UIStoryboard(name: "Fotos", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "GalleryViewController") as! GalleryViewController
            vc.pinChecked = self.pinChecked
            vc.nombresNovios = self.nombresNovios
            self.present(vc, animated: true, completion: nil)
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
    
    // Función para mostrar alert de borrar foto
    @objc func trashIconTapped(tapTrashIcon: UITapGestureRecognizer) {
        deletePhotoAlert()
    }
    
    func deletePhotoAlert() {
        snackView = createSnackView()
        snackView?.show()
    }
    
    // Función comprobar todos los posibles errores el rellenar los campos del alert, si no existen errores avanza a CreateViewControllerOne pasando la información al siguiente viewController
    func loginUser(email: String, password: String) {
        let emailLow = email.lowercased()
        
        if (emailLow.isEmpty == true || password.isEmpty == true) {
            mostrarToastError(controller: self, message: "Debe rellenar todos los campos", seconds: 3)
        } else {
            // Después de todas las comprobaciones, si todo está OK pasará por aquí y deberá borrar la foto de la base de datos y del storage
            Auth.auth().signIn(withEmail: email,password: password)
            { (user, error) in
                if error == nil && emailLow == self.confirmEmail{
                    self.deletePhotoDDBB()
                    self.deletePhotoStorage()
                    self.snackView?.close()
                    self.mostrarMessageDeleteOrSavePhoto(controller: self, message: "Foto borrada correctamente", seconds: 2)
                }
                else{
                    self.mostrarToastError(controller: self, message: "Usuario o contraseña incorrectos", seconds: 3)
                }
            }
        }
    }
    
    func deletePhotoDDBB() {
        let myGroup = DispatchGroup()
        myGroup.enter()
        
        let db = Firestore.firestore()
        db.collection("gallery").document(pinChecked!).collection(pinChecked!).document(imageDocumentID ?? "").delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
                myGroup.leave()
            }
        }
        myGroup.notify(queue: .main) {
            print("***Finished all requests deleting photo from DDBB.")
        }
    }
    
    func deletePhotoStorage() {
        let myGroup = DispatchGroup()
        myGroup.enter()
        
        let storage = Storage.storage()
        let url = urlImagen
        let storageRef = storage.reference(forURL: url ?? "")
        //Removes image from storage
        storageRef.delete { error in
            if let error = error {
                print(error)
            } else {
                myGroup.leave()
            }
        }
        myGroup.notify(queue: .main) {
            print("***Finished all requests deleting photo from STORAGE.")
        }
    }
    
    // Función traer urls de base de datos
    func getUrls() {
        let myGroup = DispatchGroup()
        myGroup.enter()
        
        let db = Firestore.firestore()
        
        db.collection("gallery").document(pinChecked!).collection(pinChecked!).whereField("Url", isEqualTo: urlImagen!)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        print("\(document.documentID) => \(document.data())")
                        self.imageDocumentID = document.documentID
                        myGroup.leave()
                    }
                }
        }
        
        myGroup.notify(queue: .main) {
            print("Finished all requests getting urlDocumentID.")
        }
    }
    
    // Función traer Email del usuario segun el pin de la boda desde la base de datos
    func getEmail() {
        let myGroup = DispatchGroup()
        myGroup.enter()
        
        let db = Firestore.firestore()
        
        db.collection("usuario").whereField("Pin", isEqualTo: pinChecked!)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        print("\(document.documentID) => \(document.data())")
                        self.arrUserData = document.data()
                        self.confirmEmail = self.arrUserData["Email"] as? String
                        myGroup.leave()
                    }
                }
        }
        myGroup.notify(queue: .main) {
            print("Finished all requests getting Email.")
        }
    }
}
