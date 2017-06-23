//
//  TCell_userAddress.swift
//  BanShengYuan
//
//  Created by Luofei on 2017/6/19.
//  Copyright © 2017年 Luofei. All rights reserved.
//

import UIKit

enum AddressActionType {
    case SET
    case EDIT
    case DELETE
}

protocol UserAddressDelegate{
    func setAction(indexPath:IndexPath, actionType:AddressActionType)
}

class TCell_userAddress: UITableViewCell {
    
    var addressIndex:IndexPath? = nil
    
    var delegate:UserAddressDelegate?
    
    var model_address:ModelAddress?
    
    
    @IBOutlet weak var bton_set: UIButton!
    
    @IBOutlet weak var bton_edit: UIButton!
    
    @IBOutlet weak var bton_delete: UIButton!
    
    @IBOutlet weak var label_address: UILabel!
    
    @IBOutlet weak var label_name: UILabel!
    
    @IBOutlet weak var label_phone: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        bton_set.setImage(IBImageWithName("choose_s"), for: UIControlState.selected)
        
    }
    
    func setModel(toModel:ModelAddress){
        model_address = toModel
        label_name.text = toModel.name! as String
        label_phone.text = toModel.phone! as String
        label_address.text = "\(toModel.address_area!) \(toModel.address_Detail!)"
    }

    @IBAction func action_set(_ sender: Any) {
        self.delegate?.setAction(indexPath: addressIndex!,actionType: .SET)
    }
    
    @IBAction func action_delete(_ sender: Any) {
        self.delegate?.setAction(indexPath: addressIndex!,actionType: .DELETE)
    }
    
    @IBAction func action_edit(_ sender: Any) {
        self.delegate?.setAction(indexPath: addressIndex!,actionType: .EDIT)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
