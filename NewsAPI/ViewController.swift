//
//  ViewController.swift
//  NewsAPI
//
//  Created by Noam Mizrachi on 24/06/2019.
//  Copyright © 2019 Noam Mizrachi. All rights reserved.
//

/*///////////////////////////   Important things   ///////////////////////////
 
 - URLSession runs in back thread.
 - Dispatching a main queue performes the code insede in the main thread so it is performed immediately.
 
 */ /////////////////////////////   End   //////////////////////////////

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // Properties
    
    @IBOutlet weak var tableview: UITableView! 
    var articles: [Article]? = []  //  each article is an object we created containing the 5 properties (Author, description...).
    var source = "techcrunch"  //  Initial name of the source
    let menuManager = MenuManager()  //  Of type MenuManager that we created for the menu
    
    // Methodes
    
    //  viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchArticles(fromSource: source)
    }
    
    
    //  The function that fetches the data.
    func fetchArticles(fromSource provider: String) {
        
        let urlRequest = URLRequest(url: URL(string: "https://newsapi.org/v2/top-headlines?sources=\(provider)&apiKey=24a1588fba0743c68558228db0e618b3")!)
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in  //  Data is the jason (data is the data returned from the urlRequest task ).
            if error != nil {
                print(error!)
                return
            }
            
            self.articles = [Article]()  //  initialize the articles array as empty array.
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String : AnyObject]  //  data is the json (the full json containing the articles, status and totalResults) returned from the URL session.
                if let articlesFromJson = json["articles"] as? [[String : AnyObject]] {  //  Only the articles array that contains dictionary for each article.
                    for articleFromArticles in articlesFromJson {  //  For loop trough each article dictionary.
                        let article = Article()  //  Each article is initialized, assigned with it's 5 properties and added to our articles array property.
                        if let title = articleFromArticles["title"] as? String, let author = articleFromArticles["author"] as? String, let desc = articleFromArticles["description"] as? String, let url = articleFromArticles["url"] as? String, let urlToImage = articleFromArticles["urlToImage"] as? String {
                            article.author = author
                            article.headline = title
                            article.desc = desc
                            article.url = url
                            article.imageUrl = urlToImage
                        }
                        self.articles?.append(article)
                    }
                }
                
                DispatchQueue.main.async {  //  Main thread is called to perform this task immediately - so each article that being added is immediately appears in our app on a cell.
                    self.tableview.reloadData()
                }
                
            } catch let error {
                print(error)
            }
        }
        task.resume()  // so the code inside the task scope will be execute
    }
    
    //  A UITableViewDataSource require for determin the number of rows in each section of the table.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.articles?.count ?? 0  // like an if statement: if the left side of the ?? is nil use the right side.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //  A UITableViewDataSource require for creating each cell.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "articleCell", for: indexPath) as! ArticleCell
        cell.title.text = self.articles?[indexPath.item].headline
        cell.desc.text = self.articles?[indexPath.item].desc
        cell.author.text = self.articles?[indexPath.item].author
        cell.imgView.downloadImage(from: (self.articles?[indexPath.item].imageUrl)!)
        return cell
    }
    
    //  When a row is selected this method is performed.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let webVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "web") as! WebviewViewController  //  "Main" referes to the Main.storyboard because there exists our new Web View Controller, and the "web" is the Webview view controller's Storyboard ID. This line of code will create our new web view controller.
        webVC.url = self.articles?[indexPath.item].url  //  Assigning the url of this row's fitting article to the web view.
        self.present(webVC, animated: true, completion: nil)  //  Will present the givven view controller.
    }
    
    //  When the menu button is pressed. We dragged it from the menu button and selected IBAction.
    @IBAction func menuPressed(_ sender: Any) {
        menuManager.openMenu()
        menuManager.mainVC = self
    }
    
}


// We are adding a method called downloadImage to the functionality of the UIImageView 
extension UIImageView {
    
    func downloadImage(from url: String) {
        let urlRequest = URLRequest(url: URL(string: url)!)
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in  //  Data is the data returned from the url request task.
            if error != nil {
                print(error!)
                return
            }
            DispatchQueue.main.sync {  //  Main thread is called to perform this task immediately.
                self.image = UIImage(data: data!)
            }
        }
        task.resume()  // so the code inside the task scope will be execute
    }
    
}

