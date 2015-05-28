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
#import "Task.h"
#import "NewTaskTableViewController.h"

@interface TaskListViewController ()<NewTaskTableViewControllerDelegate, ToDoTableViewCellDelegate, NSFetchedResultsControllerDelegate>

@property (nonatomic) NSFetchedResultsController* fetchedResults;
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
    
    self.detailViewController = (TaskDetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    CoreDataStack* coreData = [[CoreDataStack alloc]init];
    self.context = coreData.managedObjectContext;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Task* toDo = [self.fetchedResults objectAtIndexPath:indexPath];        TaskDetailViewController *controller = (TaskDetailViewController*)[[segue destinationViewController] topViewController];
        [controller setDetailItem:toDo];
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
    }
    if([segue.identifier isEqualToString:@"newTask"]){
        UINavigationController* navController = (UINavigationController*)segue.destinationViewController;
        NewTaskTableViewController* controller = navController.viewControllers[0];
        controller.delegate = self;
        controller.context = self.context;
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;//[[self.fetchedResults sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResults sections][section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ToDoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ToDoCell" forIndexPath:indexPath];
    cell.nameLabel.attributedText = nil;
    cell.descriptionLabel.attributedText = nil;
    cell.nameLabel.text= nil;
    cell.descriptionLabel.text = nil;
    cell.priorityLabel.text = nil;
    cell.delegate = nil;

    Task* toDo = [self.fetchedResults objectAtIndexPath:indexPath];
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
    return NO;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (self.tableView.editing) {
//        return UITableViewCellEditingStyleDelete;
//    }
    return UITableViewCellEditingStyleDelete;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    //Task* thisTask = [self.fetchedResults objectAtIndexPath:indexPath];
}

#pragma mark - newTaskTableViewControllerDelegate Methods

-(void)newTaskTableViewContreollerDidCancel{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)newTaskTableViewContreollerDidSave:(Task*)toDo{
    [self.context insertObject:toDo];
    NSError* error;
    if (![self.context save:&error]){
        NSLog(@"Couldn't save: %@, %@", error, error.description);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)toDoTableViewCellWasSwiped:(ToDoTableViewCell*)cell{
    NSIndexPath* path = [self.tableView indexPathForCell:cell];
    Task* toDo = [self.fetchedResults objectAtIndexPath:path];
    toDo.completed = YES;
    NSError* error;
    if (![self.context save:&error]){
        NSLog(@"Couldn't save: %@, %@", error, error.description);
    }
    [self.tableView reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - fetch

-(NSFetchedResultsController*)fetchedResults{
    if (_fetchedResults){
        return _fetchedResults;
    }
    NSEntityDescription* entity = [NSEntityDescription entityForName:NSStringFromClass([Task class]) inManagedObjectContext:self.context];
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"taskPriority" ascending:NO];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    self.fetchedResults = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.context sectionNameKeyPath:nil cacheName:nil];
    self.fetchedResults.delegate = self;
    NSError* error;
    if (![self.fetchedResults performFetch:&error]){
        NSLog(@"%@, %@", error, error.description);
    }
    return _fetchedResults;
    
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        default:
            return;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}


@end
