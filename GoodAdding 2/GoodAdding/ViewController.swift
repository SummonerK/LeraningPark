//
//  ViewController.swift
//  GoodAdding
//
//  Created by Luofei on 2017/6/7.
//  Copyright © 2017年 Luofei. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ViewController:UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        return 100
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TCellGoods", for: indexPath) as! TCellGoods
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        cell.buttonClickBack = {
            (view_temp) -> Void in
            var rect : CGRect = tableView.rectForRow(at: indexPath)
            //获取当前cell的相对坐标
            rect.origin.y = (rect.origin.y - tableView.contentOffset.y)
            
            var imageViewRect : CGRect = CGRect.init(x: view_temp.center.x-15, y: view_temp.center.y-15, width: CGFloat(size_goodslayer), height: CGFloat(size_goodslayer))
            imageViewRect.origin.y = rect.origin.y + imageViewRect.origin.y
            
            AddingTool().startAnimation(view: cell.goodsImg, andRect: imageViewRect, andFinishedRect: CGPoint(x:self.view.frame.size.width/4 * 3,  y:self.view.frame.size.height-49), andFinishBlock: { (finished : Bool) in
                
                let tabBtn : UIView = (self.tabBarController?.tabBar.subviews[2])!
                AddingTool().shakeAnimation(shakeView: tabBtn)
            })
        }
        
        return cell
    }
    
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? TCellGoods else {
            return
        }
        
    }
}

