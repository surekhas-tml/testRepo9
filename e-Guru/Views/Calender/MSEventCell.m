//
//  MSEventCell.m
//  Example
//
//  Created by Eric Horacek on 2/26/13.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

#import "MSEventCell.h"

@interface MSEventCell ()

@property (nonatomic, strong) UIView *borderView;

@end

@implementation MSEventCell

#pragma mark - UIView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.layer.rasterizationScale = [[UIScreen mainScreen] scale];
        self.layer.shouldRasterize = YES;
        
        self.layer.shadowColor = [[UIColor blackColor] CGColor];
        self.layer.shadowOffset = CGSizeMake(0.0, 4.0);
        self.layer.shadowRadius = 5.0;
        self.layer.shadowOpacity = 0.0;
        
        self.borderView = [UIView new];
        [self.contentView addSubview:self.borderView];
        
        self.contactName = [UILabel new];
        self.contactName.numberOfLines = 1;
        self.contactName.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.contactName];
        
        self.salesStage = [UILabel new];
        self.salesStage.numberOfLines = 1;
        self.salesStage.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.salesStage];
        
        self.activityType = [UILabel new];
        self.activityType.numberOfLines = 1;
        self.activityType.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.activityType];
        
        self.lob = [UILabel new];
        self.lob.numberOfLines = 1;
        self.lob.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.lob];
        
        self.status = [UILabel new];
        self.status.numberOfLines = 1;
        self.status.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.status];
        
        self.contactNumber = [UILabel new];
        self.contactNumber.numberOfLines = 1;
        self.contactNumber.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.contactNumber];
        
        if ([[AppRepo sharedRepo] isDSMUser]) {
        self.dSENameNumber = [UILabel new];
        self.dSENameNumber.numberOfLines = 1;
        self.dSENameNumber.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.dSENameNumber];
        }
        
        [self updateColors];
        
        CGFloat borderWidth = 2.0;
        CGFloat contentMargin = 2.0;
        UIEdgeInsets contentPadding = UIEdgeInsetsMake(1.0, (borderWidth + 4.0), 1.0, 4.0);
        
        [self.borderView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(self.mas_height);
            make.width.equalTo(@(borderWidth));
            make.left.equalTo(self.mas_left);
            make.top.equalTo(self.mas_top);
        }];
        
        [self.contactName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(contentPadding.top);
            make.left.equalTo(self.mas_left).offset(contentPadding.left);
            make.right.equalTo(self.mas_right).offset(-contentPadding.right);
        }];
        
        [self.salesStage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contactName.mas_bottom).offset(contentMargin);
            make.left.equalTo(self.mas_left).offset(contentPadding.left);
            make.right.equalTo(self.mas_right).offset(-contentPadding.right);
            make.bottom.lessThanOrEqualTo(self.mas_bottom).offset(-contentPadding.bottom);
        }];
        
        
        
        [self.activityType mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.salesStage.mas_bottom).offset(contentMargin);
            make.left.equalTo(self.mas_left).offset(contentPadding.left);
            make.right.equalTo(self.mas_right).offset(-contentPadding.right);
            make.bottom.lessThanOrEqualTo(self.mas_bottom).offset(-contentPadding.bottom);
        }];
        
        
        [self.lob mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.activityType.mas_bottom).offset(contentMargin);
            make.left.equalTo(self.mas_left).offset(contentPadding.left);
            make.right.equalTo(self.mas_right).offset(-contentPadding.right);
            make.bottom.lessThanOrEqualTo(self.mas_bottom).offset(-contentPadding.bottom);
        }];
        
        [self.status mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.lob.mas_bottom).offset(contentMargin);
            make.left.equalTo(self.mas_left).offset(contentPadding.left);
            make.right.equalTo(self.mas_right).offset(-contentPadding.right);
            make.bottom.lessThanOrEqualTo(self.mas_bottom).offset(-contentPadding.bottom);
        }];
        
        [self.contactNumber mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.status.mas_bottom).offset(contentMargin);
            make.left.equalTo(self.mas_left).offset(contentPadding.left);
            make.right.equalTo(self.mas_right).offset(-contentPadding.right);
            make.bottom.lessThanOrEqualTo(self.mas_bottom).offset(-contentPadding.bottom);
        }];
        
        if ([[AppRepo sharedRepo] isDSMUser]) {
        [self.dSENameNumber mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contactNumber.mas_bottom).offset(contentMargin);
            make.left.equalTo(self.mas_left).offset(contentPadding.left);
            make.right.equalTo(self.mas_right).offset(-contentPadding.right);
            make.bottom.lessThanOrEqualTo(self.mas_bottom).offset(-contentPadding.bottom);
        }];
        }
    }
    return self;
}

