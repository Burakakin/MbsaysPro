//
//  MainPageViewController.swift
//  MbsaysProject
//
//  Created by Burak Akin on 29.07.2018.
//  Copyright © 2018 Burak Akin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import CoreData


let appDelegate = UIApplication.shared.delegate as! AppDelegate
let context = appDelegate.persistentContainer.viewContext
let fav = ContentID(context: context)

class MainPageViewController: UIViewController {

    var buttonClickedOnce = true
    
    @IBOutlet weak var tableViewMain: UITableView!
    var ref: CollectionReference!
    
    var mainPage = [[String: Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        
       ref = Firestore.firestore().collection("mainPage")
       getData()
       
    }

    

    @IBAction func leftSideButtonTapped(_ sender: Any) {
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.centerContainer!.toggle(MMDrawerSide.left, animated: true, completion: nil)

    }
    
   
    
    
    
    func getData(){
        ref.order(by: "time", descending: true).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    //print("\(document.documentID) => \(document.data())")
                    let documentId = document.documentID
                    let documentTitle = document.data()["title"] as! String
                    let documentImageUrl = document.data()["imageUrl"] as! String
                    let documentDescription = document.data()["description"] as! String
                    let data: [String: String] = ["id": documentId, "title": documentTitle, "imageUrl": documentImageUrl, "description": documentDescription]
                    DispatchQueue.main.async {
                        self.mainPage.append(data)
                        self.tableViewMain.reloadData()
                    }
                }
            }
        }
    }
    
    
    
    
//    func update(updateData: [String: Any], dataid: String){
//
//        let storageRef = Storage.storage().reference().child("mainPage/\(updateData["title"] ?? "").jpg")
//        // Fetch the download URL
//        storageRef.downloadURL { url, error in
//            if let error = error {
//                // Handle any errors
//                print(error)
//            } else {
//                guard let downloadURL = url else { return }
//                let urlString = downloadURL.absoluteString
//                self.ref.document("\(dataid)").updateData(["imageUrl": urlString]) { err in
//                    if let err = err {
//                        print("Error updating document: \(err)")
//                    } else {
//                        DispatchQueue.main.async {
//                            self.mainPage.append(updateData)
//                            self.tableViewMain.reloadData()
//                        }
//                        print("Document successfully updated")
//                    }
//                }
//            }
//        }
//    }
    
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
    
    
    @objc func addFav(sender: UIButton) {
        
        let rowSelected = sender.tag
       
        let _ = (mainPage[rowSelected]["title"] as! String)
        let mID = (mainPage[rowSelected]["id"] as! String)
        
        if buttonClickedOnce {
            sender.backgroundColor = UIColor.red
            buttonClickedOnce = false
            do{
                let _ = try addFavorite(for: mID)
            } catch{
                print("Error")
            }


        }
        else{
            sender.backgroundColor = UIColor.clear
            buttonClickedOnce = true
            do{
                 let _ = try deleteFav(for: mID)
            } catch{
                print("Error")
            }
        }

        
        
    }
    
}





extension MainPageViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mainPage.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mainPageTableViewCell", for: indexPath) as! MainPageCustomTableViewCell
        
        cell.mainPageTitle.text = (mainPage[indexPath.row]["title"] as! String)
        cell.mainPageDescription.text = (mainPage[indexPath.row]["description"] as! String)
        cell.mainPageImage.download(url: mainPage[indexPath.row]["imageUrl"] as! String)
        cell.favButton.tag = indexPath.row
        cell.favButton.addTarget(self, action: #selector(addFav(sender:)), for: UIControlEvents.touchUpInside)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "mainPageShowDetail", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let rowSelected = (sender as! IndexPath).row
        if segue.identifier == "mainPageShowDetail" {
            if let mainPageDetailVC = segue.destination as? MainPageDetailViewController {
                mainPageDetailVC.titleDetail = (mainPage[rowSelected]["title"] as! String)
                mainPageDetailVC.documentId = (mainPage[rowSelected]["id"] as! String)
            }
        }
    }

}


extension UIImageView {
    
    func download(url urlString: String) {
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
