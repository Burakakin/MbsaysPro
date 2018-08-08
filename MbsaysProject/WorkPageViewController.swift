//
//  WorkPageViewController.swift
//  MbsaysProject
//
//  Created by Burak Akin on 4.08.2018.
//  Copyright © 2018 Burak Akin. All rights reserved.
//

import UIKit

class WorkPageViewController: UIViewController {

    @IBOutlet weak var workPageCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let width = (view.frame.size.width - 30) / 2
        let layout = workPageCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width, height: 200)
    }

   
    @IBAction func buttonTapped(_ sender: UIBarButtonItem) {
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.centerContainer!.toggle(MMDrawerSide.left, animated: true, completion: nil)
    }

}

extension WorkPageViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "workCell", for: indexPath) as! WorkPageCollectionViewCell
        return cell
    }
    
    
    
    
    
}
