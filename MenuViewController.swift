//
//  MenuViewController.swift
//  homeGardening
//
//  Created by Rasim Egi on 12.07.2024.
//

import UIKit

class MenuViewController: UIViewController {
    
    @IBOutlet weak var denemeBTN: UIButton!
    @IBOutlet weak var bilgiContainer: UIView!
    @IBOutlet weak var meyveContainer: UIView!
    @IBOutlet weak var sebzeContainer: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        
        sebzeContainer.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self , action: #selector(sebzelereGit))
        sebzeContainer.addGestureRecognizer(gestureRecognizer)
        
        meyveContainer.isUserInteractionEnabled = true
        let gr = UITapGestureRecognizer(target: self, action: #selector(meyvelereGit))
        meyveContainer.addGestureRecognizer(gr)
        
        bilgiContainer.isUserInteractionEnabled = true
        let gR = UITapGestureRecognizer(target: self, action: #selector(bilgilereGit))
        bilgiContainer.addGestureRecognizer(gR)
    }
    @objc func sebzelereGit() {
        performSegue(withIdentifier: "toSebzelerVC", sender: nil)
    }
    @objc func meyvelereGit(){
        performSegue(withIdentifier: "toMeyvelerVC", sender: nil)
    }
    @objc func bilgilereGit(){
        performSegue(withIdentifier: "toBilgiKosesiVC", sender: nil)
    }

         
    }

 
    


