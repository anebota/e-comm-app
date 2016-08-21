//
//  ProductDetailViewController.swift
//  MoltinSwiftExample
//
//  Created by Dylan McKee on 16/08/2015.
//  Copyright (c) 2015 Moltin. All rights reserved.
//

import UIKit
import Moltin
import SwiftSpinner

class ProductDetailViewController: UIViewController {
    
    var productDict:NSDictionary?
    
    @IBOutlet weak var headerView: UIView!
    
    @IBOutlet weak var descriptionTextView:UITextView?
    @IBOutlet weak var productImageView:UIImageView?
    @IBOutlet weak var buyButton:UIButton?
    @IBOutlet weak var productTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        headerView?.backgroundColor = Color.headerColor
        buyButton?.backgroundColor = Color.moltinColor
        buyButton?.titleLabel?.font = Font.productTextview
        descriptionTextView?.font = Font.productTextview
        productTitle?.font = Font.cellheaderlabel
        productTitle?.textColor = Color.moltinColor

        // Do any additional setup after loading the view.
        if let description = productDict!.value(forKey: "description") as? String {
            self.descriptionTextView?.text = description
        }
        
        if let title = productDict!.value(forKey: "title") as? String {
            self.productTitle?.text = title
        }

        if let price = productDict!.value(forKeyPath: "price.data.formatted.with_tax") as? String {
            let buyButtonTitle = String(format: "Buy Now (%@)", price)
            self.buyButton?.setTitle(buyButtonTitle, for: UIControlState())
        }
        
        var imageUrl = ""
        
        if let images = productDict!.object(forKey: "images") as? NSArray {
            if (images.firstObject != nil) {
                imageUrl = images.firstObject?.value(forKeyPath: "url.https") as! String
            }
            
        }
        productImageView?.sd_setImage(with: URL(string: imageUrl))
    }
    
    
    //fix TextView Scroll first line
    override func viewWillAppear(_ animated: Bool) {
        self.descriptionTextView!.isScrollEnabled = false
    }
    //fix TextView Scroll first line
    override func viewDidAppear(_ animated: Bool) {
        self.descriptionTextView!.isScrollEnabled = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func buyProduct(_ sender: AnyObject) {
        // Add the current product to the cart
        let productId:String = productDict!.object(forKey: "id") as! String
        
        SwiftSpinner.show("Updating cart", animated: true)
        
        Moltin.sharedInstance().cart.insertItem(withId: productId, quantity: 1, andModifiersOrNil: nil, success: { (response) -> Void in
            // Done.
            // Switch to cart...
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.switchToCartTab()
            
            // and hide loading UI
            SwiftSpinner.hide()
            
            
        }) { (response, error) -> Void in
            // Something went wrong.
            // Hide loading UI and display an error to the user.
            SwiftSpinner.hide()
            
            AlertDialog.showAlert("Error", message: "Couldn't add product to the cart", viewController: self)
            print("Something went wrong...")
            print(error)
        }
        
    }
    


}
