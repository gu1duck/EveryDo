//
//  MasterViewController.m
//  Every.Do
//
//  Created by Jeremy Petter on 2015-05-20.
//  Copyright (c) 2015 Jeremy Petter. All rights reserved.
//

#import "TaskListViewController.h"
#import "TaskDetailViewController.h"
#import "ToDoTableViewCell.h"
#import "ToDo.h"
#import "NewTaskTableViewController.h"

@interface TaskListViewController ()<NewTaskTableViewControllerDelegate, ToDoTableViewCellDelegate>

@property NSMutableArray *objects;
@end

@implementation TaskListViewController

- (void)awakeFromNib {
    [super awakeFromNib];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.preferredContentSize = CGSizeMake(320.0, 600.0);
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //self.navigationItem.leftBarButtonItem = self.editButtonItem;

    //UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    //self.navigationItem.rightBarButtonItem = addButton;
    self.detailViewController = (TaskDetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(id)sender {
    if (!self.objects) {
        self.objects = [[NSMutableArray alloc] init];
    }
    [self.objects insertObject:[NSDate date] atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        ToDo* toDo = self.toDos[indexPath.row];
        TaskDetailViewController *controller = (TaskDetailViewController*)[[segue destinationViewController] topViewController];
        [controller setDetailItem:toDo];
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
    }
    if([segue.identifier isEqualToString:@"newTask"]){
        UINavigationController* navController = (UINavigationController*)segue.destinationViewController;
        NewTaskTableViewController* controller = navController.viewControllers[0];
        controller.delegate = self;
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.toDos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ToDoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ToDoCell" forIndexPath:indexPath];
    cell.nameLabel.attributedText = nil;
    cell.descriptionLabel.attributedText = nil;
    cell.nameLabel.text= nil;
    cell.descriptionLabel.text = nil;
    cell.priorityLabel.text = nil;
    cell.delegate = nil;

    ToDo* toDo = (ToDo*)self.toDos[indexPath.row];
    if (toDo.completed){
        NSAttributedString* struckTitle = [[NSAttributedString alloc] initWithString:toDo.taskTitle attributes:@{NSStrikethroughStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle]}];
        NSAttributedString* struckDescription = [[NSAttributedString alloc] initWithString:toDo.taskDescription attributes:@{NSStrikethroughStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle]}];
        cell.nameLabel.attributedText = struckTitle;
        cell.descriptionLabel.attributedText = struckDescription;
    } else {
        cell.nameLabel.text= toDo.taskTitle;
        cell.descriptionLabel.text = toDo.taskDescription;
    }
    cell.priorityLabel.text = [NSString stringWithFormat:@"%d",toDo.taskPriority];
    cell.delegate = self;
    return cell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

-(void)newTaskTableViewContreollerDidCancel{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)newTaskTableViewContreollerDidSave:(ToDo *)toDo{
    self.toDos = [self.toDos arrayByAddingObject:toDo];
    NSIndexPath *path = [NSIndexPath indexPathForRow:[self.toDos count] -1 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.tableView.editing) {
        return UITableViewCellEditingStyleDelete;
    }
    return UITableViewCellEditingStyleNone;
}

-(void)toDoTableViewCellWasSwiped:(ToDoTableViewCell*)cell{
    NSIndexPath* path = [self.tableView indexPathForCell:cell];
    int swiped = (int)path.row;
    ToDo* toDo = self.toDos[swiped];
    toDo.completed = YES;
    [self.tableView reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationAutomatic];
}

@end
