//
//  CityMenuCollectionViewController.swift
//  CafeApp
//
//  Created by Machir on 2022/11/24.
//

import UIKit

class CityMenuCollectionViewController: UICollectionViewController {
    
    var menuData: [City] = [MenuController.shared.taipei, MenuController.shared.keelung, MenuController.shared.taoyuan, MenuController.shared.hsinchu, MenuController.shared.miaoli, MenuController.shared.taichung, MenuController.shared.nantou, MenuController.shared.changhua, MenuController.shared.yunlin, MenuController.shared.chiayi, MenuController.shared.tainan, MenuController.shared.kaohsiung, MenuController.shared.pingtung, MenuController.shared.yilan, MenuController.shared.hualien, MenuController.shared.taitung, MenuController.shared.penghu, MenuController.shared.lienchiang]

    override func viewDidLoad() {
        super.viewDidLoad()

        //configureCellSize()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        //self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }
    
    func configureCellSize() {
        let itemSpace: Double = 50
        let columnCount: Double = 3
        let layout = collectionViewLayout as? UICollectionViewFlowLayout
        let width = floor((collectionView.bounds.width - itemSpace * (columnCount-1)) / columnCount)
        layout?.itemSize = CGSize(width: width, height: width)
        layout?.minimumInteritemSpacing = itemSpace
        layout?.minimumLineSpacing = itemSpace
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        let controller = segue.destination as? CityCafeListTableViewController
        let cell = sender as! UICollectionViewCell
        if let row = collectionView.indexPath(for: cell)?.row {
            controller?.cityCafeListData = menuData[row]
        }
    }
    

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return menuData.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CityMenuCollectionViewCell.reuseIdentifier, for: indexPath) as! CityMenuCollectionViewCell
        let menuData = menuData[indexPath.row]
        
        cell.cityLabel.text = menuData.name
    
        // Configure the cell
    
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
