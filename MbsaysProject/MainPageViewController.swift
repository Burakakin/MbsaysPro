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
    
    func mergeSort<T: Comparable>(_ array: [T]) -> [T] {
        guard array.count > 1 else { return array }
        
        let middleIndex = array.count / 2
        
        let leftArray = mergeSort(Array(array[0..<middleIndex]))
        let rightArray = mergeSort(Array(array[middleIndex..<array.count]))
        
        
        return merge(leftArray, rightArray)
    }
    
    func merge<T: Comparable>(_ left: [T], _ right: [T]) -> [T] {
        var leftIndex = 0
        var rightIndex = 0
        
        var orderedArray: [T] = []
        
        while leftIndex < left.count && rightIndex < right.count {
            let leftElement = left[leftIndex]
            let rightElement = right[rightIndex]
            
            if leftElement < rightElement {
                orderedArray.append(leftElement)
                leftIndex += 1
            } else if leftElement > rightElement {
                orderedArray.append(rightElement)
                rightIndex += 1
            } else {
                orderedArray.append(leftElement)
                leftIndex += 1
                orderedArray.append(rightElement)
                rightIndex += 1
            }
        }
        
        while leftIndex < left.count {
            orderedArray.append(left[leftIndex])
            leftIndex += 1
        }
        
        while rightIndex < right.count {
            orderedArray.append(right[rightIndex])
            rightIndex += 1
        }
        
        return orderedArray
    }
    
    
    @IBAction func sortingAlgorithm(_ sender: Any) {
       
        var array = [Int]()
        for index in mainPage {
            array.append(Int(index["number"]!)!)
        }
        
        let newArray = mergeSort(array)
       
        for i in 0..<array.count {
            var count = 0
            
            let index = mainPage.firstIndex(where: {$0["number"] == "\(newArray[i])"})
            let partialArray = mainPage[index!]
            print(index!)
            mainPage.remove(at: index!)
            mainPage.insert(partialArray, at: count)
            count += 1
           
        }
        DispatchQueue.main.async {
            self.tableViewMain.reloadData()
        }
       print(mainPage)
        
    }
    
    
    
    func getData(){
        ref.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    //print("\(document.documentID) => \(document.data())")
                    let documentId = document.documentID
                    let documentTitle = document.data()["title"] as! String
                    let documentImageUrl = document.data()["imageUrl"] as! String
                    let documentDescription = document.data()["description"] as! String
                    let documentNumber = document.data()["number"] as! Int
                    let data: [String: String] = ["id": documentId, "title": documentTitle, "imageUrl": documentImageUrl, "description": documentDescription, "number": "\(documentNumber)"]
                    DispatchQueue.main.async {
                        self.mainPage.append(data)
                        self.filteredMainPage = self.mainPage
                        self.tableViewMain.reloadData()
                    }
                }
            }
        }
    }
    
    
}





extension MainPageViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredMainPage.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mainPageTableViewCell", for: indexPath) as! MainPageCustomTableViewCell
        
        cell.mainPageTitle.text = (mainPage[indexPath.row]["title"])
        cell.mainPageDescription.text = (mainPage[indexPath.row]["description"])
        cell.mainPageImage.download(url: mainPage[indexPath.row]["imageUrl"]!)
        cell.mainPageLast.text = "\(mainPage[indexPath.row]["number"] ?? "")"
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
