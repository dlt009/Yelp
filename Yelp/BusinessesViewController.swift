//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UIScrollViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!

    var refreshControl: UIRefreshControl!
    var businesses: [Business]!
    var searchBar: UISearchBar!
    var button: UIButton!
    var navItem: UIBarButtonItem!
    var offset = 0;
    var isMoreDataLoading = false;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add refresh controller
        refreshControl = UIRefreshControl();

        // Handle table view data and dynamically set row height
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        
        // Places search bar in nav
        searchBar = UISearchBar();
        searchBar.delegate = self;
        searchBar.sizeToFit();
        navigationItem.titleView = searchBar;
        
        // Change color of nav
        navigationController?.navigationBar.barTintColor = UIColor(red: 0.765, green: 0.141, blue: 0, alpha: 1);
        navigationController?.navigationBar.isTranslucent = false;
        navigationController?.navigationBar.tintColor = UIColor.white;
        
        // Add filter button on left hand side
        button = UIButton(frame: CGRect(x: 0, y: 0, width: 55, height: 30))
        button.setImage(UIImage(named: "Button-Filter"), for: [])
        //button.addTarget(self, action: #selector(("filter")), for:  UIControlEvents.touchUpInside)
        navItem = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItem = navItem;
        
        fetchPlaces()
        
        /* Example of Yelp search with more search options specified
         Business.searchWithTerm("Restaurants", sort: .distance, categories: ["asianfusion", "burgers"], deals: true) { (businesses: [Business]!, error: Error!) -> Void in
         self.businesses = businesses
         
         for business in businesses {
         print(business.name!)
         print(business.address!)
         }
         }
         */
        
        // Place refresher
        refreshControl.addTarget(self, action: #selector(BusinessesViewController.didPullToRefresh(_:)), for: .valueChanged);
        tableView.insertSubview(refreshControl, at: 0)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchPlaces() {
        Business.searchWithTerm(term: "Thai", completion: { (businesses: [Business]?, error: Error?) -> Void in
            
            self.businesses = businesses
            
            self.tableView.reloadData()
            
            if let businesses = businesses {
                for business in businesses {
                    print(business.name!)
                    print(business.address!)
                }
            }
        })
        self.refreshControl.endRefreshing()
    }
    
    /*func filter() {
    }*/
    
    func didPullToRefresh(_ refreshControl: UIRefreshControl) {
        fetchPlaces()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(false);
        self.resignFirstResponder();
    }
    
    func scrollViewWillBeginDragging(tableView: UIScrollView) {
        searchBar.endEditing(false);
        self.resignFirstResponder();
    }
    
    /*func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            // Get the position of one screen length before the bottom of the results
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height - 1000
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging) {
                isMoreDataLoading = true
                loadMoreData(offset: ++offset)
            }
        }
    }
    
    func searchLoadComplete() {
        tableView.reloadData()
        tableView.alpha = 1;
        refreshControl.endRefreshing();
        isMoreDataLoading = false;
    }
    
    func loadMoreData(offset: Int = 0) {
        self.offset = offset;
    }*/
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if businesses != nil {
            return businesses!.count
        }
        else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessCell", for: indexPath) as! BusinessCell
        
        cell.business = businesses[indexPath.row]
        
        return cell
    }
    

    
}
