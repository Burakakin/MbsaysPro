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

let appDelegate = (UIApplication.shared.delegate) as! AppDelegate
let context = appDelegate.persistentContainer.viewContext

class FavContentViewController: UIViewController {

    var contentId = [ContentID]()
    var dataFromFirestore = [[String: Any]]()
    
    var refresher: UIRefreshControl!
    
    @IBOutlet weak var customTableView: UITableView!
    var ref: CollectionReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         ref = Firestore.firestore().collection("mainPage")
       
        // Do any additional setup after loading the view.
        
        
        getData()
        
        refresher = UIRefreshControl()
        customTableView.refreshControl = refresher
        refresher.attributedTitle = NSAttributedString(string: "Pull to Refresh")
        refresher.addTarget(self, action: #selector(getData), for: .valueChanged)
        
    }
    
   
    
    @objc func getData(){
        dataFromFirestore.removeAll()
        do{
            contentId = try context.fetch(ContentID.fetchRequest())
            if contentId.count == 0 {
                print("Burak")
                DispatchQueue.main.async {
                    self.customTableView.reloadData()
                    self.refresher.endRefreshing()
                }
            }
            else{
                for id in contentId{
                    let docref = ref.document("\(id.mID ?? "")")
                    docref.getDocument { (document, error) in
                        if let document = document, document.exists {
                            //let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                            let dataTitle = document.data()!["title"] as! String
                            let dataDescription = document.data()!["description"] as! String
                            let dataImageUrl = document.data()!["imageUrl"] as! String
                            let dataDic: [String: String] = ["id": id.mID ?? "", "title": dataTitle, "imageUrl": dataImageUrl, "description": dataDescription]
                            DispatchQueue.main.async {
                                self.dataFromFirestore.append(dataDic)
                                self.customTableView.reloadData()
                                self.refresher.endRefreshing()
                            }
                        } else {
                            print("Document does not exist")
                        }
                    }
                }
            }
            
        } catch{
            print("Error")
        }
        
    }
    
    
    
    

}


extension FavContentViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataFromFirestore.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favCell", for: indexPath) as! FavContentPageTableViewCell
        let content = dataFromFirestore[indexPath.row]
        cell.favContentDescriptionlbl.text = (content["description"] as! String)
        cell.favContentTitleLabel.text = (content["title"] as! String)
        cell.favContentImageView.download(url: content["imageUrl"] as! String)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "mainPageShowDetail2", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let rowSelected = (sender as! IndexPath).row
        if segue.identifier == "mainPageShowDetail2" {
            if let mainPageDetailVC = segue.destination as? MainPageDetailViewController {
                mainPageDetailVC.titleDetail = (dataFromFirestore[rowSelected]["title"] as! String)
                mainPageDetailVC.documentId = (dataFromFirestore[rowSelected]["id"] as! String)
            }
        }
    }

    
    
    
}



