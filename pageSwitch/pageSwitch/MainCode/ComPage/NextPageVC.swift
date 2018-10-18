//
//  NextPageVC.swift
//  pageSwitch
//
//  Created by Luofei on 2018/10/16.
//  Copyright © 2018年 FreeMud. All rights reserved.
//

import UIKit

class NextPageVC: UIViewController {
    
    // MARK:- viewLayout 控件区
    
    @IBOutlet weak var CVMain:UICollectionView!
    
    @IBOutlet weak var bton_tip: UIButton!
    
    // MARK:- parameter 参数区
    
    let arrayIcons = IBLPlistM.IBLPlistArrayFrom(plistName: "homePath")
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        print(self.SWPagePram)
        
        setContentView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func actionTipSender(_ sender: Any) {
        
        bton_tip.IBLViewShakeShake(.horizontal)
        
        let isPad = IBLDeviceIPad ? "iPad" : "iPhone"
        
        bton_tip.setTitle(isPad, for: .normal)
        
        PrintFM("arrayIcons = \(arrayIcons)")
        
    }
    
    @IBAction func goBack(_ sender: Any) {
        self.pageBackContainer!.SWBlockBack!("hello nextvc")
        self.SWDismissScene(animated: true)
    }
    
    func setContentView() {
        
        let flowLayout = UICollectionViewFlowLayout()
        
        flowLayout.scrollDirection = UICollectionViewScrollDirection.vertical
        
        flowLayout.sectionInset = UIEdgeInsetsMake(IBLDiff_home_space, IBLDiff_home_space, 0, IBLDiff_home_space)
        
        flowLayout.minimumLineSpacing = IBLDiff_home_space
        
        flowLayout.minimumInteritemSpacing = IBLDiff_home_space
        
        CVMain.backgroundColor = UIColor.clear
        
        CVMain.collectionViewLayout = flowLayout
        
        CVMain.registerNibClassName(CCellHomeIcon.self)
        
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


extension NextPageVC:UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize{
        return CGSize.init(width: IBScreenWidth, height: 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        let space = (IBLDiff_home_itemNum + 1)*IBLDiff_home_space
        
        return CGSize.init(width: (IBScreenWidth - space)/IBLDiff_home_itemNum, height: IBLDiff_home_itemHeight)
    }
    
}

extension NextPageVC:UICollectionViewDataSource,UICollectionViewDelegate{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int{
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        
        return arrayIcons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CCellHomeIcon", for: indexPath) as! CCellHomeIcon
        
        let item = arrayIcons[indexPath.row] as! NSDictionary
        
        print("item = \(item["title"]!)")
        
        let title = item["title"] as? String
        
        let isValue = item["isValue"] as? Bool
        
        if isValue!{
            cell.backgroundColor = IBLColorSuitDeep
        }else{
            cell.backgroundColor = IBLColorSuitMiRed
        }
        
        cell.label_title.text = title
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        
        let cell = collectionView.cellForItem(at: indexPath) as! CCellHomeIcon
        
        let item = arrayIcons[indexPath.row] as! NSDictionary
        
        let isValue = item["isValue"] as? Bool
        
        if !isValue!{
            cell.IBLViewShakeShake(.horizontal)
        }
        
        
    }
    
}
