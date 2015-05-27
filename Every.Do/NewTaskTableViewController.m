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

@end

@implementation NewTaskTableViewController

- (IBAction)accessoryViewDone:(id)sender {
    [self.descriptionTextView resignFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.nameTextField.delegate = self;
    self.descriptionTextView.delegate = self;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.descriptionTextView.inputAccessoryView = self.accessoryView;
}
- (IBAction)cancel:(id)sender {
    [self.delegate newTaskTableViewContreollerDidCancel];
}
     
- (IBAction)done:(id)sender {
    if (![self.nameTextField.text isEqualToString:@""]){
        ToDo* toDo = [ToDo toDoWithTitle:self.nameTextField.text
                             description:self.descriptionTextView.text
                             andPriority:(int)[self.priorityNumber.text integerValue]];
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

-(void) priorityPickerTableViewController: (PriorityPickerTableViewController*)controller didSelectPriority: (int)priority{
    self.priorityNumber.text = [NSString stringWithFormat:@"%d", priority];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"priorityPicker"]){
        PriorityPickerTableViewController* controller = (PriorityPickerTableViewController*)segue.destinationViewController;
        controller.priorityString = self.priorityNumber.text;
        controller.delegate = self;
    }
}

@end
