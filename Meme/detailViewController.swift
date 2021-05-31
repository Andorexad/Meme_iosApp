//
//  detailViewController.swift
//  Meme
//
//  Created by Andi Xu on 5/31/21.
//

import UIKit

class detailViewController: UIViewController {

   
    var m: Meme!
    
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var toplabel: UITextField!
    
    @IBOutlet weak var botlabel: UITextField!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.toplabel.text = self.m.topText
        self.botlabel.text = self.m.bottomText
        self.tabBarController?.tabBar.isHidden = true
        self.imageView!.image = self.m.oriImage
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }

}
