//
//  homeRootVC.swift
//  FMPOSRefactor
//
//  Created by Luofei on 2018/10/19.
//  Copyright © 2018年 FreeMud. All rights reserved.
//

import UIKit

class homeRootVC: UIViewController {
    
    // MARK:- viewLayout 控件区
    
    @IBOutlet weak var CVMain:UICollectionView!
    
    // MARK:- parameter 参数区
    
    let arrayIcons = IBLPlistM.IBLPlistArrayFrom(plistName: "homePath")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 11.0, *) {
//            CVMain.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        setContentView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setContentView() {
        
        let flowLayout = UICollectionViewFlowLayout()
        
        flowLayout.scrollDirection = UICollectionViewScrollDirection.vertical
        
        CVMain.backgroundColor = IBLColorLHWhiteLight
        
        CVMain.collectionViewLayout = flowLayout
        
        CVMain.registerNibClassName(CCellHomeIcon.self)
        CVMain.registerNibClassName(CCellHomeHead.self)
        
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}


extension homeRootVC:UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        if section == 0{
            return UIEdgeInsetsMake(0, 0, 0, 0)
        }
        if section == 1{
            return UIEdgeInsetsMake(IBLDiff_home_space, IBLDiff_home_space, 0, IBLDiff_home_space)
        }
        
        return UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat{
        if section == 0{
            return 0
        }
        if section == 1{
            return IBLDiff_home_space
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat{
        if section == 0{
            return 0
        }
        if section == 1{
            return IBLDiff_home_space
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        if indexPath.section == 0 {
            return CGSize.init(width: IBScreenWidth, height: IBLDiff_home_HeadHeight)
        }
        
        if indexPath.section == 1{
            let space = (IBLDiff_home_itemNum + 1)*IBLDiff_home_space
            
            return CGSize.init(width: (IBScreenWidth - space)/IBLDiff_home_itemNum, height: IBLDiff_home_itemHeight)
        }
        
        return CGSize.init(width: IBScreenWidth, height: 100)
    }
    
}

extension homeRootVC:UICollectionViewDataSource,UICollectionViewDelegate{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int{
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        
        
        if section == 0 {
            return 1
        }
        
        if section == 1 {
            
            return arrayIcons.count
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        if indexPath.section == 0{
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CCellHomeHead", for: indexPath) as! CCellHomeHead
            
            return cell
            
        }
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CCellHomeIcon", for: indexPath) as! CCellHomeIcon
        
        let item = arrayIcons[indexPath.row] as! NSDictionary
        
        print("item = \(item["title"]!)")
        
        let title = item["title"] as? String
        
        cell.imageV_icon.IBImageSys((item["imagen"] as? String)!)
        
//        let isValue = item["isValue"] as? Bool        
//        if isValue!{
//            cell.backgroundColor = IBLColorSuitDeep
//        }else{
//            cell.backgroundColor = IBLColorWhite
//        }
        
        cell.label_title.text = title
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        
        if indexPath.section == 0 {
            PrintFM("Pay")
        }
        
        if indexPath.section == 1 {
            
            let cell = collectionView.cellForItem(at: indexPath) as! CCellHomeIcon
            
            let item = arrayIcons[indexPath.row] as! NSDictionary
            
            let isValue = item["isValue"] as? Bool
            
            cell.backgroundColor = IBLColorLHGaryLight
            
            cell.IBLViewWaveShake()
            
            if !isValue!{
                DispatchQueue.main.after(0.6, execute: {
                    cell.IBLViewShakeShake(.horizontal)
                    DispatchQueue.main.after(0.6, execute: {
                        cell.backgroundColor = IBLColorWhite
                        LoginAdjust()
                    })
                })
            }else{
                DispatchQueue.main.after(0.6, execute: {
                    cell.backgroundColor = IBLColorWhite
                })
            }
            
        }
    
    }
    
}
