//
//  UserDetailsTableViewController.m
//  Grow1
//
//  Created by Claire on 4/25/14.
//  Copyright (c) 2014 Calvin Hildreth. All rights reserved.
//

#import "UserDetailsTableViewController.h"

@interface UserDetailsTableViewController ()

@end

@implementation UserDetailsTableViewController




- (void)viewDidLoad {
    // ...
    // Create request for user's Facebook data
    FBRequest *request = [FBRequest requestForMe];
    NSLog(@"getting fb data");

    self.title = @"Facebook Profile";
    self.tableView.backgroundColor = [UIColor colorWithRed:230.0f/255.0f green:230.0f/255.0f blue:230.0f/255.0f alpha:1.0f];



    // Create array for table row titles
    //    self.rowTitleArray = @[@"Location", @"Gender", @"Date of Birth", @"Relationship"];

    // Set default values for the table row data
    self.rowDataArray = [@[@"N/A", @"N/A", @"N/A", @"N/A"] mutableCopy];
    // Send request to Facebook
    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            // result is a dictionary with the user's Facebook data
            NSMutableDictionary *userData = (NSMutableDictionary *)result;

            NSString *facebookID = userData[@"id"];
            NSString *name = userData[@"name"];
            NSString *location = userData[@"location"][@"name"];
            NSString *gender = userData[@"gender"];
            NSString *birthday = userData[@"birthday"];

//            NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID]];

            self.rowTitleArray = @[facebookID, name, location, gender, birthday];

            [self.tableView reloadData];
            [[PFUser currentUser] setObject:userData forKey:@"profile"];
            [[PFUser currentUser] saveInBackground];

            NSLog(@"about claire %@", name);

            // Now add the data to the UI elements
            // ...
            //            PFObject *newJson = [PFObject alloc] initWithClassName:@"jsonData";
            //            NSData *jsonData = [
            //            PFFile *jsonFile = [PFFile fileWithName:@"plotLine.json" contentsAtPath:<#(NSString *)#>

        }

    }];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.rowTitleArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.rowTitleArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"forIndexPath:indexPath];
    
    cell.textLabel.text = [self.rowTitleArray objectAtIndex:indexPath.row];
    
    
    return cell;
    
}

@end
