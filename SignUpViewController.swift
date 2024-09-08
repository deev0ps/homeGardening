//
//  SignUpViewController.swift
//  homeGardening
//
//  Created by Rasim Egi on 10.07.2024.
//

import UIKit
import CoreData

class SignUpViewController: UIViewController {

    @IBOutlet weak var userNameTxt: UITextField!
    @IBOutlet weak var pswTxt: UITextField!
    @IBOutlet weak var cpswTxt: UITextField!
    var alinanSifre = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func saveBTN(_ sender: Any) {
        
    
        if userNameTxt.text == "" {
            let hata = UIAlertController(title: "Hata", message: "Kullanıcı adı veya şifre yanlış.", preferredStyle: .alert)
                       hata.addAction(UIAlertAction(title: "Tamam", style: .default, handler: nil))
                       self.present(hata, animated: true, completion: nil)
     
        } else if pswTxt.text == ""{
            let hata = UIAlertController(title: "Hata", message: "Kullanıcı adı veya şifre yanlış.", preferredStyle: .alert)
                       hata.addAction(UIAlertAction(title: "Tamam", style: .default, handler: nil))
                       self.present(hata, animated: true, completion: nil)
           
        }else if  pswTxt.text != cpswTxt.text{
            let hata = UIAlertController(title: "Hata", message: "Şifre Uyuşmuyor.", preferredStyle: .alert)
                       hata.addAction(UIAlertAction(title: "Tamam", style: .default, handler: nil))
                       self.present(hata, animated: true, completion: nil)
         
           
        } else {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            let garden = NSEntityDescription.insertNewObject(forEntityName: "Garden", into: context)
            garden.setValue(userNameTxt.text!, forKey: "kullaniciAdi")
            garden.setValue(pswTxt.text, forKey: "sifre")
            garden.setValue(UUID(), forKey: "id")
            do{
                try context.save()
                print("kayit edildi")
                performSegue(withIdentifier: "toAnaMenuVC", sender: nil)
                
            }catch{print("hata var")}
        }
    }
    
}