#pragma mark - UICollectionViewCell

- (void)setSelected:(BOOL)selected
{
    if (selected && (self.selected != selected)) {
        [UIView animateWithDuration:0.1 animations:^{
            self.transform = CGAffineTransformMakeScale(1.025, 1.025);
            self.layer.shadowOpacity = 0.2;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1 animations:^{
                self.transform = CGAffineTransformIdentity;
            }];
        }];
    } else if (selected) {
        self.layer.shadowOpacity = 0.2;
    } else {
        self.layer.shadowOpacity = 0.0;
    }
    [super setSelected:selected]; // Must be here for animation to fire
    [self updateColors];
}

#pragma mark - MSEventCell

- (void)setEvent:(EGActivity *)event
{
    _event = event;
    
    NSString *contactName = [event.toOpportunity.toContact.firstName stringByAppendingString:[NSString stringWithFormat:@" %@",event.toOpportunity.toContact.lastName]];
    self.contactName.attributedText = [[NSAttributedString alloc] initWithString:contactName.length > 0 ? contactName : @"" attributes:[self titleAttributesHighlighted:self.selected]];
    
    NSString *salesStage = event.toOpportunity.salesStageName;
    self.salesStage.attributedText = [[NSAttributedString alloc] initWithString:salesStage.length > 0 ? salesStage : @""  attributes:[self subtitleAttributesHighlighted:self.selected]];
    
    NSString *activityType = event.activityType;
    self.activityType.attributedText = [[NSAttributedString alloc] initWithString:activityType.length > 0 ? activityType : @""  attributes:[self subtitleAttributesHighlighted:self.selected]];;
    
    NSString *lob = event.toOpportunity.toVCNumber.ppl;
    self.lob.attributedText = [[NSAttributedString alloc] initWithString:lob.length > 0 ? lob : @"" attributes:[self subtitleAttributesHighlighted:self.selected]];
    
    NSString *status = event.status;
    self.status.attributedText = [[NSAttributedString alloc] initWithString:status.length > 0 ? status : @"" attributes:[self subtitleAttributesHighlighted:self.selected]];
    
    NSString *contactNumber = event.toOpportunity.toContact.contactNumber;
    self.contactNumber.attributedText = [[NSAttributedString alloc] initWithString:contactNumber.length >0 ? contactNumber : @"" attributes:[self subtitleAttributesHighlighted:self.selected]];
    
    if ([[AppRepo sharedRepo] isDSMUser]) {
    NSString *dseName = event.toOpportunity.leadAssignedName;
        if (event.toOpportunity.leadAssignedLastName) {
           dseName = [NSString stringWithFormat:@"%@ %@",dseName,event.toOpportunity.leadAssignedLastName];
        }
        
    self.dSENameNumber.attributedText = [[NSAttributedString alloc] initWithString:contactNumber.length >0 ? dseName : @"" attributes:[self subtitleAttributesHighlighted:self.selected]];
    }
    
    if ([activityType rangeOfString:@"GTME"].location == NSNotFound) {
        NSLog(@"string does not contain bla");
    } else {
        if (event.stakeholderResponse != nil) {
            
            NSDictionary *dic = [UtilityMethods getJSONFrom:event.stakeholderResponse];
            
            NSString * fullName = [NSString stringWithFormat:@"%@ %@",dic[@"first_name"],dic[@"last_name"]];
           
            NSString * contactNo = [UtilityMethods getDisplayStringForValue:dic[@"contact_no"]];
            
            self.contactName.attributedText = [[NSAttributedString alloc] initWithString:fullName.length > 0 ? fullName : @"" attributes:[self titleAttributesHighlighted:self.selected]];
            
            
            self.contactNumber.attributedText = [[NSAttributedString alloc] initWithString:contactNo.length >0 ? contactNo : @"" attributes:[self subtitleAttributesHighlighted:self.selected]];
          
        }
    }
    
}

