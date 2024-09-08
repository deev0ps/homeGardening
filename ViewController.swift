//
//  ViewController.swift
//  homeGardening
//
//  Created by Rasim Egi on 10.07.2024.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

   
    @IBAction func loginBTN(_ sender: Any) {
        performSegue(withIdentifier: "loginVC", sender: nil)
    }
    
    
    
    @IBAction func signUpBTN(_ sender: Any) {
        performSegue(withIdentifier: "signUpVC", sender: nil)
    }
}

