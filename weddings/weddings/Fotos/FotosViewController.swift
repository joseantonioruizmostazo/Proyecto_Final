//
//  FotosViewController.swift
//  weddings
//
//  Created by José Ruiz on 8/5/19.
//  Copyright © 2019 macos. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth
import RSLoadingView

class FotosViewController: UIViewController {

    @IBOutlet weak var backIconFlecha: UIImageView!
    @IBOutlet weak var messageFotos: UILabel!
    @IBOutlet weak var galleryIcon: UIImageView!
    @IBOutlet weak var upPhotoIcon: UIImageView!
    @IBOutlet weak var coupleNames: UILabel!
    @IBOutlet weak var previewImage: UIImageView!
    @IBOutlet weak var btnSave: UIButton!
    
    let imagePicker = UIImagePickerController()
    
    public var pinChecked: String?
    public var nombresNovios: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messageFotosStyle()
        coupleNames.text = nombresNovios
        hideSubirButton()
        RSLoadingView.hide(from: view)
        
        // Initialize BackIconFlecha imageview as a button
        let tapBackIconFlecha = UITapGestureRecognizer(target: self, action: #selector(backIconFlechaTapped(tapBackIconFlecha:)))
        backIconFlecha.isUserInteractionEnabled = true
        backIconFlecha.addGestureRecognizer(tapBackIconFlecha)
        
        // Initialize galleryIcon imageview as a button
        let tapGalleryIcon = UITapGestureRecognizer(target: self, action: #selector(galleryIconTapped(tapGalleryIcon:)))
        galleryIcon.isUserInteractionEnabled = true
        galleryIcon.addGestureRecognizer(tapGalleryIcon)
        
        // Initialize upPhotoIcon imageview as a button
        let tapUpPhotoIcon = UITapGestureRecognizer(target: self, action: #selector(upPhotoIconTapped(tapUpPhotoIcon:)))
        upPhotoIcon.isUserInteractionEnabled = true
        upPhotoIcon.addGestureRecognizer(tapUpPhotoIcon)
    }
    
    // Función estilo messageFotos
    func messageFotosStyle() {
        let attributedString = NSMutableAttributedString(string: messageFotos.text!)
        
        // *** Create instance of `NSMutableParagraphStyle`
        let paragraphStyle = NSMutableParagraphStyle()
        
        // *** set LineSpacing property in points ***
        paragraphStyle.lineSpacing = 8 // Whatever line spacing you want in points
        
        // *** Apply attribute to string ***
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        
        // *** Set Attributed String to your label ***
        messageFotos.attributedText = attributedString
        messageFotos.textAlignment = .center
    }
    
    // Función volver al PinMainVIEWController
    @objc func backIconFlechaTapped(tapBackIconFlecha: UITapGestureRecognizer) {
        let storyboard = UIStoryboard(name: "Pin", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "PinMainViewController") as! PinMainViewController
        vc.pinChecked = pinChecked
        present(vc, animated: true, completion: nil)
    }
    
    // Función ir al GalleryViewController
    @objc func galleryIconTapped(tapGalleryIcon: UITapGestureRecognizer) {
        let storyboard = UIStoryboard(name: "Fotos", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "GalleryViewController") as! GalleryViewController
        vc.pinChecked = pinChecked
        vc.nombresNovios = nombresNovios
        present(vc, animated: true, completion: nil)
    }
    
    // Función que selecciona la foto deseada desde la galeria del móvil
    @objc func upPhotoIconTapped(tapUpPhotoIcon: UITapGestureRecognizer) {
        self.setupImagePicker()
    }
    
    // Función generar nombrePhoto
    func randomName(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    @IBAction func btnSaveClick(_ sender: UIButton) {
        // Custom spinner indications
        startSpinner()
        
        self.saveFirData()
    }
    
    func saveFirData() {
        self.upToStorage(self.previewImage.image!) { url in
        
            self.saveImage(profileUrl: url!) { success in
                
                if success != nil {
                    print("YEAH YESSSSSS")
                }
            }
        }
    }
    
    func hideSubirButton() {
        btnSave.isHidden = true
    }
    
    func showSubirButton() {
        btnSave.isHidden = false
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

extension FotosViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func setupImagePicker() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imagePicker.sourceType = .photoLibrary
            imagePicker.delegate = self
            imagePicker.isEditing = true
            
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        previewImage.image = image
        showSubirButton()
        self.dismiss(animated: true, completion: nil)
    }
}

extension FotosViewController {

    // Función que sube al storage la imagen
    func upToStorage(_ image: UIImage, completion: @escaping ((_ url: URL?) -> ())) {
        let storage = Storage.storage()
        let storageRef = storage.reference()
        
        // Generar nombre para foto
        let namePhoto = self.randomName(length: 15)
        
        // Create a reference to the file you want to upload
        let imageRef = storageRef.child("\(pinChecked!)/\(namePhoto).jpeg")
        let imgData = previewImage.image?.jpegData(compressionQuality: 0.2)
        let medaData = StorageMetadata()
        medaData.contentType = "image/jpeg"
        imageRef.putData(imgData!, metadata: medaData) { (metadata, error) in
            if error == nil {
                print("Success")
                imageRef.downloadURL(completion: { (url, error) in
                    completion(url)
                })
            } else {
                self.stopSpinner()
                self.mostrarToastError(controller: self, message: "Error al subir la foto, inténtelo de nuevo", seconds: 3)
                print("error in save image")
                completion(nil)
            }
        }
    }
    
    // Función que guarda la url de la imagen en la base de datos
    func saveImage(profileUrl:URL, completion: @escaping ((_ url: URL?) -> ())) {
        let db = Firestore.firestore()
        db.collection("gallery").document(pinChecked!).collection(pinChecked!).document().setData([
            "Url": profileUrl.absoluteString
        ]) { err in
            if let err = err {
                self.stopSpinner()
                self.mostrarToastError(controller: self, message: "Error al subir la foto, inténtelo de nuevo", seconds: 3)
                print("Error writing document: \(err)")
            } else {
                self.stopSpinner()
                self.mostrarToastError(controller: self, message: "La foto se ha subido correctamente", seconds: 3)
                print("Document successfully written!")
            }
        }
    }
}
