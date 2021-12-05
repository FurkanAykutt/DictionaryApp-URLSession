//
//  DetailsViewController.swift
//  Dictionary
//
//  Created by Ebubekir Aykut on 22.11.2021.
//

import UIKit

class DetailsViewController: UIViewController {
    @IBOutlet weak var ingilizceDetay: UILabel!
    @IBOutlet weak var turkceDetay: UILabel!
    
    var kelime:Kelimeler?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let k = kelime{
            ingilizceDetay.text = k.ingilizce
            turkceDetay.text = k.turkce
        }
    }
    


}
