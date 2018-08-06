//
//  AboutPageViewController.swift
//  MbsaysProject
//
//  Created by Burak Akin on 30.07.2018.
//  Copyright © 2018 Burak Akin. All rights reserved.
//

import UIKit

class AboutPageViewController: UIViewController {

    @IBOutlet weak var myCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        
        
        let width = (view.frame.size.width - 30) / 2
        let layout = myCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width, height: 180)
        // Do any additional setup after loading the view.
    }

    var teamDictionary: [[String: String]] = [["name": "Yeşer Sarıyıldız", "title": "Co-Founder","fb": "","ig": "","linkedin": ""],["name": "Yeşer Sarıyıldız", "title": "Co-Founder","fb": "","ig": "","linkedin": ""]]
    
    
    @IBAction func LeftSideButtonTapped(_ sender: Any) {
        
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.centerContainer!.toggle(MMDrawerSide.left, animated: true, completion: nil)
    }
    
  

}


extension AboutPageViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return teamDictionary.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "aboutPageCollectionCell", for: indexPath) as! AboutPageCustomCollectionViewCell
        cell.aboutPageNameLabel.text = teamDictionary[indexPath.row]["name"]
        cell.aboutPageTitleLabel.text = teamDictionary[indexPath.row]["title"]
        
        return cell
    }
    
    
    
    
    
    
    
}
