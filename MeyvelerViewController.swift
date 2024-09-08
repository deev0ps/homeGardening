//
//  MeyvelerViewController.swift
//  homeGardening
//
//  Created by Rasim Egi on 16.07.2024.
//

import UIKit
import CoreData

class MeyvelerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var fruits: [Fruit] = []
    @IBOutlet weak var tableVieww: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableVieww.dataSource = self
        tableVieww.delegate = self
        fetchFruits()
        
        tableVieww.register(UITableViewCell.self, forCellReuseIdentifier: "FruitCell")
        
        if UserDefaults.standard.bool(forKey: "isFruitDataSaved") == false {
            saveInitialFruits()
            UserDefaults.standard.set(true, forKey: "isFruitDataSaved")
        } else {
            // Mevcut meyveleri güncelle
            updateFruit(isim: "Elma", yeniGorsel: UIImage(named: "elma")!, yeniMetin: "Yetişme Süresi: 100-200 gün (ağaçtan ağaca değişir) \n Mevsim: İlkbahar ve yaz çiçeklenme, sonbahar hasat \n Sulama: Haftada 1-2 kez \n Su İhtiyacı: Orta seviyede su sever")
            updateFruit(isim: "Muz", yeniGorsel: UIImage(named: "muz")!, yeniMetin: "Yetişme Süresi: 9-12 ay \n Mevsim: Tüm yıl (tropikal iklimlerde) \n Sulama: Günde 1-2 kez \n Su İhtiyacı: Su sever")
            updateFruit(isim: "Çilek", yeniGorsel: UIImage(named: "cilek")!, yeniMetin: "Yetişme Süresi: 4-6 hafta (çiçeklenmeden meyveye) \n Mevsim: İlkbahar ve yaz \n Sulama: Günde 1 kez \n Su İhtiyacı: Su sever")
            updateFruit(isim: "Portakal", yeniGorsel: UIImage(named: "portakal")!, yeniMetin: "Yetişme Süresi: 7-15 ay (ağaçtan ağaca değişir) \n Mevsim: İlkbahar çiçeklenme, sonbahar ve kış hasat \n Sulama: Haftada 1 kez \n Su İhtiyacı: Orta seviyede su sever")
            updateFruit(isim: "Üzüm", yeniGorsel: UIImage(named: "üzüm")!, yeniMetin: "Yetişme Süresi: 3-4 ay (çiçeklenmeden meyveye) \n Mevsim: İlkbahar ve yaz çiçeklenme, yaz sonu ve sonbahar hasat \n Sulama: Haftada 1-2 kez \n Su İhtiyacı: Orta seviyede su sever")
        }
    }
    
    func fetchFruits() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Fruit> = Fruit.fetchRequest()
        
        do {
            fruits = try context.fetch(fetchRequest)
            tableVieww.reloadData()
        } catch {
            print("Failed to fetch fruits: \(error)")
        }
    }
    
    func saveFruit(isim: String, gorsel: UIImage, metin: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        let fruit = Fruit(context: context)
        
        fruit.isim = isim
        fruit.gorsel = gorsel.jpegData(compressionQuality: 0.5)
        fruit.metin = metin
        
        do {
            try context.save()
            fruits.append(fruit)
            tableVieww.reloadData()
        } catch {
            print("Failed to save fruit: \(error)")
        }
    }
    
    func saveInitialFruits() {
        let fruitData = [
            ("Elma", UIImage(named: "elma")!, "Elmalar vitamin ve lif açısından zengindir."),
            ("Muz", UIImage(named: "muz")!, "Muzlar enerji ve potasyum sağlar."),
            ("Çilek", UIImage(named: "cilek")!, "Çilekler antioksidan açısından zengindir."),
            ("Portakal", UIImage(named: "portakal")!, "Portakallar C vitamini deposudur."),
            ("Üzüm", UIImage(named: "üzüm")!, "Üzümler kalp sağlığına iyi gelir.")
        ]
        
        for data in fruitData {
            saveFruit(isim: data.0, gorsel: data.1, metin: data.2)
        }
    }
    
    // TableView DataSource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fruits.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FruitCell", for: indexPath)
        let fruit = fruits[indexPath.row]
        cell.textLabel?.text = fruit.isim ?? "Bilinmeyen Meyve"
        return cell
    }
    
    // TableView Delegate Method
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let fruit = fruits[indexPath.row]
        performSegue(withIdentifier: "toDetail2VC", sender: fruit)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetail2VC" {
            if let detailVC = segue.destination as? FruitDetailViewController, let fruit = sender as? Fruit {
                detailVC.fruit = fruit
            }
        }
    }
    
    func updateFruit(isim: String, yeniGorsel: UIImage, yeniMetin: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Fruit> = Fruit.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "isim == %@", isim)
        
        do {
            let results = try context.fetch(fetchRequest)
            if let fruitToUpdate = results.first {
                fruitToUpdate.gorsel = yeniGorsel.jpegData(compressionQuality: 0.5)
                fruitToUpdate.metin = yeniMetin
                
                try context.save()
                fetchFruits() 
            }
        } catch {
            print("Failed to update fruit: \(error)")
        }
    }
}
