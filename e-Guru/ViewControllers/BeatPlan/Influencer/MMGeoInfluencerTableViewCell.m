//
//  MMGeoInfluencerTableViewCell.m
//  e-guru
//
//  Created by Apple on 27/02/19.
//  Copyright © 2019 TATA. All rights reserved.
//

#import "MMGeoInfluencerTableViewCell.h"
#import "UIColor+eGuruColorScheme.h"
#import "NSString+NSStringCategory.h"

@implementation MMGeoInfluencerTableViewCell

- (void)awakeFromNib{
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];
}

- (void)setUpUIData:(NSArray<EGMMGeoInfluencerModel *>*)array andIndex:(NSInteger)mmgeoIndex{
    [self.containerView setHidden:YES];
    [self.lblTitle setHidden:NO];
    if (array.count > 0){
        
        NSString *mmGeo = [array[mmgeoIndex].mmGeo stringByTrimmingPrefixCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        mmGeo = [array[mmgeoIndex].mmGeo stringByTrimmingSuffixCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

        self.lblTitle.text = [mmGeo hasValue] ? mmGeo : @"-";
        if ([self getValueOfMMGeoAtIndex:mmgeoIndex fromArray:array]){
            self.lblTitle.backgroundColor = [UIColor colorWithR:34.0 G:115.0 B:181.0 A:1.0];
        }else{
            self.lblTitle.backgroundColor = [UIColor colorWithR:223.0 G:229.0 B:234.0 A:1.0];
        }
    }else{
        self.lblTitle.text = @"";
    }
}

- (BOOL)getValueOfMMGeoAtIndex:(NSInteger)mmgeoIndex fromArray:(NSArray<EGMMGeoInfluencerModel *>*)array {
    if (array.count > 0){
        return array[mmgeoIndex].isSelectedMMGeo;
    }
    return NO;
}

- (void)setUpUIDataForSourceOfContact:(NSArray<EGCustomerDetailModel *>*)array andIndex:(NSInteger)mmgeoIndex{
    [self.containerView setHidden:NO];
    [self.lblTitle setHidden:YES];
    [self.btnDelete setTag:mmgeoIndex];
    
    if (array.count > 0){
        //    if(mmgeoIndex % 2 == 0){
        //        [self.containerView setBackgroundColor:[UIColor clearColor]];
        //    }else{
        //        [self.containerView setBackgroundColor:[UIColor tableViewAlternateCellColor]];
        //    }
        if ([array[mmgeoIndex].status isEqualToString:@"junk"]){
            self.containerView.backgroundColor = [UIColor redColor];
            [self.btnDelete setImage:[UIImage imageNamed:@"recyclebin_white"] forState:UIControlStateNormal];
        } else if ([array[mmgeoIndex].status isEqualToString:@"false"]){
            self.containerView.backgroundColor = [UIColor colorWithRed:203/255.0
                                                                     green:97/255.0
                                                                      blue:133/255.0
                                                                     alpha:0.2];
            [self.btnDelete setImage:[UIImage imageNamed:@"recyclebin_white"] forState:UIControlStateNormal];
        }else{
            self.containerView.backgroundColor = [UIColor tableViewAlternateCellColor];
            [self.btnDelete setImage:[UIImage imageNamed:@"recyclebin"] forState:UIControlStateNormal];
        }
        self.lblName.text = [array[mmgeoIndex].name hasValue] ? array[mmgeoIndex].name : @"-";
        self.lblAccName.text = [array[mmgeoIndex].accountName hasValue] ? array[mmgeoIndex].accountName : @"-";
        self.lblContactNo.text = [array[mmgeoIndex].contactNumber hasValue] ? array[mmgeoIndex].contactNumber : @"-";
        self.lblLOB.text = [array[mmgeoIndex].lob hasValue] ? array[mmgeoIndex].lob : @"-";
        self.lblApplication.text = [array[mmgeoIndex].application hasValue] ? array[mmgeoIndex].application : @"-";
    }else{
        self.lblName.text = @"";
        self.lblAccName.text = @"";
        self.lblContactNo.text = @"";
        self.lblLOB.text = @"";
        self.lblApplication.text = @"";
    }
}

- (NSMutableDictionary*)getDataOfCustomerArray:(NSArray<EGCustomerDetailModel *>*)array atSelectedIndex:(NSInteger)selectedIndex withMMGeoArray:(NSArray<EGMMGeoInfluencerModel *>*)mmGeoArray atMMGeoIndex:(NSInteger)mmgeoIndex{
    NSMutableDictionary *customerDict = [NSMutableDictionary new];
    [customerDict setValue:array[selectedIndex].name forKey:@"customer_name"];
    [customerDict setValue:array[selectedIndex].name forKey:@"customer_name"];
    [customerDict setValue:array[selectedIndex].accountName forKey:@"account_name"];
    [customerDict setValue:array[selectedIndex].contactNumber forKey:@"contact_number"];
    [customerDict setValue:array[selectedIndex].lob forKey:@"lob"];
    [customerDict setValue:array[selectedIndex].application forKey:@"application"];
    [customerDict setValue:array[selectedIndex].customer_id forKey:@"customer_id"];
    [customerDict setValue:array[selectedIndex].status forKey:@"status"];
    [customerDict setValue:mmGeoArray[mmgeoIndex].mmGeo forKey:@"mmgeo"];
    [customerDict setValue:mmGeoArray[mmgeoIndex].city forKey:@"city"];
    [customerDict setValue:mmGeoArray[mmgeoIndex].district forKey:@"district"];
    return customerDict;
}

- (NSMutableDictionary*)getCustomerIDFromArray:(NSArray<EGCustomerDetailModel *>*)array atSelectedIndex:(NSInteger)selectedIndex{
    NSMutableDictionary *customerDict = [NSMutableDictionary new];
    [customerDict setValue:array[selectedIndex].customer_id forKey:@"customer_id"];
    [customerDict setValue:array[selectedIndex].status forKey:@"status"];
    return customerDict;
}

- (NSString*)getStatusFromCustomerArray:(NSArray<EGCustomerDetailModel *>*)array atSelectedIndex:(NSInteger)selectedIndex{
    if ([array[selectedIndex].status isEqualToString:@"junk"]){
        return NO;
    }else{
        return array[selectedIndex].status;
    }
}

- (void)updateModelFromCustomerArray:(NSArray<EGCustomerDetailModel *>*)array atSelectedIndex:(NSInteger)selectedIndex{
    if ([array[selectedIndex].status isEqualToString:@"true"]){
        array[selectedIndex].status = @"false";
    }else{
        array[selectedIndex].status = @"true";
    }
}

- (void)setMMGeoSelectedAtIndex:(NSInteger)mmgeoIndex fromArray:(NSArray<EGMMGeoInfluencerModel *>*)array{
    for (EGMMGeoInfluencerModel *mmgeoModel in array) {
        if (mmgeoModel.index == mmgeoIndex) {
            mmgeoModel.isSelectedMMGeo = YES;
        } else {
            mmgeoModel.isSelectedMMGeo = NO;
        }
    }
}

- (IBAction)btnDeleteClicked:(UIButton*)sender{
    self.integerBlock(sender.tag);    
}

- (void)onBtnDeleteClicked:(integerBlck)blck{
    self.integerBlock = blck;
}

@end
