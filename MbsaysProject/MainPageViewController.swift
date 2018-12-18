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


class MainPageViewController: UIViewController {
    
    @IBOutlet weak var tableViewMain: UITableView!
    var ref: CollectionReference!
    
    @IBOutlet weak var searchBarMain: UISearchBar!
    var mainPage = [[String: String]]()
    var filteredMainPage = [[String: String]]()
    
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
        //brk
    }
    
   
    @IBAction func sortingAlgorithm(_ sender: Any) {
        
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
                        self.filteredMainPage = self.mainPage
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
    
    
    
}





extension MainPageViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredMainPage.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mainPageTableViewCell", for: indexPath) as! MainPageCustomTableViewCell
        
        cell.mainPageTitle.text = (filteredMainPage[indexPath.row]["title"])
        cell.mainPageDescription.text = (filteredMainPage[indexPath.row]["description"])
        cell.mainPageImage.download(url: filteredMainPage[indexPath.row]["imageUrl"]!)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "mainPageShowDetail", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let rowSelected = (sender as! IndexPath).row
        if segue.identifier == "mainPageShowDetail" {
            if let mainPageDetailVC = segue.destination as? MainPageDetailViewController {
                mainPageDetailVC.titleDetail = (mainPage[rowSelected]["title"])
                mainPageDetailVC.documentId = (mainPage[rowSelected]["id"])
            }
        }
    }

}

extension MainPageViewController: UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        guard !searchText.isEmpty else{
            filteredMainPage = mainPage
            DispatchQueue.main.async {
                self.tableViewMain.reloadData()
            }
            return
        }
        
//        filteredMainPage = mainPage.filter { $0["title"]?.lowercased() == "\(searchText)"}
        filteredMainPage = mainPage.filter { ($0["title"]?.lowercased().contains(searchText.lowercased()))!}
        print(filteredMainPage)
        DispatchQueue.main.async {
            self.tableViewMain.reloadData()
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
