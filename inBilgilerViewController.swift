//
//  inBilgilerViewController.swift
//  homeGardening
//
//  Created by Rasim Egi on 21.07.2024.
//

import UIKit

class inBilgilerViewController: UIViewController {
    
    @IBOutlet weak var metinTxtView: UITextView!
    @IBOutlet weak var lbl: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    var gorsel : UIImage?
    var baslik : String?
    var metin  : String?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let gorsel = gorsel {
            imageView.image = gorsel
        }
        if let baslik = baslik {
            lbl.text = baslik
        }
        if let metin = metin {
            metinTxtView.text  = metin
        }
    }
}
   
