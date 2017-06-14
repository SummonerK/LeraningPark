//
//  HomeHeaderV.swift
//  BanShengYuan
//
//  Created by Luofei on 2017/6/12.
//  Copyright © 2017年 Luofei. All rights reserved.
//

import UIKit

protocol HomeHeaderDelegate{
    func activitiesAction(path : String)
    func itemActionWithIndexPath(indexPath : IndexPath)
}

class HomeHeaderV: UITableViewCell {
    
    var delegate:HomeHeaderDelegate?
    
    @IBOutlet weak var imgv_HomeHeader: UIImageView!
    
    @IBOutlet weak var CollectionV_HomeHeader: UICollectionView!
    
    @IBOutlet weak var search_homeHeader: UISearchBar!
    
    var array_titles:[String] = ["品牌","活动","商户","停车","魔门音乐","空中花市","会员积分","更多"]
    var array_images:[String] = ["item1_pinpai","item2_activity","item3_shanghu","item4_parking","item5_music","item6_huashi","item7_vip","item8_more"]

    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
  
    }
    
    @IBAction func HomeImageVAction(_ sender:Any){
        
        self.delegate?.activitiesAction(path: "homePath")
    }
    
    
    func setupView(){
        
        CollectionV_HomeHeader.register(UINib.init(nibName: "CCellHomeHeader", bundle: nil), forCellWithReuseIdentifier: "CCellHomeHeader")
        
//        search_homeHeader.backgroundImage = UIImage()
        
//        let seachTextFeild = search_homeHeader.subviews.first?.subviews.last
////        seachTextFeild?.backgroundColor = UIColor.white
        
        
        
        
//        let  textFieldInsideSearchBar=search_homeHeader.value(forKey: "searchField")as?UITextField
////        textFieldInsideSearchBar?.textColor=UIColor.white
//        textFieldInsideSearchBar?.background = createImageWithColor(color: UIColor.brown)
//        textFieldInsideSearchBar?.backgroundColor = UIColor.brown
        
//        search_homeHeader.layer.cornerRadius = 4
//        search_homeHeader.layer.borderColor = UIColor.black.cgColor
//        search_homeHeader.layer.borderWidth = 2

//        textFieldInsideSearchBar?.layer.cornerRadius = 4
//        textFieldInsideSearchBar?.layer.borderColor = UIColor.lightGray.cgColor
//        textFieldInsideSearchBar?.layer.borderWidth = 2
        
        
//        search_homeHeader.tintColor = UIColor.white
//        search_homeHeader.backgroundImage = createImageWithColor(color: UIColor.white)
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}


extension HomeHeaderV:UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        
        self.delegate?.itemActionWithIndexPath(indexPath: indexPath)
        
    }
    
}

extension HomeHeaderV:UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int{
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CCellHomeHeader", for: indexPath) as! CCellHomeHeader
        
        cell.label_title.text = array_titles[indexPath.row]
        cell.image_icon.image = UIImage.init(named: array_images[indexPath.row])

        return cell
        
    }
    
}

extension HomeHeaderV:UICollectionViewDelegateFlowLayout{
    
    //返回cell 上下左右的间距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        return CGSize.init(width: IBScreenWidth*0.9/5, height: IBScreenWidth*60/375)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat{
        return IBScreenWidth*10/375
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        return UIEdgeInsetsMake(IBScreenWidth*10/375, 0, 0, 0)
    }
    
}

