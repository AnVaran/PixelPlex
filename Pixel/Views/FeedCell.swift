//
//  FeedCell.swift
//  Pixel
//
//  Created by Admin on 11/5/20.
//

import UIKit

class FeedCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    let feedImage: CustomImageView = {
        let image = CustomImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.backgroundColor = .gray
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.cornerRadius = 12
        return image
    }()
    
    let authorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = #colorLiteral(red: 0.6274509804, green: 0.6470588235, blue: 0.7098039216, alpha: 1)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.numberOfLines = 0
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = #colorLiteral(red: 0.6274509804, green: 0.6470588235, blue: 0.7098039216, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.textAlignment = .right
        return label
    }()
    
    let headingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.sizeToFit()
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        label.textAlignment = .center
        return label
    }()
    
    let feedText: UILabel = {
        var text = UILabel()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.numberOfLines = 0
        text.textAlignment = .center
        text.font = UIFont.systemFont(ofSize: 18)
        text.textColor = #colorLiteral(red: 0.6274509804, green: 0.6470588235, blue: 0.7098039216, alpha: 1)
        return text
    }()
    
    var item: RSSItem! {
        didSet {
            authorLabel.text = item.auther
            dateLabel.text = item.pubDate
            headingLabel.text = item.title
            feedText.text = item.description
            if let url = URL(string: item.imageURL) {
                feedImage.loadImage(from: url)
            }
        }
    }
    
    func setupViews() {
        
        addSubview(feedImage)
        addSubview(authorLabel)
        addSubview(dateLabel)
        addSubview(headingLabel)
        addSubview(feedText)
        
        //feedImage constraints
        //top
        addConstraint(NSLayoutConstraint(item: feedImage, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1, constant: 0))
        // right
        addConstraint(NSLayoutConstraint(item: feedImage, attribute: .right, relatedBy: .equal, toItem: contentView, attribute: .right, multiplier: 1, constant: 0))
        // left
        addConstraint(NSLayoutConstraint(item: feedImage, attribute: .left, relatedBy: .equal, toItem: contentView, attribute: .left, multiplier: 1, constant: 0))
        // height
        addConstraint(NSLayoutConstraint(item: feedImage, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: contentView.frame.width * 1.1))
        
        //dateLabel constraints
        // top
        addConstraint(NSLayoutConstraint(item: dateLabel, attribute: .top, relatedBy: .equal, toItem: feedImage, attribute: .bottom, multiplier: 1, constant: 20))
        // right
        addConstraint(NSLayoutConstraint(item: dateLabel, attribute: .right, relatedBy: .equal, toItem: feedImage, attribute: .right, multiplier: 1, constant: -5))
        // width
        addConstraint(NSLayoutConstraint(item: dateLabel, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0, constant: 130))
        // height
        addConstraint(NSLayoutConstraint(item: dateLabel, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 50))
        
        //autherLabel constraints
        // top
        addConstraint(NSLayoutConstraint(item: authorLabel, attribute: .top, relatedBy: .equal, toItem: feedImage, attribute: .bottom, multiplier: 1, constant: 20))
        // left
        addConstraint(NSLayoutConstraint(item: authorLabel, attribute: .left, relatedBy: .equal, toItem: feedImage, attribute: .left, multiplier: 1, constant: 5))
        // widht
        addConstraint(NSLayoutConstraint(item: authorLabel, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0, constant: contentView.frame.width - 140))
        // height
        addConstraint(NSLayoutConstraint(item: authorLabel, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 50))
        
        //headingLabel constraints
        // top
        addConstraint(NSLayoutConstraint(item: headingLabel, attribute: .top, relatedBy: .equal, toItem: authorLabel, attribute: .bottom, multiplier: 1, constant: 0))
        // left
        addConstraint(NSLayoutConstraint(item: headingLabel, attribute: .left, relatedBy: .equal, toItem: contentView, attribute: .left, multiplier: 1, constant: 10))
        // right
        addConstraint(NSLayoutConstraint(item: headingLabel, attribute: .right, relatedBy: .equal, toItem: contentView, attribute: .right, multiplier: 1, constant: -10))
        // height
        addConstraint(NSLayoutConstraint(item: headingLabel, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 130))
        
        //feedText constraints
        // top
        addConstraint(NSLayoutConstraint(item: feedText, attribute: .top, relatedBy: .equal, toItem: headingLabel, attribute: .bottom, multiplier: 1, constant: 5))
        // left
        addConstraint(NSLayoutConstraint(item: feedText, attribute: .left, relatedBy: .equal, toItem: contentView, attribute: .left, multiplier: 1, constant: 5))
        // right
        addConstraint(NSLayoutConstraint(item: feedText, attribute: .right, relatedBy: .equal, toItem: contentView, attribute: .right, multiplier: 1, constant: -5))
        // bottom
        addConstraint(NSLayoutConstraint(item: feedText, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1, constant: 0))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
