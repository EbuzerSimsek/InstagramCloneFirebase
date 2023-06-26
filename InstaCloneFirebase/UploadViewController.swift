//
//  UploadViewController.swift
//  InstaCloneFirebase
//
//  Created by Ebuzer Şimşek on 18.04.2023.
//

import UIKit
import Firebase
class UploadViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var commentText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Gesture Recognizers
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectImage))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(gestureRecognizer)
        
        let gestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(HideKeyboard))
        view.addGestureRecognizer(gestureRecognizer2)
    }
    
    @objc func HideKeyboard(){
        view.endEditing(true)
    }
    
    
    @objc func selectImage(){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker,animated: true)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage
        dismiss(animated: true)
    }
    
    
    func makeAlert(titleInput:String,messageInput:String){
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default)
        alert.addAction(okButton)
        present(alert, animated: true)
    }
    
    
    @IBAction func actionButtonClicked(_ sender: Any) {
        let storage = Storage.storage()
        let storageReference = storage.reference()
        let mediaFolder = storageReference.child("media")
        if let data = imageView.image?.jpegData(compressionQuality: 0.5){
            
    let uuid = UUID().uuidString
    let imageReference = mediaFolder.child("\(uuid).jpg")
    imageReference.putData(data) { Metadata, error in
        if error != nil{
            self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                }
        else{
            imageReference.downloadURL { url, error in
            if error == nil {
                let imageUrl = url?.absoluteString
                  //DataBase
                            
                       let firestoreDatabase = Firestore.firestore()
                         
                       var firestoreReference : DocumentReference? = nil 
                            
                let firestorePost = ["imageUrl":imageUrl!,"postedBy":Auth.auth().currentUser!.email!,"postComment":self.commentText.text!,"date":FieldValue.serverTimestamp(),"likes":0] as [String:Any]
                firestoreReference = firestoreDatabase.collection("Posts").addDocument(data: firestorePost,completion: { error in
                    if error != nil {
                        self.makeAlert(titleInput: "Error", messageInput:error?.localizedDescription ?? "Error")
                    }
                    else{
                        self.imageView.image = UIImage(named: "select")
                        self.commentText.text = ""
                        self.tabBarController?.selectedIndex = 0
                    }
                    
                })
                        }
                    }
                }
            }
            
        }
        
    }
    
}
    
    


