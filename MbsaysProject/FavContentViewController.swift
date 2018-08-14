//
//  FavContentViewController.swift
//  MbsaysProject
//
//  Created by Burak Akin on 14.08.2018.
//  Copyright © 2018 Burak Akin. All rights reserved.
//

import UIKit
import CoreData

class FavContentViewController: UIViewController {

    var contentId = [ContentID]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = (UIApplication.shared.delegate) as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        do{
            let result = try context.fetch(ContentID.fetchRequest())
            contentId = result as! [ContentID]
            
        } catch{
            print("Error")
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
