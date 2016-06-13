//
//  NewsTableViewController.swift
//  SlideMenu
//
//  Created by Simon Ng on 7/2/15.
//  Copyright (c) 2015 AppCoda. All rights reserved.
//

import UIKit

class NewsTableViewController: UITableViewController, MenuTransitionManagerDelegate {
    
    private var menuTransitionManager = MenuTransitionManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Home"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let menuTableViewController = segue.destinationViewController as! MenuTableViewController
        menuTableViewController.currentItem = self.title!
        
        // Assign animator
        self.menuTransitionManager.delegate = self
        menuTableViewController.transitioningDelegate = self.menuTransitionManager
    }

    func dismiss() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func unwindToHome(segue: UIStoryboardSegue) {
        let sourceController = segue.sourceViewController as! MenuTableViewController
        self.title = sourceController.currentItem
    }

    


}
