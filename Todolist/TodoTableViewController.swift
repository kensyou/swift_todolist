//
//  TodoTableViewController.swift
//  Todolist
//
//  Created by user118273 on 4/17/16.
//  Copyright © 2016 user118273. All rights reserved.
//

import UIKit
import MGSwipeTableCell

@objc(TodoTableViewController)
class TodoTableViewController: UITableViewController {

    private var todosDatastore: TodosDatastore?
    private var todos: [Todo]?
    
    // MARK: - ViewController View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Todos"
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
    }
    
    // MARK: - Configure
    
    func configure(todosDatastore: TodosDatastore){
        self.todosDatastore = todosDatastore
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        refresh()
    }
    
    // MARK: - Internal Funcions
    private func refresh(){
        if let todosDatastore = todosDatastore{
            todos = todosDatastore.todos().sort{
                $0.dueDate.compare($1.dueDate) == NSComparisonResult.OrderedAscending
            }
            tableView.reloadData()
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return todos?.count ?? 0
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TodoCell", forIndexPath: indexPath) as! MGSwipeTableCell
        if let todo = todos?[indexPath.row]{
            renderCell(cell, todo: todo)
            setupButtonsForCell(cell, todo: todo)
        }
        // Configure the cell...

        return cell
    }

    private func renderCell(cell:UITableViewCell, todo: Todo){
        let dateFormatter :NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HH:mm dd-MM-YY"
        let dueDate = dateFormatter.stringFromDate(todo.dueDate)
        cell.detailTextLabel?.text = "\(dueDate) | \(todo.list.description)"
        cell.textLabel?.text = todo.description
        cell.accessoryType = todo.done ? .Checkmark : .None
    }

    private func setupButtonsForCell(cell: MGSwipeTableCell, todo: Todo){
        cell.rightButtons = [MGSwipeButton(title: "Edit", backgroundColor: UIColor.blueColor(), padding: 30){
            [weak self] sender in self?.editButtonPressed(todo)
            return true
            }, MGSwipeButton(title: "Delete", backgroundColor: UIColor.redColor(), padding: 30){
                [weak self] sender in self?.deleteButtonPressed(todo)
                return true
        }]
        cell.rightExpansion.buttonIndex = 0
        cell.leftButtons =  [
            MGSwipeButton(title: "Done", backgroundColor: UIColor.greenColor(), padding: 30){
                [weak self] sender in self?.doneButtonPressed(todo)
                return true
            }
        ]
        cell.leftExpansion.buttonIndex = 0
        
    }
    
    

    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK: Actions
extension TodoTableViewController{
    func addTodoButtonPressed(sender: UIButton!){
        print("addTodoButtonPressed")
    }
    func editButtonPressed(todo: Todo){
        print("editButtonPressed")
    }
    func deleteButtonPressed(todo: Todo){
        todosDatastore?.deleteTodo(todo)
        refresh()
    }
    func doneButtonPressed(todo: Todo){
        todosDatastore?.doneTodo(todo)
        refresh()
    }
}
