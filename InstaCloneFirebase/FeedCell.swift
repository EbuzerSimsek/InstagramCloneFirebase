//
//  FeedCell.swift
//  InstaCloneFirebase
//
//  Created by Ebuzer Şimşek on 1.05.2023.
//

import UIKit
import Firebase
class FeedCell: UITableViewCell {

    
    @IBOutlet var CustomImageView: UIImageView!
    @IBOutlet var mailLabel: UILabel!
    @IBOutlet var commentLabel: UILabel!
    @IBOutlet var likeLabel: UILabel!
    @IBOutlet var PostIdLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func LikeButtonClicked(_ sender: Any) {
      
        let fireStoreDataBase = Firestore.firestore()
        
        if let likeCount = Int(likeLabel.text!){
           
            let likeStore = ["likes":likeCount + 1] as [String:Any]
            
            fireStoreDataBase.collection("Posts").document(PostIdLabel.text!).setData(likeStore,merge: true)

        }
        
        
    }
}
