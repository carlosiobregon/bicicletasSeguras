//
//  PopUpViewController.swift
//  Copa Airlines
//
//  Created by Fredy Mauricio Navarrete Molano on 3/28/19.
//  Copyright © 2019 Copa Airlines. All rights reserved.
//

import UIKit

class PopUpViewController: UIViewController {
    
//    MARK: - UI Elements
    @IBOutlet weak var popUpContainer: UIView! {
        didSet{
            popUpContainer.layer.cornerRadius = 24
            popUpContainer.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        }
    }
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var logOutButton: UIButton!
    @IBOutlet weak var topCloseButton: UIButton!
    
    @IBOutlet weak var phoneImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
//    MARK: - Atributes
    var bikeUser: BikeUser?
    
//    MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let user = bikeUser else { return }
        nameLabel.text = user.name
        emailLabel.text = user.email
        if let bikes = user.bikes, bikes.count > .zero {
            descriptionLabel.text = "\(bikes.count) bicicletas asociadas"
        } else {
            descriptionLabel.text = "No tiene bicicletas asociadas"
        }
    }
    
//    MARK: - Actions
    @IBAction func logOutClick(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onCancelClick(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
