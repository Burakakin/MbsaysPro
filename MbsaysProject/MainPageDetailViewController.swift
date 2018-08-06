//
//  MainPageDetailViewController.swift
//  MbsaysProject
//
//  Created by Burak Akin on 3.08.2018.
//  Copyright © 2018 Burak Akin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class MainPageDetailViewController: UIViewController {
    
    var ref: CollectionReference!
    
    @IBOutlet weak var mainPageDetailTitle: UILabel!
    @IBOutlet weak var mainPageDetailDescriptionlbl: UILabel!
    @IBOutlet weak var detailImage: UIImageView!
    
    var documentId: String?
    var titleDetail: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainPageDetailTitle.text = titleDetail
       
        print(documentId ?? "")
        ref = Firestore.firestore().collection("mainPage/\(documentId ?? "")/mainPageDetail")
        getMainPageDetail()
        
        
    }
    
    
    
    func getMainPageDetail() {
        
        ref.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    self.mainPageDetailDescriptionlbl.text = document.data()["description"] as? String
                    self.detailImage.downloadImage(url: (document.data()["imageUrl"] as? String)!)
                }
            }
        }
        
    }

 

}





extension UIImageView {
    
    func downloadImage(url urlString: String) {
        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { (downloadedData, _, error) in
            guard error == nil && downloadedData != nil else { return }
            DispatchQueue.main.async{
                self.image = UIImage(data: downloadedData!)
            }
        }
        task.resume()
    }
    
}
