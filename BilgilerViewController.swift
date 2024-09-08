//
//  BilgilerViewController.swift
//  homeGardening
//
//  Created by Rasim Egi on 21.07.2024.
//

import UIKit

class BilgilerViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var table: UITableView!
    
    struct Bilgiler {
        let title: String
        let imageName: String
        let txt : String
    }
    let data: [Bilgiler] = [
        Bilgiler(title: "Tropikal Meyve Nedir?", imageName: "tropicalFruits", txt: "Tropikal meyveler, tropikal iklimlerde yetişen meyvelerdir. Tropikal iklimler, genellikle sıcak ve nemli hava koşullarına sahip bölgeler olarak bilinir. Bu meyveler, bol güneş ışığı ve düzenli yağış gerektiren bitkilerde yetişir. Örnekler arasında mango, ananas, papaya, muz ve guava bulunur. Tropikal meyveler genellikle Asya, Afrika, Orta ve Güney Amerika'da yetişir."),
        
        Bilgiler(title: "Dünyanın en kötü kokan çiçeği 'Ceset Çiçeği' ", imageName: "cesetCicegi",txt: "Ceset çiçeği (Amorphophallus titanum), dünyanın en büyük çiçeklerinden biridir ve Endonezya'nın Sumatra adasında bulunur. Bu bitki, çürümüş et veya balık gibi kokan güçlü bir koku yayar, bu yüzden 'Ceset Çiçeği' olarak adlandırılır. Bu koku, böcekleri çekerek tozlaşmayı sağlar. Çiçeğin kokusu genellikle açtıktan sonraki ilk 8-12 saat içinde en yoğun olur."),
        
        Bilgiler(title: "Bitki yetiştrimek için hangi malzemeler gerekir?", imageName: "malzeme",txt: "Bitki yetiştirmek için öncelikle uygun bir saksı ve kaliteli toprak gereklidir. Bitkinin türüne göre doğru toprak karışımını seçmek önemlidir. Ayrıca, düzenli sulama için su ve bitkinin ihtiyaç duyduğu ışık miktarına uygun bir yer seçilmelidir. Bitkinin gelişimi için gerekli besinleri sağlamak amacıyla gübre kullanımı da önerilir. Son olarak, bitkinin sağlıklı büyümesini izlemek ve gerektiğinde budama yapmak önemlidir."),
        
        Bilgiler(title: "Hayalete benzeyen bu çiçeği daha önce gördünüz mü? ", imageName: "ghostOrchid",txt: "Hayalet orkide (Dendrophylax lindenii), nadir ve zor bulunan bir orkide türüdür. Bu bitki, Amerika Birleşik Devletleri'nin Florida eyaletinde ve Karayipler'deki bazı bölgelerde bulunur. Hayalet orkide, fotosentez yapabilen yapraklara sahip olmadığı için fotosentez için diğer bitkilere bağlıdır ve bu nedenle yetiştirilmesi oldukça zordur. Orkide, genellikle bataklık ormanlarında veya nemli ormanlık alanlarda görülür. Çiçekleri beyazdır ve hayalet gibi görünmelerinden dolayı bu ismi almıştır."),
    ]
    
    var selectedBilgi: Bilgiler?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.dataSource = self
        table.delegate = self
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let bilgi = data[indexPath.row]
        let cell = table.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        cell.label.text = bilgi.title
        cell.ImageVieew.image = UIImage(named: bilgi.imageName)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedBilgi = data[indexPath.row]
        performSegue(withIdentifier: "toBilgilerVC", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toBilgilerVC" {
            if let detailVC = segue.destination as? inBilgilerViewController {
                detailVC.gorsel = UIImage(named: selectedBilgi?.imageName ?? "")
                detailVC.baslik = selectedBilgi?.title
                detailVC.metin = selectedBilgi?.txt
            }
        }
    }
}

