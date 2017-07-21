//
//  ViewControllerForScreenSearch.swift
//  productTweeper
//
//  Created by andrzej semeniuk on 7/19/17.
//  Copyright © 2017 Andrzej Semeniuk. All rights reserved.
//

import Foundation
import UIKit

protocol ViewControllerForScreenSearchDelegate : class {
    func searchPhraseWasUpdated         (to:String)
    
    var  searchPhrase           : String { get }
}

class ViewControllerForScreenSearch: UITableViewController
{
    
    var                 tweets      : [TweetModel]  = [TweetModel]()
    
    var                 tweet       : TweetModel?
    
    var                 search      : UISearchBar   = UISearchBar()
    
    var                 refresh                     = UIRefreshControl()
    
    
    var                 maximumTweetsToDisplay: Int {
        return 120
    }

    weak var            delegate    : ViewControllerForScreenSearchDelegate?
    
    
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        search.delegate                 = self
        search.text                     = self.delegate?.searchPhrase ?? ""
        search.autocapitalizationType   = .none
        
        tableView.rowHeight             = UITableViewAutomaticDimension
        tableView.estimatedRowHeight    = 80
        
        refresh.addTarget(self, action: #selector(ViewControllerForScreenSearch.handleRefresh), for: UIControlEvents.valueChanged)
        
        tableView.insertSubview(refresh, at: 0)
        
        tableView.register(UINib(nibName: "TweetView", bundle: nil), forCellReuseIdentifier: "TweetView")
    }
    
    
    
    
    func handleRefresh()
    {
        let text = search.text ?? ""
        
        self.title = "\"\(text)\""
        
        self.delegate?.searchPhraseWasUpdated(to: text)
        
        // TODO: ADD ACTIVITY INDIATOR
        print("reloading... for \(text)")
        
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
        
        self.view.addSubview(indicator)
        indicator.backgroundColor = UIColor.init(hsba: [0.6,1.0,1.0,0.5])
        indicator.frame = self.view.frame
        indicator.startAnimating()
        
        // "make a call to twitter to retrieve tweets matching search text"
        
        // TODO: PARAMETERIZE COUNT
        Twitter.instance.tweetsFromSearch(text, count:40, handler: { [weak self] freshTweets in
            
            guard let `self` = self else {
                return
            }
            
            indicator.stopAnimating()
            indicator.removeFromSuperview()
            
            if let tweets = freshTweets {
                self.tweets = tweets + self.tweets
                self.doRefresh()
            }
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
        
        tableView   .reloadData()
        
        refresh     .endRefreshing()
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.handleRefresh()
    }
    
    
    
    override func didReceiveMemoryWarning() {
        
        tweets      = []
        
        tableView   .reloadData()
        
        super.didReceiveMemoryWarning()
    }
    
}

extension ViewControllerForScreenSearch {
    
    override func numberOfSections  (in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView         (_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1+tweets.count
    }
    
    override func tableView         (_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = UITableViewCell()
            search.frame.size = cell.contentView.frame.size
            cell.contentView.addSubview(search)
            return cell
        }
        
        let tweet = tweets[indexPath.row-1]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "TweetView") as? TweetView {
        
            cell.model = tweet
        
            return cell
        }
        
        let cell = UITableViewCell()
        
        cell.textLabel?.text = tweet.text
        
        return cell
    }
    
}

extension ViewControllerForScreenSearch {
    
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
        print("search text did change: \(searchText)")
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
//        handleRefresh()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        handleRefresh()
    }
    
}
