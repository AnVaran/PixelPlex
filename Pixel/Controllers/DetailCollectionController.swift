//
//  DetailCollectionControllerCollectionViewController.swift
//  Pixel
//
//  Created by Admin on 05.11.2020.
//

import UIKit

class DetailCollectionController: UICollectionViewController,  UICollectionViewDelegateFlowLayout {

    var rssItem: RSSItem?
    private var subCell = FeedCell()
    private let cellID = "cell"
    private let viewFeedImageHightCoefficient: CGFloat = 1.3
    private let dateAndHeidingLabelHight: CGFloat = 205
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collectionView.collectionViewLayout = layout
        collectionView.backgroundColor = #colorLiteral(red: 0.1803921569, green: 0.1843137255, blue: 0.2549019608, alpha: 1)
        collectionView.register(FeedCell.self, forCellWithReuseIdentifier: cellID)
        subCell.item = rssItem
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = LabelHeightCalculate.heightForView(text: subCell.feedText.text!, font: UIFont.systemFont(ofSize: 18), width: view.frame.width)
        return CGSize(width: view.frame.width, height: (view.frame.width * viewFeedImageHightCoefficient) + dateAndHeidingLabelHight + height )
    }
    
    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! FeedCell
        cell.item = subCell.item
        return cell
    }
  
}
