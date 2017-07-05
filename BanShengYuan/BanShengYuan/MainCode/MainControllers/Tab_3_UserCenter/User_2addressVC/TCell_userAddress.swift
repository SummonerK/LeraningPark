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
    
    var model_address:ModelAddressItem?
    
    
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
    
    func setModel(toModel:ModelAddressItem){
        model_address = toModel
        
        if let receiverName = toModel.receiverName{
            label_name.text = receiverName
        }
        
        label_phone.text = toModel.receiverPhone! as String
        label_address.text = "\(toModel.area!) \(toModel.address!)"
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
