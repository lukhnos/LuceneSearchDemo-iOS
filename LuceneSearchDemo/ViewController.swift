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

    var foundDocuments: [Any] = []

    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var infoView: UIView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var infoLabel: UILabel!
    @IBOutlet var linkButton: UIButton!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var reindexButtonItem: UIBarButtonItem!

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
        tableView.register(UINib(nibName: cellReuseID, bundle: nil), forCellReuseIdentifier: cellReuseID)
        tableView.rowHeight = 108;
        searchBar.autocapitalizationType = UITextAutocapitalizationType.none
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !FileManager.default.fileExists(atPath: Document.indexRootPath()) {
            rebuildAction()
        }

        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedIndexPath, animated: false)
        }
    }

    @IBAction func moreInfoAction() {
        UIApplication.shared.open(URL(string: "https://lukhnos.org/mobilelucene/app-ios")!, options: [:], completionHandler: nil)
    }

    @IBAction func rebuildAction() {
        reindexButtonItem.isEnabled = false
        state = .RebuildingIndex
        searchBar.text = ""
        searchBar.resignFirstResponder()
        searchBar.isHidden = true
        foundDocuments = []
        tableView.reloadData()

        Document.rebuildIndex({
            self.state = .Welcome
            self.searchBar.isHidden = false
            self.reindexButtonItem.isEnabled = true
        })
    }

    func updateUIState() {
        let hideInfo: Bool

        switch (state) {
        case .Welcome:
            hideInfo = false
            activityIndicator.stopAnimating()
            infoLabel.isHidden = false
            infoLabel.text = NSLocalizedString("Search with Lucene", comment: "");
            linkButton.isHidden = false
        case .Searching:
            hideInfo = false
            activityIndicator.startAnimating()
            infoLabel.isHidden = true
            infoLabel.text = ""
            linkButton.isHidden = true
        case .NoResult:
            hideInfo = false
            activityIndicator.stopAnimating()
            infoLabel.isHidden = false
            infoLabel.text = NSLocalizedString("No Results", comment: "");
            linkButton.isHidden = true
        case .HasResults:
            hideInfo = true
            activityIndicator.stopAnimating()
            infoLabel.isHidden = true
            infoLabel.text = "";
            linkButton.isHidden = true
        case .RebuildingIndex:
            hideInfo = false
            activityIndicator.startAnimating()
            infoLabel.isHidden = false
            infoLabel.text = NSLocalizedString("Indexing Reviews…", comment: "");
            linkButton.isHidden = true
        }
        infoView.isHidden = hideInfo
        tableView.isHidden = !hideInfo
    }

    var text = NSMutableString()

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        state = .Searching

        if let t = searchBar.text {
            text.setString(t)
        }

        DispatchQueue.global(qos: .default).async {
            if let docs = Document.search(self.text) {
                self.foundDocuments = docs
            } else {
                self.foundDocuments = []
            }

            DispatchQueue.main.async {
                if self.foundDocuments.count > 0 {
                    self.state = .HasResults
                } else {
                    self.state = .NoResult
                }
                self.tableView.setContentOffset(CGPoint.zero, animated: false)
                self.tableView.reloadData()
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foundDocuments.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseID, for: indexPath) as! DocumentCell
        let doc = foundDocuments[indexPath.row] as! Document
        cell.configureCell(doc)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetail", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            let doc = foundDocuments[selectedIndexPath.row] as! Document
            let controller = segue.destination as! DetailsViewController
            controller.document = doc
        }
    }
}

