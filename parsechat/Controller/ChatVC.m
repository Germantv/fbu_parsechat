//
//  ChatVC.m
//  parsechat
//
//  Created by German Flores on 7/6/20.
//  Copyright © 2020 German Flores. All rights reserved.
//

#import "ChatVC.h"
#import <Parse/Parse.h>
#import "ChatCell.h"

@interface ChatVC () <UITableViewDelegate, UITableViewDataSource>

// MARK: Outlets
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *messageField;


// MARK: Properties
@property (strong, nonatomic) NSMutableArray *messages;
@end

@implementation ChatVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 50;
    
    // Reload messages every second (interval of 1 second)
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(retrieveChatMessages) userInfo:nil repeats:true];
    [self.tableView reloadData];

}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

}

- (void)retrieveChatMessages {
    PFQuery *query = [PFQuery queryWithClassName:@"Message_fbu2019"];
    [query addDescendingOrder:@"createdAt"];
    query.limit = 20;
    [query includeKey:@"user"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (objects != nil) {
            self.messages = (NSMutableArray *)objects;
            [self .tableView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

// MARK: Actions
- (IBAction)onSend:(id)sender {
    // check if text field is empty
    if ([self.messageField hasText]) {
        // use the calss name "Message_fbu2019"
        PFObject *chatMessage = [PFObject objectWithClassName:@"Message_fbu2019"];
        // store the text field's text in a key called 'text'
        chatMessage[@"text"] = self.messageField.text;
        // associate curr user to message sent
        chatMessage[@"user"] = PFUser.currentUser;
        
        // Call saveInBackground(block:) and print when the message successfully saves or any errors.
        [chatMessage saveInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
            if (succeeded) {
                NSLog(@"The message was saved!");
                // clear text from chat field
                self.messageField.text = @"";
            } else {
                NSLog(@"Problem saving message: %@", error.localizedDescription);
            }
        }];
    } else {
        NSLog(@"\nMESSAGE CANNOT BE EMPTY\n");
    }
}

- (IBAction)onLogout:(id)sender {
    [NSNotificationCenter.defaultCenter postNotificationName:@"didLogout" object:nil];
}


// MARK: TableView
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messages.count;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    ChatCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChatCell" forIndexPath:indexPath];
    
    PFObject *message = self.messages[indexPath.row];
    cell.messageLabel.text = message[@"text"];
    
    // set username
    PFUser *user = message[@"user"];
    if (user != nil) {
        // User found! update username label with username
        cell.usernameLabel.text = user.username;
    } else {
        // No user found, set default username
        cell.usernameLabel.text = @"🤖";
    }
    
    return cell;
}

@end
