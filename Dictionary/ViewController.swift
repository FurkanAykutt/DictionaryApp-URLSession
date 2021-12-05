//
//  ViewController.swift
//  Dictionary
//
//  Created by Ebubekir Aykut on 22.11.2021.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var kelimeListesi = [Kelimeler]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        searchBar.delegate = self
        
        tumKelimelerAl()
        
      
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let indeks = sender as? Int
        
        let destinationVC = segue.destination as! DetailsViewController
        destinationVC.kelime = kelimeListesi[indeks!]
    }
    
    func tumKelimelerAl(){
        
        let url = URL(string: "http://kasimadalan.pe.hu/sozluk/tum_kelimeler.php")!
        //istek yapılacak url
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            //İşlem yapmak için yapı
            
            if error != nil || data == nil {//hata ve veri kontrolü
                print("Hata")
                return//Hata oluşursa task çalışması durdurulur.
            }
            
            do {

                let cevap = try JSONDecoder().decode(KelimelerCevap.self, from: data!)
                
                if let gelenKelimeListesi = cevap.kelimeler {
                  
                    self.kelimeListesi = gelenKelimeListesi
                  
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
               
                
            } catch {
                print("JSON error: \(error.localizedDescription)")
            }
            
        }.resume()//İşlem bitince çalışma tekrar çalışma için bekletilir.
        
    }
    
    func aramaYap(aramaKelimesi:String){
        
        var request = URLRequest(url: URL(string: "http://kasimadalan.pe.hu/sozluk/kelime_ara.php")!)
        
        request.httpMethod = "POST"
        
        let postString = "ingilizce=\(aramaKelimesi)"
        
        request.httpBody = postString.data(using: .utf8)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            //İşlem yapmak için yapı
            
            if error != nil || data == nil {//hata ve veri kontrolü
                print("Hata")
                return//Hata oluşursa task çalışması durdurulur.
            }
            
            do {

                let cevap = try JSONDecoder().decode(KelimelerCevap.self, from: data!)
                
                if let gelenKelimeListesi = cevap.kelimeler {
                  
                    self.kelimeListesi = gelenKelimeListesi
                  
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
               
                
            } catch {
                print("JSON error: \(error.localizedDescription)")
            }
            
        }.resume()//İşlem bitince çalışma tekrar çalışma için bekletilir.
        
    }
}

extension ViewController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return kelimeListesi.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let kelime = kelimeListesi[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath) as! TableViewCell
        
        cell.ingilizceLabel.text = kelime.ingilizce
        cell.turkceLabel.text = kelime.turkce
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toDetailsVC", sender: indexPath.row)
    }
}



extension ViewController:UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        
        aramaYap(aramaKelimesi: searchText)
    }
}
