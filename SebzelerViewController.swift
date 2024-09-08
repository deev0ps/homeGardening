//
//  SebzelerViewController.swift
//  homeGardening
//
//  Created by Rasim Egi on 15.07.2024.
//

import UIKit
import CoreData
class SebzelerViewController: UIViewController , UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var tableVieww: UITableView!
    var vegetables: [Vegetable] = []
    

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableVieww.dataSource = self
                tableVieww.delegate = self
                
                tableVieww.register(UITableViewCell.self, forCellReuseIdentifier: "VegetableCell")
                
                fetchVegetables()
                
                if !UserDefaults.standard.bool(forKey: "isDataSaved") {
                    saveInitialVegetables()
                    UserDefaults.standard.set(true, forKey: "isDataSaved")
                }
            }
            
            func fetchVegetables() {
                guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
                let context = appDelegate.persistentContainer.viewContext
                let fetchRequest: NSFetchRequest<Vegetable> = Vegetable.fetchRequest()
                
                do {
                    vegetables = try context.fetch(fetchRequest)
                    
                    // Debug: Çekilen verileri yazdır
                    for vegetable in vegetables {
                        print("Vegetable: \(vegetable.isim ?? ""), Growth Period: \(vegetable.buyumeSuresi)")
                    }
                    
                    tableVieww.reloadData()
                } catch {
                    print("Failed to fetch vegetables: \(error)")
                }
            }
            
            func saveVegetable(isim: String, gorsel: UIImage, metin: String, buyumeSuresi: Int16) {
                guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
                let context = appDelegate.persistentContainer.viewContext
                let vegetable = Vegetable(context: context)
                
                vegetable.isim = isim
                vegetable.gorsel = gorsel.jpegData(compressionQuality: 0.5)
                vegetable.metin = metin
                vegetable.buyumeSuresi = buyumeSuresi
                
                do {
                    try context.save()
                    vegetables.append(vegetable)
                    tableVieww.reloadData()
                } catch {
                    print("Failed to save vegetable: \(error)")
                }
            }
            
            func saveInitialVegetables() {
                let vegetableData = [
                    ("Domates", UIImage(named: "domates")!, "Yetişme Süresi: 60-85 gün \nMevsim: İlkbahar ve yaz \nSulama: Günde 1-2 kez \nSu İhtiyacı: Su sever", 70),
                    ("Salatalık", UIImage(named: "salatalik")!, "Yetişme Süresi: 50-70 gün\nMevsim: İlkbahar ve yaz\nSulama: Günde 1-2 kez\nSu İhtiyacı: Su sever", 60),
                    ("Havuç", UIImage(named: "havuc")!, "Yetişme Süresi: 70-80 gün \nMevsim: İlkbahar ve sonbahar \nSulama: 2-3 günde bir \nSu İhtiyacı: Orta seviyede su sever", 75),
                    ("Biber", UIImage(named: "biber")!, "Yetişme Süresi: 60-90 gün \nMevsim: İlkbahar ve yaz \nSulama: Günde 1 kez \nSu İhtiyacı: Orta seviyede su sever", 60),
                    ("Marul", UIImage(named: "marul")!, "Yetişme Süresi: 30-45 gün \nMevsim: İlkbahar ve sonbahar \nSulama: Günde 1 kez \nSu İhtiyacı: Su sever", 35)
                ]
                
                for data in vegetableData {
                    saveVegetable(isim: data.0, gorsel: data.1, metin: data.2, buyumeSuresi: Int16(data.3))
                }
            }
            
            func updateVegetable(isim: String, yeniGorsel: UIImage, yeniMetin: String, yeniBuyumeSuresii: Int16) {
                guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
                let context = appDelegate.persistentContainer.viewContext
                let fetchRequest: NSFetchRequest<Vegetable> = Vegetable.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "isim == %@", isim)
                
                do {
                    let results = try context.fetch(fetchRequest)
                    if let vegetableToUpdate = results.first {
                        vegetableToUpdate.gorsel = yeniGorsel.jpegData(compressionQuality: 0.5)
                        vegetableToUpdate.metin = yeniMetin
                        vegetableToUpdate.buyumeSuresi = yeniBuyumeSuresii
                        
                        try context.save()
                        fetchVegetables() // Verileri tekrar çekip tabloyu güncelledim
                    }
                } catch {
                    print("Failed to update vegetable: \(error)")
                }
            }
            
            // UITableViewDataSource Methods
            func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
                return vegetables.count
            }
            
            func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                let cell = tableView.dequeueReusableCell(withIdentifier: "VegetableCell", for: indexPath)
                let vegetable = vegetables[indexPath.row]
                cell.textLabel?.text = vegetable.isim ?? "Bilinmeyen Sebze"
                return cell
            }
            
            // UITableViewDelegate Method
            func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                let vegetable = vegetables[indexPath.row]
                performSegue(withIdentifier: "toDetailVC", sender: vegetable)
            }
            
            override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
                if segue.identifier == "toDetailVC" {
                    if let detailVC = segue.destination as? DetailViewController, let vegetable = sender as? Vegetable {
                        detailVC.vegetable = vegetable
                    }
                }
            }
        }
