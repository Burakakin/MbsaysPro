//
//  WorkPageViewController.swift
//  MbsaysProject
//
//  Created by Burak Akin on 4.08.2018.
//  Copyright © 2018 Burak Akin. All rights reserved.
//

import UIKit

class WorkPageViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

   
    @IBAction func buttonTapped(_ sender: UIBarButtonItem) {
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.centerContainer!.toggle(MMDrawerSide.left, animated: true, completion: nil)
    }

}
