//
//  ViewController.swift
//  Project2
//
//  Created by Matina Dongol on 2023-07-28.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var location: UIImageView!
    @IBOutlet weak var searchButton: UIImageView!
    @IBOutlet weak var weatherImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.location.image = UIImage(systemName: "location.fill")
        self.searchButton.image = UIImage(systemName: "magnifyingglass.circle.fill")
        
        let config = UIImage.SymbolConfiguration(paletteColors: [.systemBlue, .systemYellow])
        self.weatherImage.preferredSymbolConfiguration = config
    }
    

}

