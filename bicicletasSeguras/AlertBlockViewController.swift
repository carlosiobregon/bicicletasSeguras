//
//  AlertBlockViewController.swift
//  Copa Airlines
//
//  Created by Fredy Mauricio Navarrete Molano on 3/28/19.
//  Copyright © 2019 Copa Airlines. All rights reserved.
//

import UIKit

class AlertBlockViewController: UIViewController {
    
//    MARK: - UI Elements
    @IBOutlet weak var popUpContainer: UIView! {
        didSet{
            popUpContainer.layer.cornerRadius = 24
            popUpContainer.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        }
    }
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var blockButton: UIButton!
    @IBOutlet weak var topCloseButton: UIButton!
    
    @IBOutlet weak var phoneImageView: UIImageView!
    
//    MARK: - Atributes
    var bike: Bike?
    var delegate: PopUpBikeViewControllerDelegate?
    
//    MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
//    MARK: - Actions
    @IBAction func onBlockClick(_ sender: Any) {
        if let bike = self.bike {
            delegate?.onAlertBikeClick(bike: bike)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onCancelClick(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
