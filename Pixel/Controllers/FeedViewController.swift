//
//  ViewController.swift
//  Pixel
//
//  Created by Admin on 03.11.2020.
//

import UIKit
import CoreLocation

class FeedViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, CLLocationManagerDelegate {

    let locationManager = LocationManager()
    private var rssItems: [RSSItem]?
    let file = "file.txt"
    var fileData = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserLocation()
        settingCollecctioView()
        fetchDatafromFile()
        fetchData()
    }
    
    private func settingCollecctioView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = layout
        collectionView.backgroundColor = #colorLiteral(red: 0.1803921569, green: 0.1843137255, blue: 0.2549019608, alpha: 1)
        collectionView.register(FeedCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.isHidden = true
        navigationController?.navigationBar.isTranslucent = false
    }
    // MARK: - Check location AlertControllers
    func getUserLocation() {
        locationManager.getLocationCountry { [weak self] (country) in
            if country == "Belarus" {
                self?.collectionView.isHidden = false
            } else {
                self?.collectionView.isHidden = true
                self?.showCanselAlert()
                self?.locationManager.location.stopUpdatingLocation()
                self?.locationManager.location.delegate = nil
            }
        }
        
        locationManager.getLocationIsDenied { [weak self] (isDdenied) in
            if isDdenied {
                self?.showGeolocateAlert()
            }
        }
    }
    
    // MARK: - Location AlertControllers
    private func showCanselAlert() {
        let alertController = UIAlertController(title: "Нет доступа", message: "К сожалению данное приложение работает только в Беларуси.", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    private func showGeolocateAlert() {
        let alertController = UIAlertController(title: "Нет доступа", message: "К сожалению данное приложение работает c геолокицией", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
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
        return CGSize(width: view.frame.width - 60, height: view.frame.height)
    }
    // MARK: - UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let rssItems = rssItems else {
            return 0
        }
        return rssItems.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! FeedCell
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

