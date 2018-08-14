//
//  AboutDeveloperViewController.swift
//  MbsaysProject
//
//  Created by Burak Akin on 8.08.2018.
//  Copyright © 2018 Burak Akin. All rights reserved.
//

import UIKit

class AboutDeveloperViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.centerContainer!.toggle(MMDrawerSide.left, animated: true, completion: nil)
    }
    

}
