//
//  MenuManager.swift
//  NewsAPI
//
//  Created by Noam Mizrachi on 26/06/2019.
//  Copyright © 2019 Noam Mizrachi. All rights reserved.
//

import UIKit

class MenuManager: NSObject, UITableViewDelegate, UITableViewDataSource {
    
  
//  Properties
    
    let blackview = UIView()
    let menuTableView = UITableView()
    let arrayOfSources = ["TechCrunch", "TechRadar"]
    var mainVC: ViewController?
    
//  Methodes
    
    public func openMenu() {
        if let window = UIApplication.shared.keyWindow {  //  Getting our full window from our app delegate. (if we have a window, do...).
            blackview.frame = window.frame  //  blackview gets expaned to the window dimantions.
            blackview.backgroundColor = UIColor(white: 0, alpha: 0.5)  //  "white: 0" - black backgound color to the blackview, "alpha: 0.5" - gives transparency to the color of the backgound.
            blackview.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissMenu)))  //  When tapping on the screen the "dismissMenu" func is activated.
            
            let heigt: CGFloat = CGFloat(50 * arrayOfSources.count)  //  The hight of the table view = hight of each cell (50) times the number of cells.
            let y = window.frame.height - heigt  //  For getting the table to be from the bottom of the screen, up.
            menuTableView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: heigt)  //  x is the distance from the table view left (+) and right (-) margins to the window frame sindes (left and right). y is the distance from the table view bottom (+) and top (-) margins to the window frame (buttom and top). if we add to x the table view frame will move to the right, if we will subtrackt, it will move to the left. if we add to y the table view frame will move down, if we will subtrackt, it will move up.
            
            window.addSubview(blackview)  //  adding the blackview to our window.
            window.addSubview(menuTableView)  //  adding the menu to our window.
            
            UIView.animate(withDuration: 0.5, animations: {  //  "0.5" = half a second of the animation.
                self.blackview.alpha = 1  //  changing the alpha value from 0.5 to 1 so now the transparancy will be very dark.
                self.menuTableView.frame.origin.y = y  //  getting the table view to move up by subtracting from its frame y value. Value of zero will create 0 distance between the table top and the app window top.
            })
        }
    }
    
    @objc public func dismissMenu() {  
        UIView.animate(withDuration: 0.5, animations: {  //  "0.5" = half a second of animation.
            self.blackview.alpha = 0  //  Makes the blackview fully transparent by changing from 1 (dark) to 0.
        })
        if let window = UIApplication.shared.keyWindow {
            self.menuTableView.frame.origin.y = window.frame.height  //  menu table top is now at the buttom of the app window, that is, hidden.
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50  //  Height for each row in the menu table view.
    }
    
    //  When a row in the menu table view is selected.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = mainVC {
            vc.source = arrayOfSources[indexPath.item].lowercased()
            vc.fetchArticles(fromSource: arrayOfSources[indexPath.item].lowercased())
            dismissMenu()
        }
    }
    
    override init() {
        super.init()
        menuTableView.delegate = self
        menuTableView.dataSource = self
        menuTableView.isScrollEnabled = false
        menuTableView.bounces = false
        menuTableView.register(BaseViewCell.classForCoder(), forCellReuseIdentifier: "cellId")
    }
    
    //  One section of rows.
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //  Returning the number of rows in the menu table as the number of elements in the sources array.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfSources.count
    }
    
    //  Returning each cell on the menu table view with it's source name.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as UITableViewCell
        cell.textLabel?.text = arrayOfSources[indexPath.item]
        return cell
    }
    
}
