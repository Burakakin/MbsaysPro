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
import CoreData



class MainPageDetailViewController: UIViewController {
    
    
    
    var buttonClickedOnce = true
    var ref: CollectionReference!
    
    @IBOutlet weak var mainPageDetailTitle: UILabel!
    @IBOutlet weak var mainPageDetailDescriptionlbl: UILabel!
    @IBOutlet weak var detailImage: UIImageView!
    
    var documentId: String?
    var titleDetail: String?
    var defaults = UserDefaults.standard
   
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    lazy var context = appDelegate.persistentContainer.viewContext
    lazy var fav = ContentID(context: context)
    
    @IBOutlet weak var favButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        
        mainPageDetailTitle.text = titleDetail
       
        
        print(documentId ?? "")
        ref = Firestore.firestore().collection("mainPage/\(documentId ?? "")/mainPageDetail")
        getMainPageDetail()
//        let dictionary: [String: Bool] = defaults.dictionary(forKey: "buttonState") as! [String : Bool]
//        favButton.isSelected = (dictionary[documentId ?? ""] != nil)
//        print(dictionary)
        
    }
    
    func alert(with title: String,for message: String ){
    // create the alert
    let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
    // add an action (button)
    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
    // show the alert
    self.present(alert, animated: true, completion: nil)
    
    
    }
    
    func addFavorite(for mID : String) throws -> Bool {
        let request : NSFetchRequest<ContentID> = ContentID.fetchRequest()
        request.predicate = NSPredicate(format: "mID = %@", mID)
        request.fetchLimit = 1
        if let _ = try context.fetch(request).first {
            alert(with: mID, for: "Zaten Ekledin")
            //            print("Zaten ekledin")
            return false // record exists
        } else {
            fav.mID = mID
            try context.save()
            alert(with: mID, for: "Eklendi")
            return true // record added
        }
    }
    
    func deleteFav(for mID : String) throws -> Bool {
        let request : NSFetchRequest<ContentID> = ContentID.fetchRequest()
        request.predicate = NSPredicate(format: "mID = %@", mID)
        request.fetchLimit = 1
        if let deleteRecord = try context.fetch(request).first {
            context.delete(deleteRecord)
            try context.save()
            alert(with: mID, for: "Sildin")
            return false // record deleted
        } else {
            return true
        }
    }
    
    
    @IBAction func addFavButton(_ sender: UIButton) {
        
        var userDefault = [[String: Bool]]()
        sender.isSelected = !sender.isSelected
        let dictionaryUser : [String: Bool] = [(documentId ?? ""): sender.isSelected ]
        userDefault.append(dictionaryUser)
        defaults.set(userDefault, forKey: "buttonState")
        print(userDefault)
        
       
      
        
        if buttonClickedOnce {
            
            buttonClickedOnce = false
            do{
                let _ = try addFavorite(for: documentId ?? "")
            } catch{
                print("Error")
            }
            
            
        }
        else{
            
            buttonClickedOnce = true
            do{
                let _ = try deleteFav(for: documentId ?? "")
            } catch{
                print("Error")
            }
        }
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
