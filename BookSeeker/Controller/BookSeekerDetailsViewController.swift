//
//  BookSeekerDetailsViewController.swift
//  BookSeeker
//
//  Created by Narendra Dama on 12/24/19.
//  Copyright © 2019 CIT. All rights reserved.
//

import UIKit
import Cosmos
import TinyConstraints

class BookSeekerDetailsViewController: UIViewController {

    @IBOutlet weak var bookImage: UIImageView!
    @IBOutlet weak var bookName: UILabel!
    @IBOutlet weak var bookArtistName: UILabel!
    @IBOutlet weak var bookPrice: UILabel!
    @IBOutlet weak var bookDescription: UILabel!
    @IBOutlet weak var bookUserRating: UIView!
    var urlString = ""
    var bookViewModel: BookViewModel!
    var naigationTitle: String = ""
    var webservice: WebServices!
    lazy var cosmosView: CosmosView = {
        var view = CosmosView()
        view.settings.updateOnTouch = false
        view.settings.fillMode = .half
        view.rating = bookViewModel.userRating
        return view
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.webservice = WebServices()
        setupUI()
        fillBookDetails()
    }
    func setupUI() {
        self.bookImage.dropShadow(scale: false)
        bookUserRating.addSubview(cosmosView)
    }
    // fill up book details
    func fillBookDetails() {
        self.title              = self.bookViewModel.name
        bookName.text           = self.bookViewModel.name
        bookArtistName.text     = self.bookViewModel.artistName
        bookPrice.text          = self.bookViewModel.price
        self.webservice.retrieveImages(urlString: self.bookViewModel.photoUrl) { (image) in
            self.bookImage.image = image
        }
        //bookDescription.text            = self.bookViewModel.bookDescription
        bookDescription.attributedText  =   self.bookViewModel.bookDescription.htmlToAttributedString
        bookDescription.font            =   UIFont.systemFont(ofSize: 14.0, weight: UIFont.Weight.regular)
        bookDescription.textColor       =   UIColor.label
    }
}
extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html,
                        .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}
extension UIImageView {
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 1
        layer.shadowOffset = .zero
        layer.shadowRadius = 6
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}
