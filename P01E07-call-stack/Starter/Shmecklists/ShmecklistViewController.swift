/**
 * Copyright (c) 2018 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
 * distribute, sublicense, create a derivative work, and/or sell copies of the
 * Software in any work that is designed, intended, or marketed for pedagogical or
 * instructional purposes related to programming, coding, application development,
 * or information technology.  Permission for such use, copying, modification,
 * merger, publication, distribution, sublicensing, creation of derivative works,
 * or sale is expressly withheld.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit

class ShmecklistViewController: UITableViewController, ItemDetailViewControllerDelegate {
  
  func addItemViewControllerDidCancel(_ controller: ItemDetailV) {
    navigationController?.popViewController(animated: true)
  }
  
  func addItemViewController(_ controller: ItemDetailV, didFinishEditing item: ShmecklistItem) {
    
    if let index = items.index(of: item) {
      let indexPath = IndexPath(row: index, section:0)
      if let cell = tableView.cellForRow(at: indexPath) {
        configureText(for: cell, with: item)
      }
    }
    navigationController?.popViewController(animated: true)
  }
  
  func addItemViewController(_ controller: ItemDetailV, didFinishAdding item: ShmecklistItem) {
    let newRowIndex = items.count
    items.append(item)
    
    let indexPath = IndexPath(row: newRowIndex, section: 0)
    let indexPaths = [indexPath]
    tableView.insertRows(at: indexPaths, with: .automatic)
    navigationController?.popViewController(animated: true)
  }
  
  var items: [ShmecklistItem]
  
  @IBAction func addItem(_ sender: Any) {
    let newRowIndex = items.count
    
    let item = ShmecklistItem()
    var titles = ["Empty todo item", "Generic todo", "First todo: fill me out", "I need something to do", "Much todo about nothing"]
    let randomNumber = arc4random_uniform(UInt32(titles.count))
    let title = titles[Int(randomNumber)]
    item.text = title
    item.checked = true
    items.append(item)
    
    let indexPath = IndexPath(row: newRowIndex, section: 0)
    let indexPaths = [indexPath]
    tableView.insertRows(at: indexPaths, with: .automatic)
  }
  
  required init?(coder aDecoder: NSCoder) {
    
    items = [ShmecklistItem]()
    
    let row0Item = ShmecklistItem()
    row0Item.text = "Walk the dog"
    row0Item.checked = false
    items.append(row0Item)
    
    let row1Item = ShmecklistItem()
    row1Item.text = "Brush my teeth"
    row1Item.checked = false
    items.append(row1Item)
    
    let row2Item = ShmecklistItem()
    row2Item.text = "Learn iOS development"
    row2Item.checked = false
    items.append(row2Item)
    
    let row3Item = ShmecklistItem()
    row3Item.text = "Soccer pratice"
    row3Item.checked = false
    items.append(row3Item)
    
    let row4Item = ShmecklistItem()
    row4Item.text = "Eat ice cream"
    row4Item.checked = true
    items.append(row4Item)
    
    let row5Item = ShmecklistItem()
    row5Item.text = "Watch Game of Thrones"
    row5Item.checked = true
    items.append(row5Item)
    
    let row6Item = ShmecklistItem()
    row6Item.text = "Read iOS Apprentice"
    row6Item.checked = true
    items.append(row6Item)
    
    let row7Item = ShmecklistItem()
    row7Item.text = "Take a nap"
    row7Item.checked = false
    items.append(row7Item)
    
    super.init(coder: aDecoder)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "AddItem" {
      let controller = segue.destination as! ItemDetailV
      controller.delegate = self
    } else if segue.identifier == "EditItem" {
      let controller = segue.destination as! ItemDetailV
      controller.delegate = self
      if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
        controller.itemToEdit = items[indexPath.row]
      }
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    navigationController?.navigationBar.prefersLargeTitles = true
  }
  
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    
    items.remove(at: indexPath.row)
    
    let indexPaths = [indexPath]
    tableView.deleteRows(at: indexPaths, with: .automatic)
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return items.count
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if let cell = tableView.cellForRow(at: indexPath) {
      let item = items[indexPath.row-1]
      item.toggleChecked()
      configureCheckmark(for: cell, with: item)
    }
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "ShmecklistItem", for: indexPath)
    let item = items[indexPath.row]
    
    configureText(for: cell, with: item)
    configureCheckmark(for: cell, with: item)
    return cell
  }
  
  func configureText(for cell: UITableViewCell, with item: ShmecklistItem) {
    let label = cell.viewWithTag(1000) as! UILabel
    label.text = item.text
  }
  
  func configureCheckmark(for cell: UITableViewCell, with item: ShmecklistItem) {
    
    let label = cell.viewWithTag(1001) as! UILabel
    
    if item.checked {
      label.text = "√"
    } else {
      label.text = ""
    }
  }
}
