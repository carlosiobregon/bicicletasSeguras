//
//  PopUpBikeViewController.swift
//  Copa Airlines
//
//  Created by Fredy Mauricio Navarrete Molano on 3/28/19.
//  Copyright © 2019 Copa Airlines. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class PopUpBikeViewController: UIViewController {
    
//    MARK: - UI Elements
    @IBOutlet weak var popUpContainer: UIView! {
        didSet{
            popUpContainer.layer.cornerRadius = 24
            popUpContainer.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        }
    }
    @IBOutlet weak var insuranceTextField: UITextField!
    @IBOutlet weak var identifierTextField: UITextField!
    @IBOutlet weak var brandTextField: UITextField!
    @IBOutlet weak var colorTextField: UITextField!
    @IBOutlet weak var header: UIStackView!
    @IBOutlet weak var addBikeButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var topCloseButton: UIButton!
    
    @IBOutlet weak var notificationContentView: UIView! {
        didSet {
            notificationContentView.backgroundColor = UIColor.clear
            notificationContentView.isAccessibilityElement = false
        }
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    
    var delegate: PopUpBikeViewControllerDelegate?
   
//    MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
//    MARK: - Actions
    @IBAction func onAddBikeClick(_ sender: Any) {
        //Validar campos esten diligenciados
        //Armar objeto
        guard let idBike = identifierTextField.text,
            let idSecure = insuranceTextField.text,
            let brandmark = brandTextField.text,
            let color = colorTextField.text else {
            return
        }
        
        let bike = Bike(idBike: idBike, idSecure: idSecure, brandmark: brandmark, color: color)
        delegate?.onAddBikeClick(bike: bike)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onCancelClick(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
