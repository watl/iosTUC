//
//  TUCViewController.h
//  MyStore
//
//  Created by Walter on 2/19/14.
//  Copyright (c) 2014 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TUCViewController : UIViewController


- (IBAction)cancel:(id)sender;
@property (nonatomic, nonatomic) IBOutlet UITextField *txtTUC;
@property (nonatomic,strong) NSString *txtName;
@property (weak, nonatomic) IBOutlet UIButton *btnSEND;
@property (weak, nonatomic) IBOutlet UITextField *txtVar;
- (IBAction)Send:(id)sender;
@property (strong) NSManagedObject *device;

@end
