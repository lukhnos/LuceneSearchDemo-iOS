//
//  ViewController.swift
//  LuceneSearchDemo
//
//  Created by Lukhnos Liu on 8/29/15.
//  Copyright (c) 2015 Lukhnos Liu. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UISearchBarDelegate {
    let cellReuseID = "DocumentCell"

    var foundDocuments: [Document] = []

    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var infoView: UIView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var infoLabel: UILabel!
    @IBOutlet var linkButton: UIButton!
    @IBOutlet var tableView: UITableView!

    enum State {
        case Welcome, NoResult, HasResults, RebuildingIndex
    }

    var state: State = .NoResult {
        didSet {
            updateUIState()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        state = .Welcome
        tableView.registerNib(UINib(nibName: cellReuseID, bundle: nil), forCellReuseIdentifier: cellReuseID)
        tableView.rowHeight = 108;
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if !NSFileManager.defaultManager().fileExistsAtPath(Document.indexRootPath()) {
            rebuildAction()
        }
    }

    @IBAction func moreInfoAction() {
        UIApplication.sharedApplication().openURL(NSURL(string: "https://github.com/lukhnos/lucenestudy")!)
    }

    @IBAction func rebuildAction() {
        state = .RebuildingIndex
        searchBar.text = ""
        searchBar.resignFirstResponder()
        searchBar.hidden = true
        foundDocuments = []
        tableView.reloadData()

        Document.rebuildIndex({
            self.state = .Welcome
            self.searchBar.hidden = false
        })
    }

    func updateUIState() {
        let hideInfo: Bool

        switch (state) {
        case .Welcome:
            hideInfo = false
            activityIndicator.stopAnimating()
            infoLabel.hidden = false
            infoLabel.text = NSLocalizedString("Search with Lucene", comment: "");
            linkButton.hidden = false
        case .NoResult:
            hideInfo = false
            activityIndicator.stopAnimating()
            infoLabel.hidden = false
            infoLabel.text = NSLocalizedString("No Results", comment: "");
            linkButton.hidden = true
        case .HasResults:
            hideInfo = true
            activityIndicator.stopAnimating()
            infoLabel.hidden = true
            infoLabel.text = "";
            linkButton.hidden = true
        case .RebuildingIndex:
            hideInfo = false
            activityIndicator.startAnimating()
            infoLabel.hidden = false
            infoLabel.text = NSLocalizedString("Building Index…", comment: "");
            linkButton.hidden = true
        }
        infoView.hidden = hideInfo
        tableView.hidden = !hideInfo
    }

    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()

        foundDocuments = Document.search(searchBar.text) as! [Document]
        if count(foundDocuments) > 0 {
            state = .HasResults
        } else {
            state = .NoResult
        }
        tableView.reloadData()
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return count(foundDocuments)
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(cellReuseID, forIndexPath: indexPath) as! DocumentCell
        cell.configureCell(foundDocuments[indexPath.row])
        return cell
    }

}

