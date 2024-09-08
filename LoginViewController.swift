//
//  LoginViewController.swift
//  homeGardening
//
//  Created by Rasim Egi on 10.07.2024.
//

import UIKit
import CoreData

class LoginViewController: UIViewController {
    
    @IBOutlet weak var kullaniciAdiTxt: UITextField!
    @IBOutlet weak var sifreTxt: UITextField!
    var kadi : String?
    var psw : String?
    @IBOutlet weak var onloginBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        verileriAl()
        
        sifreTxt.isSecureTextEntry = true 
        
    }
    
    @IBAction func onLoginBTN(_ sender: Any) {
        let kullaniciAdiGir = kullaniciAdiTxt.text
        let kullaniciSifreGir = sifreTxt.text
        if kullaniciAdiGir == kadi && kullaniciSifreGir == psw {
            performSegue(withIdentifier: "toMenuVC", sender: nil)
        } else { 
            let alert = UIAlertController(title: "Hata", message: "Kullanıcı adı veya şifre yanlış.", preferredStyle: .alert)
                       alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: nil))
                       self.present(alert, animated: true, completion: nil)
        }
    }
        func verileriAl(){
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let fetchReques = NSFetchRequest<NSFetchRequestResult>(entityName: "Garden")
            fetchReques.returnsObjectsAsFaults = false
            do{
                let sonuclar = try context.fetch(fetchReques)
                for sonuc in sonuclar as! [NSManagedObject] {
                    kadi = sonuc.value(forKey: "kullaniciAdi") as? String
                    psw  = sonuc.value(forKey: "sifre") as? String
                }
            }catch{print("veriler alınamadı")}
            
        }
    


}
    
    



