//
//  ViewController.swift
//  PullMenuView
//
//  Created by Paxton on 2018/7/31.
//  Copyright © 2018年 px. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var rightBtn: UIButton!
    @IBOutlet weak var centerBtn: UIButton!
    @IBOutlet weak var leftBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func selectItem(_ sender: UIButton) {
        let configure = PXPullConfigure()
        configure.apexPoint = CGPoint(x: UIScreen.main.bounds.width - 45, y: 45)
        let view = PXPullView.init(configure: configure, titileArr: ["测试1","测试2","测试3","测试4","测试5"])
        view.show()
    }
    
    @IBAction func show(_ sender: UIButton) {
        let configure = PXPullConfigure()
        configure.apexPoint = CGPoint(x: sender.frame.maxX - sender.frame.width/2, y: sender.frame.maxY)
        let view = PXPullView.init(configure: configure, titileArr: ["测试1","测试2","测试3","测试4","测试5"])
        view.delegate = self
        view.show()
    }
    
}

extension ViewController: PXPullViewDelegate {
    func pullView(_ pullView: PXPullView, didSelectRowAt index: Int, title: String) {
        print(title)
    }
    
    
}
