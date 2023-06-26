//
//  FeedViewController.swift
//  InstaCloneFirebase
//
//  Created by Ebuzer Şimşek on 18.04.2023.
//

import UIKit
import Firebase
import SDWebImage

class FeedViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{

    @IBOutlet weak var tableView: UITableView!
    var userEmailArray = [String]()
    var commentArray   = [String]()
    var likeArray      = [Int]()
    var userImageArray = [String]()
    var PostIdArray    = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
       
        GetDataFromFireStore()
    }
    func GetDataFromFireStore(){
        
        let fireStoreDataBase = Firestore.firestore()
        
        fireStoreDataBase.collection("Posts").order(by:"date", descending: true).addSnapshotListener { (snapshot, error) in
            if error != nil{
                print(error?.localizedDescription)
            }
            else {
                if snapshot?.isEmpty != true && snapshot != nil {
                    self.userEmailArray.removeAll(keepingCapacity: false)
                    self.userImageArray.removeAll(keepingCapacity: false)
                    self.commentArray.removeAll(keepingCapacity: false)
                    self.likeArray.removeAll(keepingCapacity: false)
                    self.PostIdArray.removeAll(keepingCapacity: false)
                    
                    
                    for document in snapshot!.documents {
                        let documentID = document.documentID
                        self.PostIdArray.append(documentID)
                        
                        if let postedBy = document.get("postedBy") as? String{
                            self.userEmailArray.append(postedBy)
                            
                        }
                        if let comment = document.get("postComment") as? String{
                            self.commentArray.append(comment)
                            
                        }
                        if let like    = document.get("likes") as? Int{
                            self.likeArray.append(like)
                        }
                        
                        if let userImage = document.get("imageUrl") as? String{
                            self.userImageArray.append(userImage)
                        }
                            
                    }
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userEmailArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"Cell",for: indexPath) as! FeedCell
        cell.commentLabel.text = commentArray[indexPath.row]
        cell.likeLabel.text = String(likeArray[indexPath.row])
        cell.mailLabel.text = userEmailArray[indexPath.row]
        cell.CustomImageView.sd_setImage(with: URL(string: self.userImageArray[indexPath.row]))
        cell.PostIdLabel.text = PostIdArray[indexPath.row]
        return cell
    }
       func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 550
        
    }
}
