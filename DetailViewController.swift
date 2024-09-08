//
//  DetailViewController.swift
//  homeGardening
//
//  Created by Rasim Egi on 17.07.2024.
//

import UIKit
import UserNotifications

class DetailViewController: UIViewController {
    @IBOutlet weak var tarihTxtView: UITextView!
    @IBOutlet weak var kaydetBTN: UIButton!
    @IBOutlet weak var temizleBtn: UIButton! 
    @IBOutlet weak var datePickerr: UIDatePicker!
    @IBOutlet weak var metinTxtView: UITextView!
    @IBOutlet weak var isimLbl: UILabel!
    @IBOutlet weak var imageView: UIImageView!

    var vegetable: Vegetable?

    override func viewDidLoad() {
        super.viewDidLoad()
      
   
        datePickerr.datePickerMode = .date
        datePickerr.addTarget(self, action: #selector(datePickerTiklandi(_:)), for: .valueChanged)

        
        if let vegetable = vegetable {
            isimLbl.text = vegetable.isim
            if let imageData = vegetable.gorsel {
                imageView.image = UIImage(data: imageData)
            }
            metinTxtView.text = vegetable.metin

           
            if let growthPeriodDays = GrowthPeriods.periods[vegetable.isim ?? ""] {
                print("Büyüme süresi: \(growthPeriodDays)")
            }

            
            loadDatesFromUserDefaults()
        }
    }

    @IBAction func kaydetBtn(_ sender: Any) {
        tarihTxtView.isHidden = false
        saveDatesToUserDefaults()
        updateDateTextView()
        kaydetBTN.isEnabled = false
    }

    @IBAction func temizleBTN(_ sender: Any) {

        deleteDatesFromUserDefaults()
        tarihTxtView.text = ""
        datePickerr.date = Date()
        kaydetBTN.isEnabled = true
    }

    @objc func datePickerTiklandi(_ sender: UIDatePicker) {
        updateDateTextView()
        
    }

    func updateDateTextView() {
        guard let vegetable = vegetable else { return }

        let plantingDate = datePickerr.date


        let growthPeriodDays = GrowthPeriods.periods[vegetable.isim ?? ""] ?? 0

    
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
        guard let vegetable = vegetable else { return }

        let plantingDate = datePickerr.date

        // Büyüme süresini aldım
        let growthPeriodDays = GrowthPeriods.periods[vegetable.isim ?? ""] ?? 0

        // Çıkış tarihini hesaplama yapmak için
        let calendar = Calendar.current
        if let outputDate = calendar.date(byAdding: .day, value: growthPeriodDays, to: plantingDate) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            let plantingDateString = dateFormatter.string(from: plantingDate)
            let outputDateString = dateFormatter.string(from: outputDate)

            // UserDefaults'a kaydet
            let defaults = UserDefaults.standard
            defaults.set(plantingDateString, forKey: "plantingDate_\(vegetable.isim ?? "Unknown")")
            defaults.set(outputDateString, forKey: "outputDate_\(vegetable.isim ?? "Unknown")")
        }
    }

    func loadDatesFromUserDefaults() {
        guard let vegetable = vegetable else { return }

        let defaults = UserDefaults.standard
        if let plantingDateString = defaults.string(forKey: "plantingDate_\(vegetable.isim ?? "Unknown")"),
           let outputDateString = defaults.string(forKey: "outputDate_\(vegetable.isim ?? "Unknown")") {

           
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
        guard let vegetable = vegetable else { return }

        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "plantingDate_\(vegetable.isim ?? "Unknown")")
        defaults.removeObject(forKey: "outputDate_\(vegetable.isim ?? "Unknown")")
    }

    func scheduleNotification(for date: Date) {
        let content = UNMutableNotificationContent()
        content.title = "Sebze Uyarısı"
        content.body = "Sebzeniz için çıkış tarihi geldi! Lütfen kontrol edin."
        content.sound = .default

        // Bildirim zamanını ayarla
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
