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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

}


extension FavContentViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favCell", for: indexPath) as! FavContentPageTableViewCell
        
        cell.favContentDescriptionlbl.text = "text"
        return cell
    }
    
    
    
    
    
    
}
