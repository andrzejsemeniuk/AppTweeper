//
//  ViewControllerForScreenSearch.swift
//  productTweeper
//
//  Created by andrzej semeniuk on 7/19/17.
//  Copyright © 2017 Andrzej Semeniuk. All rights reserved.
//

import Foundation
import UIKit

class ViewControllerForScreenSearch: UIViewController
{
    
    var                 tweets:     [TweetModel]    = [TweetModel]()
    
    var                 tweet:      TweetModel?
    
    @IBOutlet weak var  label:      UILabel!
    
    @IBOutlet weak var  table:      UITableView!
    
    @IBOutlet weak var  search:     UISearchBar!
    
    
    var                 refresh                     = UIRefreshControl()
    
    
    
    
    var                 maximumTweetsToDisplay: Int {
        return 120
    }
    
    
    
    
    
    
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        // Do any additional setup after loading the view, typically from a nib.
        
        table.delegate              = self
        table.dataSource            = self
        table.rowHeight             = UITableViewAutomaticDimension
        table.estimatedRowHeight    = 80
        
        search.delegate             = self
        search.text                 = ""
        
        refresh.addTarget(self, action: #selector(ViewControllerForScreenSearch.handleRefresh), for: UIControlEvents.valueChanged)
        
        table.insertSubview(refresh, at: 0)
        
        table.delegate              = self
        table.dataSource            = self
    }
    
    
    
    
    func handleRefresh()
    {
        print("reloading... for \(search.text)")
        
        // "make a call to twitter to retrieve tweets matching search text"
        
        Twitter.instance.tweetsFromSearch(search.text!, count:40, handler: { freshTweets in
            
            self.tweets = freshTweets! + self.tweets
            
            self.doRefresh()
        })
        
        
        search.resignFirstResponder()
    }
    
    
    
    
    func doRefresh()
    {
        // "make a call to twitter to retrieve tweets matching search text"
        
        var filterWords:    Set<String> = []
        var filterUsers:    Set<String> = []
        var filterIds:      Set<Int> = []
        
        
        // "get filter words and users from user defaults"
        
        let defaults = UserDefaults.standard
        
        if let words=defaults.string(forKey: "Words") {
            filterWords = Set(words.components(separatedBy: ",").map({
                $0.lowercased().trimmed()
            }).filter({0<$0.length}))
        }
        if let users=defaults.string(forKey: "Users") {
            filterUsers = Set(users.components(separatedBy: ",").map({
                $0.lowercased().trimmed()
            }).filter({0<$0.length}))
        }
        if let ids=defaults.string(forKey: "Ids") {
            let idsInStringForm = Array(ids.components(separatedBy: ",").map({
                $0.lowercased().trimmed()
            }).filter({0<$0.length}))
            for id in idsInStringForm {
                filterIds.insert(Int(id)!)
            }
        }
        
        
        let ids = NSMutableSet()
        
        
        tweets = tweets.filter({
            
            let tweet = $0
            
            
            let duplicate = ids.contains(tweet.id)
            
            ids.add(tweet.id)
            
            if duplicate {
                print("duplicate tweet \(tweet.user)")
                return false
            }
            else if tweet.blocked {
                print("blocked tweet \(tweet.user)")
                return false
            }
            else if filterIds.contains(tweet.id) {
                return false
            }
            
            
            do
            {
                var filterWord:     String  = ""
                var filterUser:     String  = ""
                
                
                for word in filterWords {
                    if tweet.text.lowercased().range(of: word) != nil {
                        filterWord = word
                        break
                    }
                }
                
                
                if filterWord.empty
                {
                    for word in filterUsers
                    {
                        if tweet.user.name.lowercased() == word {
                            filterUser = word
                            break
                        }
                        if tweet.user.screen_name.lowercased() == word {
                            filterUser = word
                            break
                        }
                    }
                }
                
                
                if filterWord.empty && filterUser.empty
                {
                    print(" adding tweet with id \(tweet.id)")
                    
                    return true
                }
                else
                {
                    if !filterUser.empty {
                        print(" filtered out based on user: \(filterUser), user.name: \(tweet.user.name), user.screen_name: \(tweet.user.screen_name)")
                    }
                    if !filterWord.empty {
                        print(" filtered out based on word: \(filterWord), text: \(tweet.text)")
                    }
                    
                    return false
                }
            }
        })
        
        // "trim array of tweets if it is too long"
        
        tweets      = tweets.subarray(length:maximumTweetsToDisplay)
        
        table       .reloadData()
        
        refresh     .endRefreshing()
    }
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        table.reloadData()
    }
    
    
    
    override func didReceiveMemoryWarning() {
        
        tweets      = []
        
        table       .reloadData()
        
        super.didReceiveMemoryWarning()
    }
    
}

extension ViewControllerForScreenSearch : UITableViewDataSource {
    
    func numberOfSections  (in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView         (_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func tableView         (_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell                = table.dequeueReusableCell(withIdentifier: "TweetView") as! TweetView
        
        cell.model              = tweets[indexPath.row]
        
        return cell
    }
    
}

extension ViewControllerForScreenSearch : UITableViewDelegate {
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return NO if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
     if editingStyle == .Delete {
     // Delete the row from the data source
     tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
     } else if editingStyle == .Insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return NO if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using [segue destinationViewController].
     // Pass the selected object to the new view controller.
     }
     */
    
}



extension ViewControllerForScreenSearch : UISearchBarDelegate
{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        if searchBar==search
        {
            print("search text did change: \(searchText)")
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        if searchBar==search
        {
            print("search for text: \(search.text)")
            handleRefresh()
        }
    }
    
}
