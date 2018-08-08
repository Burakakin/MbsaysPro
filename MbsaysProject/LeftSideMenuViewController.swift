//
//  LeftSideMenuViewController.swift
//  MbsaysProject
//
//  Created by Burak Akin on 29.07.2018.
//  Copyright © 2018 Burak Akin. All rights reserved.
//

import UIKit

class LeftSideMenuViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

     var menuItem = ["Ana Sayfa","Hakkımızda","İşlerimiz","İletişim"]
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(true)
//        navigationController?.setNavigationBarHidden(false, animated: false)
//    }
    
    @IBAction func fbButton(_ sender: UIButton) {
        
        let fbUrlWeb = URL(string: "https://www.facebook.com/birduramamahali")
        let fbUrlId = URL(string: "fb://profile/195680347140498")
        
        if (UIApplication.shared.canOpenURL(fbUrlId!)) {
            //FB installed
            UIApplication.shared.open(fbUrlId!)
        }
        else{
            UIApplication.shared.open(fbUrlWeb!)
        }
    }
    
    
    @IBAction func igButton(_ sender: UIButton) {
        let igUrlWeb = URL(string: "https://www.instagram.com/burakakin5")
        let igUrlId = URL(string: "instagram://user?username=burakakin5")
        
        if (UIApplication.shared.canOpenURL(igUrlId!)) {
            //FB installed
            UIApplication.shared.open(igUrlId!)
        }
        else{
            UIApplication.shared.open(igUrlWeb!)
        }
    }
    
    
    
    @IBAction func aboutDeveloper(_ sender: UIButton) {
        
        let centerViewController = self.storyboard?.instantiateViewController(withIdentifier: "AboutDeveloperViewController") as! AboutDeveloperViewController
        let centerNavController = UINavigationController(rootViewController: centerViewController)
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.centerContainer!.centerViewController = centerNavController
        appDelegate.centerContainer!.toggle(MMDrawerSide.left, animated: true, completion: nil)
    }
    
    
    
    
    
    // MARK: End of ViewController
}

extension LeftSideMenuViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItem.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell", for: indexPath) as! MenuCustomTableViewCell
        cell.menuItemLabel.text = menuItem[indexPath.row]
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        switch indexPath.row {
        case 0:
            let centerViewController = self.storyboard?.instantiateViewController(withIdentifier: "MainPageViewController") as! MainPageViewController
            let centerNavController = UINavigationController(rootViewController: centerViewController)
            let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.centerContainer!.centerViewController = centerNavController
            appDelegate.centerContainer!.toggle(MMDrawerSide.left, animated: true, completion: nil)
        case 1:
            let centerViewController = self.storyboard?.instantiateViewController(withIdentifier: "AboutPageViewController") as! AboutPageViewController
            let centerNavController = UINavigationController(rootViewController: centerViewController)
            let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.centerContainer!.centerViewController = centerNavController
            appDelegate.centerContainer!.toggle(MMDrawerSide.left, animated: true, completion: nil)
        case 2:
            let centerViewController = self.storyboard?.instantiateViewController(withIdentifier: "WorkPageViewController") as! WorkPageViewController
            let centerNavController = UINavigationController(rootViewController: centerViewController)
            let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.centerContainer!.centerViewController = centerNavController
            appDelegate.centerContainer!.toggle(MMDrawerSide.left, animated: true, completion: nil)
        default:
            print("Slm")
        }
       
        
        
        
    }
    
}
