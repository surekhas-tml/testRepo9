//
//  MMGeoInfluencerTableViewCell.h
//  e-guru
//
//  Created by Apple on 27/02/19.
//  Copyright © 2019 TATA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InfluencerViewModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^integerBlck)(NSInteger index);
typedef void(^btnSenderBlck)(UIButton *btn);

@interface MMGeoInfluencerTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblAccName;
@property (weak, nonatomic) IBOutlet UILabel *lblContactNo;
@property (weak, nonatomic) IBOutlet UILabel *lblLOB;
@property (weak, nonatomic) IBOutlet UILabel *lblApplication;

@property (weak, nonatomic) IBOutlet UIButton *btnDelete;
@property (copy, nonatomic) integerBlck integerBlock;

- (IBAction)btnDeleteClicked:(UIButton*)sender;
- (void)onBtnDeleteClicked:(integerBlck)blck;

- (void)setUpUIData:(NSArray<EGMMGeoInfluencerModel *>*)array andIndex:(NSInteger)mmgeoIndex;
- (void)setUpUIDataForSourceOfContact:(NSArray<EGCustomerDetailModel *>*)array andIndex:(NSInteger)mmgeoIndex;
- (void)setMMGeoSelectedAtIndex:(NSInteger)mmgeoIndex fromArray:(NSArray<EGMMGeoInfluencerModel *>*)array;
- (NSMutableDictionary*)getDataOfCustomerArray:(NSArray<EGCustomerDetailModel *>*)array atSelectedIndex:(NSInteger)selectedIndex withMMGeoArray:(NSArray<EGMMGeoInfluencerModel *>*)mmGeoArray atMMGeoIndex:(NSInteger)mmgeoIndex;
- (NSMutableDictionary*)getCustomerIDFromArray:(NSArray<EGCustomerDetailModel *>*)array atSelectedIndex:(NSInteger)selectedIndex;
- (NSString*)getStatusFromCustomerArray:(NSArray<EGCustomerDetailModel *>*)array atSelectedIndex:(NSInteger)selectedIndex;
- (void)updateModelFromCustomerArray:(NSArray<EGCustomerDetailModel *>*)array atSelectedIndex:(NSInteger)selectedIndex;

@end

NS_ASSUME_NONNULL_END
