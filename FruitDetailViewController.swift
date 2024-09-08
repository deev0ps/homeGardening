//
//  FruitDetailViewController.swift
//  homeGardening
//
//  Created by Rasim Egi on 17.07.2024.
//

import UIKit
import UserNotifications

class FruitDetailViewController: UIViewController {
    @IBOutlet weak var kaydetBTN: UIButton!
    @IBOutlet weak var temizleBTN: UIButton!
    @IBOutlet weak var datePickerr: UIDatePicker!
    @IBOutlet weak var tarihTxtView: UITextView!
    @IBOutlet weak var metinTxtView: UITextView!
    @IBOutlet weak var isimLbl: UILabel!
    @IBOutlet weak var imageView: UIImageView!
  
    var fruit: Fruit?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
     
        datePickerr.datePickerMode = .date
        datePickerr.addTarget(self, action: #selector(datePickerTiklandi(_:)), for: .valueChanged)
        
    
        if let fruit = fruit {
            isimLbl.text = fruit.isim
            if let imageData = fruit.gorsel {
                imageView.image = UIImage(data: imageData)
            }
            metinTxtView.text = fruit.metin
            
        
            if let growthPeriodDays = FruitGrowthPeriods.periods[fruit.isim ?? ""] {
                print("Büyüme süresi: \(growthPeriodDays)")
            }
            
            
            loadDatesFromUserDefaults()
        }
    }
    @IBAction func temizleBtn(_ sender: Any){
        
        deleteDatesFromUserDefaults()
        tarihTxtView.text = ""
       
        datePickerr.date = Date()
    
        kaydetBTN.isEnabled = true
    
    }
    
    @IBAction func kaydetBtn(_ sender: Any) {
        tarihTxtView.isHidden = false
        saveDatesToUserDefaults()
        updateDateTextView()
        kaydetBTN.isEnabled = false 
            }
    
    @objc func datePickerTiklandi(_ sender: UIDatePicker) {
        updateDateTextView()
    }
    
    func updateDateTextView() {
        guard let fruit = fruit else { return }
        
        let plantingDate = datePickerr.date
      
        let growthPeriodDays = FruitGrowthPeriods.periods[fruit.isim ?? ""] ?? 0
        
        
        let calendar = Calendar.current
        if let outputDate = calendar.date(byAdding: .day, value: growthPeriodDays, to: plantingDate) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            let plantingDateString = dateFormatter.string(from: plantingDate)
            let outputDateString = dateFormatter.string(from: outputDate)
            
            
            tarihTxtView.text = """
            Ekim Tarihi: \(plantingDateString)
            Çıkış Tarihi: \(outputDateString)
            """
            
         
            scheduleNotification(for: outputDate)
        }
    }
    
    func saveDatesToUserDefaults() {
        guard let fruit = fruit else { return }
        
        let plantingDate = datePickerr.date
        
       
        let growthPeriodDays = FruitGrowthPeriods.periods[fruit.isim ?? ""] ?? 0
        
       
        let calendar = Calendar.current
        if let outputDate = calendar.date(byAdding: .day, value: growthPeriodDays, to: plantingDate) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            let plantingDateString = dateFormatter.string(from: plantingDate)
            let outputDateString = dateFormatter.string(from: outputDate)
            
        
            let defaults = UserDefaults.standard
            defaults.set(plantingDateString, forKey: "plantingDate_\(fruit.isim ?? "Unknown")")
            defaults.set(outputDateString, forKey: "outputDate_\(fruit.isim ?? "Unknown")")
        }
    }
    
    func loadDatesFromUserDefaults() {
        guard let fruit = fruit else { return }
        
        let defaults = UserDefaults.standard
        if let plantingDateString = defaults.string(forKey: "plantingDate_\(fruit.isim ?? "Unknown")"),
           let outputDateString = defaults.string(forKey: "outputDate_\(fruit.isim ?? "Unknown")") {
            
            
            tarihTxtView.text = """
            Ekim Tarihi: \(plantingDateString)
            Çıkış Tarihi: \(outputDateString)
            """
            
       
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            if let plantingDate = dateFormatter.date(from: plantingDateString) {
                datePickerr.date = plantingDate
            }
        }
    }
    func deleteDatesFromUserDefaults() {
        guard let fruit = fruit else { return }

        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "plantingDate_\(fruit.isim ?? "Unknown")")
        defaults.removeObject(forKey: "outputDate_\(fruit.isim ?? "Unknown")")
    }
    func scheduleNotification(for date: Date) {
        let content = UNMutableNotificationContent()
        content.title = "Meyve Uyarısı"
        content.body = "Meyveniz için çıkış tarihi geldi! Lütfen kontrol edin."
        content.sound = .default
        
  
        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Bildirim eklenirken hata oluştu: \(error)")
            }
        }
    }
}
