//
//  Home_RootVC.swift
//  
//
//  Created by Luofei on 2017/6/7.
//
//

import UIKit
import Kingfisher



let urlStr = "http://pic35.photophoto.cn/20150601/0030014594765207_b.jpg"

class Home_RootVC: UIViewController,UITableViewDataSource,UITableViewDelegate{

    @IBOutlet weak var tableV_main: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableV_main.delegate = self
        tableV_main.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TCellHomeActivity", for: indexPath) as! TCellHomeActivity
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        let url = URL(string: urlStr)
        
        cell.imageV_Activity.kf.setImage(with: url, placeholder: createImageWithColor(color: UIColor.blue), options: nil, progressBlock: nil, completionHandler: nil)
        
        
        //        cell.imageV_Activity.kf.setImage(with: url, placeholder: createImageWithColor(color: UIColor.blue), options: [.transition(ImageTransition.fade(1))], progressBlock: { receivedSize, totalSize in
        //            print("\(indexPath.row + 1): \(receivedSize)/\(totalSize)")
        //        }) { image, error, cacheType, imageURL in
        //            print("\(indexPath.row + 1): Finished")
        //        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("\(indexPath.row)")
        
        guard let cell = tableView.cellForRow(at: indexPath) as? TCellHomeActivity else {
            return
        }
        
    }


}



//extension ViewController:UITableViewDataSource{
//    
//    
//    
//}
//
//extension ViewController: UITableViewDelegate {
//    
//}
