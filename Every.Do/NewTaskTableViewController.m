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

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text
{
    
    if ([text isEqualToString:@"\n"]) {
        
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

@end
