//
//  GalleryViewController.swift
//  weddings
//
//  Created by José Ruiz on 8/5/19.
//  Copyright © 2019 macos. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth

class GalleryViewController: UIViewController {

    @IBOutlet weak var backIconFlecha: UIImageView!
    @IBOutlet weak var coupleNames: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    public var pinChecked: String?
    public var nombresNovios: String?
    private var galleryData: [String : Any] = [:]
    var arrData = [GalleryModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getArrData()
        
        // Initialize BackIconFlecha imageview as a button
        let tapBackIconFlecha = UITapGestureRecognizer(target: self, action: #selector(backIconFlechaTapped(tapBackIconFlecha:)))
        backIconFlecha.isUserInteractionEnabled = true
        backIconFlecha.addGestureRecognizer(tapBackIconFlecha)
        
        coupleNames.text = nombresNovios
    }
    
    // Función volver al FotosViewController
    @objc func backIconFlechaTapped(tapBackIconFlecha: UITapGestureRecognizer) {
        let storyboard = UIStoryboard(name: "Fotos", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "FotosViewController") as! FotosViewController
        vc.pinChecked = pinChecked
        vc.nombresNovios = nombresNovios
        present(vc, animated: true, completion: nil)
    }
    
    // Función rellenar arrData con las imageUrl
    func getArrData() {
        self.arrData.removeAll()
        let myGroup = DispatchGroup()
        myGroup.enter()
        
        let db = Firestore.firestore()
        
        db.collection("gallery").document(pinChecked!).collection(pinChecked!).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    
                    self.galleryData = document.data()
                    let imgURL = self.galleryData["Url"] as! String
                    self.arrData.append(GalleryModel(imageUrl: imgURL))
                    print(self.arrData)
                    self.collectionView.reloadData()
                }
                myGroup.leave()
            }
        }
        
        myGroup.notify(queue: .main) {
            print("Finished all requests getting url´s.")
            
        }
    }
}

extension GalleryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        cell.galleryModel = arrData[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Fotos", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "GalleryDetailViewController") as! GalleryDetailViewController
        
        let imageCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        imageCell.galleryModel = arrData[indexPath.item]
        
        vc.image = imageCell.imgCell.image!
        vc.pinChecked = pinChecked
        vc.nombresNovios = nombresNovios
        vc.urlImagen = imageCell.urlDeLaImagen
        present(vc, animated: true, completion: nil)
    }
}
