//
// ViewController.swift
// LuceneSearchDemo
//
// Copyright (c) 2015 Lukhnos Liu.
//
// Permission is hereby granted, free of charge, to any person obtaining a
// copy of this software and associated documentation files (the "Software"),
// to deal in the Software without restriction, including without limitation
// the rights to use, copy, modify, merge, publish, distribute, sublicense,
// and/or sell copies of the Software, and to permit persons to whom the
// Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
// DEALINGS IN THE SOFTWARE.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    let cellReuseID = "DocumentCell"

    var foundDocuments: NSArray = []

    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var infoView: UIView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var infoLabel: UILabel!
    @IBOutlet var linkButton: UIButton!
    @IBOutlet var tableView: UITableView!

    enum State {
        case Welcome, Searching, NoResult, HasResults, RebuildingIndex
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

        if let selectedIndexPath = tableView.indexPathForSelectedRow() {
            tableView.deselectRowAtIndexPath(selectedIndexPath, animated: false)
        }
    }

    @IBAction func moreInfoAction() {
        UIApplication.sharedApplication().openURL(NSURL(string: "https://lukhnos.org/mobilelucene/ios")!)
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
        case .Searching:
            hideInfo = false
            activityIndicator.startAnimating()
            infoLabel.hidden = true
            infoLabel.text = ""
            linkButton.hidden = true
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

    var text = NSMutableString()

    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        state = .Searching

        if let t = searchBar.text {
            text.setString(t)
        }

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            if let docs = Document.search(self.text) {
                self.foundDocuments = docs
            } else {
                self.foundDocuments = []
            }

            dispatch_async(dispatch_get_main_queue(), {
                if self.foundDocuments.count > 0 {
                    self.state = .HasResults
                } else {
                    self.state = .NoResult
                }
                self.tableView.setContentOffset(CGPointZero, animated: false)
                self.tableView.reloadData()
            })
        })
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foundDocuments.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(cellReuseID, forIndexPath: indexPath) as! DocumentCell
        var doc = foundDocuments[indexPath.row] as! Document
        cell.configureCell(doc)
        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("showDetail", sender: self)
    }
}

