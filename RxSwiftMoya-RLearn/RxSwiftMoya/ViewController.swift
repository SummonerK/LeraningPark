//
//  ViewController.swift
//  RxSwiftMoya
//
//  Created by Chao Li on 9/20/16.
//  Copyright © 2016 ERStone. All rights reserved.
//

import UIKit
import RxSwift

class ViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    let viewModel  = ViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        viewModel.getPosts()
            .subscribe(onNext: { (posts: [Post]) in
                //do something with posts
                print(posts.count)
            },onError:{error in
                print("Error//////Error \((error as! RxSwiftMoyaError).rawValue)")
            })
            .addDisposableTo(disposeBag)

        viewModel.createPost(title: "Title 1", body: "Body 1", userId: 1)
            .subscribe(onNext: { (post: Post) in
                //do something with post
                print("if PostData \(post.title!)")
                
                print("if Post Des \(post.description)")
                
            },onError:{error in
                print("Error//////Error \((error as! RxSwiftMoyaError).rawValue)")
            })
            .addDisposableTo(disposeBag)
        
        viewModel.getVCode(cTel: "15600703631", type: "1")
                .subscribe(onNext: { (post: PostCV) in
                    //do something with post
                    
                    print("\(post.description)")
                    
                },onError:{error in
                    print("Error//////Error \(error)")
                })
                .addDisposableTo(disposeBag)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

