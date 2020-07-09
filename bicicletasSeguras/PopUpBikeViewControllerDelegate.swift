//
//  PopUpBikeViewControllerDelegate.swift
//  bicicletasSeguras
//
//  Created by Carlos Obregón on 7/8/20.
//  Copyright © 2020 Carlos Obregón. All rights reserved.
//

import Foundation

protocol PopUpBikeViewControllerDelegate {
    func onAddBikeClick(bike: Bike)
    func onAlertBikeClick(bike: Bike)
}
