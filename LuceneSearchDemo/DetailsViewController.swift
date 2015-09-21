//
// DetailsViewController.swift
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

class DetailsViewController : UIViewController {
    var document: Document!

    @IBOutlet var reviewTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        if document == nil {
            return
        }

        let text = NSMutableAttributedString()
        text.appendAttributedString(GetAttrString(document.highlightedTitle, 18))
        text.appendAttributedString(NSAttributedString(string: "\n\n"))
        text.appendAttributedString(GetAttrString(document.info, 12))
        text.appendAttributedString(NSAttributedString(string: "\n\n"))
        text.appendAttributedString(GetAttrString(document.highlightedReview, 14))

        reviewTextView.attributedText = text
        reviewTextView.textContainerInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
//        reviewTextView.scrollRectToVisible(CGRect(x: 0, y: 0, width: 1, height: 1), animated: false)
//        reviewTextView.setContentOffset(CGPointZero, animated: false)
        reviewTextView.scrollEnabled = false

        if let _ = document.source {
            let sourceButton = UIBarButtonItem(title: "Source", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("sourceAction"))
            navigationItem.rightBarButtonItem = sourceButton
        }
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        reviewTextView.scrollEnabled = true
    }

    func sourceAction() {
        if let source = document.source {
            UIApplication.sharedApplication().openURL(source)
        }
    }
}