- (void)updateColorsForLost
{
    self.contentView.backgroundColor = [self backgroundColorHighlighted:self.selected WithColor:[UIColor grayColor]];
    self.borderView.backgroundColor = [self borderColorWithColor:[UIColor grayColor]];
}
- (void)updateColorsForC0
{
    self.contentView.backgroundColor = [self backgroundColorHighlighted:self.selected WithColor:[UIColor C0Color]];
    self.borderView.backgroundColor = [self borderColorWithColor:[UIColor C0Color]];
}
- (void)updateColorsForC1
{
    self.contentView.backgroundColor = [self backgroundColorHighlighted:self.selected WithColor:[UIColor C1Color]];
    self.borderView.backgroundColor = [self borderColorWithColor:[UIColor C1Color]];
}
- (void)updateColorsForC1A
{
    self.contentView.backgroundColor = [self backgroundColorHighlighted:self.selected WithColor:[UIColor C1AColor]];
    self.borderView.backgroundColor = [self borderColorWithColor: [UIColor C1AColor]];
}
- (void)updateColorsForC2
{
    self.contentView.backgroundColor = [self backgroundColorHighlighted:self.selected WithColor:[UIColor C2Color]];
    self.borderView.backgroundColor = [self borderColorWithColor:[UIColor C2Color]];
}
- (void)updateColorsForC3
{
    self.contentView.backgroundColor = [self backgroundColorHighlighted:self.selected WithColor:[UIColor C3Color]];
    self.borderView.backgroundColor = [self borderColorWithColor:[UIColor C3Color]];

}
- (void)updateColorsForGTME
{
    self.contentView.backgroundColor = [self backgroundColorHighlighted:self.selected WithColor:[UIColor GTMEColor]];
    self.borderView.backgroundColor = [self borderColorWithColor:[UIColor C3Color]];
    
}

- (void)updateColors
{
    self.contactName.textColor = [self textColorHighlighted:self.selected WithColor:[UIColor blackColor]];
    self.salesStage.textColor = [self textColorHighlighted:self.selected WithColor:[UIColor blackColor]];
    self.lob.textColor = [self textColorHighlighted:self.selected WithColor:[UIColor blackColor]];
    self.activityType.textColor = [self textColorHighlighted:self.selected WithColor:[UIColor blackColor]];
    self.contactNumber.textColor = [self textColorHighlighted:self.selected WithColor:[UIColor blackColor]];
    if ([[AppRepo sharedRepo] isDSMUser]) {
    self.dSENameNumber.textColor = [self textColorHighlighted:self.selected WithColor:[UIColor blackColor]];
    }
    
    NSString *salesStage = _event.toOpportunity.salesStageName;
   
    if (salesStage == nil) {
        [self updateColorsForLost];
    }
     else if ([salesStage containsString:LOST]) {
        [self updateColorsForLost];
    }else if ([salesStage containsString:C0]) {
        [self updateColorsForC0];
    }else if ([salesStage containsString:C1A]) {
        [self updateColorsForC1A];
    }else if ([salesStage containsString:C1]) {
        [self updateColorsForC1];
    }else if ([salesStage containsString:C2]) {
        [self updateColorsForC2];
    }else if ([salesStage containsString:C3]) {
        [self updateColorsForC3];
    }else if ([_event.activityType containsString:GTME_BB] || [_event.activityType containsString:GTME_FE] || [_event.activityType containsString:GTME_OT] || [_event.activityType containsString:GTME_KC] || [_event.activityType containsString:GTME_RV]) {
         [self updateColorsForGTME];
    }
}

- (NSDictionary *)titleAttributesHighlighted:(BOOL)highlighted
{
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.alignment = NSTextAlignmentLeft;
    paragraphStyle.hyphenationFactor = 1.0;
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    return @{
        NSFontAttributeName : [UIFont boldSystemFontOfSize:10.0],
        NSForegroundColorAttributeName : [self textColorHighlighted:highlighted WithColor:[UIColor blackColor]],
        NSParagraphStyleAttributeName : paragraphStyle
    };
}

- (NSDictionary *)subtitleAttributesHighlighted:(BOOL)highlighted
{
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.alignment = NSTextAlignmentLeft;
    paragraphStyle.hyphenationFactor = 1.0;
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    return @{
        NSFontAttributeName : [UIFont systemFontOfSize:10.0],
        NSForegroundColorAttributeName : [self textColorHighlighted:highlighted WithColor:[UIColor blackColor]],
        NSParagraphStyleAttributeName : paragraphStyle
    };
}

- (UIColor *)backgroundColorHighlighted:(BOOL)selected WithColor:(UIColor *)color
{
    return selected ? color : [color colorWithAlphaComponent:0.2];
}

- (UIColor *)textColorHighlighted:(BOOL)selected WithColor:(UIColor *)color
{
    return selected ? [UIColor darkGrayColor] : color;
}

- (UIColor *)borderColorWithColor:(UIColor *)color
{
    return [[self backgroundColorHighlighted:NO WithColor:color] colorWithAlphaComponent:1.0];
}

@end
