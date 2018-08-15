//
//  FavContentViewController.swift
//  MbsaysProject
//
//  Created by Burak Akin on 14.08.2018.
//  Copyright © 2018 Burak Akin. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import FirebaseStorage

class FavContentViewController: UIViewController {

    var contentId = [ContentID]()
    
    var ref: CollectionReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         ref = Firestore.firestore().collection("mainPage")
       
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let appDelegate = (UIApplication.shared.delegate) as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        do{
            contentId = try context.fetch(ContentID.fetchRequest())
            for id in contentId{
                getData(id: id.mID ?? "")
            }
        } catch{
            print("Error")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getData(id data:String){
        
       let docref = ref.document("\(data)")
       docref.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("Document data: \(dataDescription)")
            } else {
                print("Document does not exist")
            }
        }
    }
    
    

}


extension FavContentViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contentId.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favCell", for: indexPath) as! FavContentPageTableViewCell
        let content = contentId[indexPath.row]
        cell.favContentDescriptionlbl.text = content.mID
        return cell
    }
    
    
    
    
    
    
}

