//
//  DSEGeoLocationListViewController.h
//  e-guru
//
//  Created by Apple on 20/02/19.
//  Copyright © 2019 TATA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DSEModel.h"

NS_ASSUME_NONNULL_BEGIN


@protocol newLocationAddTODSEDelegate <NSObject>
-(void)updateMyTeamDetailsCallBack;
@end

@interface DSEGeoLocationListViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) id<newLocationAddTODSEDelegate>delegate;

@property (weak, nonatomic) IBOutlet UIButton *addLocationButton;
@property (weak, nonatomic) IBOutlet UITableView *locationTableView;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (nonatomic,retain) NSMutableArray *dseLocationListArray;
@property (nonatomic,retain) DSEModel *dseObject;

- (IBAction)addLocationMethod:(id)sender;
- (IBAction)backButtonMethod:(id)sender;
- (IBAction)saveButtonMethod:(id)sender;

@end

NS_ASSUME_NONNULL_END
