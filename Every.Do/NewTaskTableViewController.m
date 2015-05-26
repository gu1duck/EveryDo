//
//  NewTaskTableViewController.m
//  Every.Do
//
//  Created by Jeremy Petter on 2015-05-20.
//  Copyright (c) 2015 Jeremy Petter. All rights reserved.
//

#import "NewTaskTableViewController.h"

@interface NewTaskTableViewController () <UITextFieldDelegate, UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UILabel *priorityNumber;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UIView *accessoryView;
@property (strong, nonatomic) ToDo* autoSave;

@end

@implementation NewTaskTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.nameTextField.delegate = self;
    self.descriptionTextView.delegate = self;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.autoSave = [NSKeyedUnarchiver unarchiveObjectWithFile:[self getCachePath]];
    
    if (self.autoSave){
        self.nameTextField.text = self.autoSave.taskTitle;
        self.priorityNumber.text = [@(self.autoSave.taskPriority) stringValue];
        self.descriptionTextView.text = self.autoSave.taskDescription;
    } else {
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        self.nameTextField.text = [defaults stringForKey:@"defaultTaskName"];
        self.priorityNumber.text = [defaults stringForKey:@"defaultTaskPriority"];
        self.descriptionTextView.text = [defaults stringForKey:@"defaultTaskDescription"];
        self.autoSave = [[ToDo alloc] init];
    }
    self.descriptionTextView.inputAccessoryView = self.accessoryView;
    
}
- (IBAction)cancel:(id)sender {
    [self.delegate newTaskTableViewContreollerDidCancel];
}
- (IBAction)accessoryViewDone:(id)sender {
    [self.descriptionTextView resignFirstResponder];
}
     
- (IBAction)done:(id)sender {
    if (![self.nameTextField.text isEqualToString:@""]){
        ToDo* toDo = [ToDo toDoWithTitle:self.nameTextField.text
                             description:self.descriptionTextView.text
                             andPriority:(int)[self.priorityNumber.text integerValue]];
        NSFileManager* fileManager = [NSFileManager defaultManager];
        if([fileManager removeItemAtPath:[self getCachePath] error:nil]){
            NSLog(@"I deleted the thing!!");
        }
        [self.delegate newTaskTableViewContreollerDidSave:toDo];
    } else {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Sorry Dave"
                                                        message:@"I can't save a task without a title"
                                                       delegate:nil
                                              cancelButtonTitle:@"I'm sorry too" otherButtonTitles: nil];
        [alert show];
        
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 0){
        [self.nameTextField becomeFirstResponder];
    }
    if (indexPath.section == 1){
        [self.descriptionTextView becomeFirstResponder];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == self.nameTextField){
        [self.nameTextField resignFirstResponder];
    }
    return YES;
}
- (IBAction)nameFieldDidChange:(id)sender {
    self.autoSave.taskTitle = self.nameTextField.text;
    [NSKeyedArchiver archiveRootObject:self.autoSave toFile:[self getCachePath]];
}

- (void)textViewDidChange:(UITextView *)textView{
    if ([self.descriptionTextView isFirstResponder]){
        self.autoSave.taskDescription = self.descriptionTextView.text;
        [NSKeyedArchiver archiveRootObject:self.autoSave toFile:[self getCachePath]];
    }
}

-(void) priorityPickerTableViewController: (PriorityPickerTableViewController*)controller didSelectPriority: (int)priority{
    self.priorityNumber.text = [NSString stringWithFormat:@"%d", priority];
    
    self.autoSave.taskPriority = [self.priorityNumber.text intValue];
    [NSKeyedArchiver archiveRootObject:self.autoSave toFile:[self getCachePath]];
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"priorityPicker"]){
        PriorityPickerTableViewController* controller = (PriorityPickerTableViewController*)segue.destinationViewController;
        controller.priorityString = self.priorityNumber.text;
        controller.delegate = self;
    }
}
- (IBAction)saveDefaultButtonPressed:(id)sender {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.nameTextField.text forKey:@"defaultTaskName"];
    [defaults setObject:self.priorityNumber.text forKey:@"defaultTaskPriority"];
    [defaults setObject:self.descriptionTextView.text forKey:@"defaultTaskDescription"];
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Default Task Saved!" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Awesome" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

-(NSString*)getCachePath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDirectoryPath = [paths objectAtIndex:0];
    return [cachesDirectoryPath stringByAppendingPathComponent:@"appCache"];
}

@end
