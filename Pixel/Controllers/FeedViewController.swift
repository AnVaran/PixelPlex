//
//  ViewController.swift
//  Pixel
//
//  Created by Admin on 03.11.2020.
//

import UIKit
import CoreLocation

class FeedViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    private let locationManager = LocationManager()
    private var rssItems: [RSSItem]?
    private let file = "file.txt"
    private var fileData = ""
    private let cellID = "Cell"
    private let constreintWidth: CGFloat = 60
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindLocationManager()
        settingCollecctioView()
        fetchDatafromFile()
        fetchData()
    }
    
    private func settingCollecctioView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = layout
        collectionView.backgroundColor = #colorLiteral(red: 0.1803921569, green: 0.1843137255, blue: 0.2549019608, alpha: 1)
        collectionView.register(FeedCell.self, forCellWithReuseIdentifier: cellID)
        collectionView.isHidden = true
        navigationController?.navigationBar.isTranslucent = false
    }
    // MARK: - Bind location
    func bindLocationManager() {
        locationManager.complition { [weak self] (country) in
            if country == "Belarus" {
                self?.collectionView.isHidden = false
            } else {
                self?.collectionView.isHidden = true
                self?.showAlertController(title: "Нет доступа", message: "К сожалению данное приложение работает только в Беларуси.", titleAction: "Cancel")
                self?.locationManager.location.stopUpdatingLocation()
                self?.locationManager.location.delegate = nil
            }
        }
        
        locationManager.complitionIsDenied { [weak self] (isDdenied) in
            if isDdenied {
                self?.showAlertController(title: "Нет доступа", message: "К сожалению данное приложение работает c геолокицией", titleAction: "Cancel")
            }
        }
    }
    // MARK: - Load Feed
    private func fetchDatafromFile() {
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = dir.appendingPathComponent(file)
            //reading
            do {
                fileData = try String(contentsOf: fileURL, encoding: .utf8)
            }
            catch (let error){
                print(error)
            }
        }
    }
    
    private func fetchData() {
        let feedLoad = FeedLoad()
        if Reachability.isConnectedToNetwork(){
            feedLoad.loadFeed(url: "https://news.tut.by/rss/all.rss") { [weak self] (rssItems) in
                self?.rssItems = rssItems
                DispatchQueue.main.async {
                    self?.collectionView.reloadSections(IndexSet(integer: 0))
                }
            }
        } else {
            let data = Data(fileData.utf8)
            _ = Parser(data: data) { (rssItems) in
                self.rssItems = rssItems
                DispatchQueue.main.async {
                    self.collectionView.reloadSections(IndexSet(integer: 0))
                }
            }
        }
        
    }
    // MARK: - Collection View
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width - constreintWidth, height: view.frame.height)
    }
    // MARK: - UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let rssItems = rssItems else {
            return 0
        }
        return rssItems.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! FeedCell
        if let item = rssItems?[indexPath.item] {
            cell.item = item
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailViewController = storyboard.instantiateViewController(identifier: "detailCollectionController") as! DetailCollectionController
        if let item = rssItems?[indexPath.item] {
            detailViewController.rssItem = item
        }
        
        self.present(detailViewController, animated: true, completion: nil)
    }

}
extension FeedViewController {
    private func showAlertController(title: String, message: String, titleAction: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: titleAction, style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
