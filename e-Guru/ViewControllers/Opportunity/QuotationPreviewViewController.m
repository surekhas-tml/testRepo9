//
//  QuotationPreviewViewController.m
//  e-guru
//
//  Created by Ashish Barve on 9/22/17.
//  Copyright © 2017 TATA. All rights reserved.
//

#import "QuotationPreviewViewController.h"
#import "UtilityMethods.h"
#import <QuartzCore/QuartzCore.h>
#import <MessageUI/MessageUI.h>
#import "NSString+NSStringCategory.h"
#import "NSDate+eGuruDate.h"

#define EMAIL_SUBJECT               @""
#define TITLE_NO_MAIL_ACCOUNTS      @"No Mail Accounts"
#define MESSAGE_SETUP_MAIL_ACCOUNT  @"Please set up a Mail account in order to send email."

@interface QuotationPreviewViewController () <MFMailComposeViewControllerDelegate>

@end

@implementation QuotationPreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [self removeAllQuotationPDFs];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Adjust the Navigation Bar
    [UtilityMethods navigationBarSetupForController:self];
}

#pragma mark - Private Methods

- (void)initUI {
    [self customizeTextFieldsContainer];
    [self bindQuotationDetailsToQuote];
}

- (void)customizeTextFieldsContainer {
    self.textFieldsContainer.layer.shadowOffset = CGSizeMake(0, -2);
    self.textFieldsContainer.layer.shadowRadius = 3;
    self.textFieldsContainer.layer.shadowOpacity = 3;
}

- (void)bindQuotationDetailsToQuote {
    if (self.quotationObj) {
        
        self.mQuoteNumber.text = self.quotationObj.mQuoteNum;
        self.mQuoteCreationDate.text = [self getFormattedQuoteCreationDate:self.quotationObj.mCreated];
        
        if ([self.quotationObj.mQuoteType isCaseInsesitiveEqualTo:@"Individual"]) {
            self.mContactFullName.text = self.quotationObj.mContactFullName;
            self.mStreetAddress.text = self.quotationObj.mStreetAddress1;
            self.mStreetAddress2.text = self.quotationObj.mStreetAddress2;
            self.mPostalCode.text = [NSString stringWithFormat:@"%@ %@", self.quotationObj.mCity, self.quotationObj.mZipcode];
            self.mTaluka.text = self.quotationObj.mTaluka;
            self.mDistrict.text = self.quotationObj.mDistrict;
            self.mStateCountry.text = [NSString stringWithFormat:@"%@ %@", self.quotationObj.mStateName, self.quotationObj.mCountry];
        } else {
            self.mContactFullName.text = self.quotationObj.mAccName;
            self.mStreetAddress.text = self.quotationObj.mAccountStreetAddress1;
            self.mStreetAddress2.text = self.quotationObj.mAcccountStreetAddress2;
            self.mPostalCode.text = [NSString stringWithFormat:@"%@ %@", self.quotationObj.mAcccountCity, self.quotationObj.mAcccountZipcode];
            self.mTaluka.text = self.quotationObj.mAcccountTaluka;
            self.mDistrict.text = self.quotationObj.mAcccountDistrict;
            self.mStateCountry.text = [NSString stringWithFormat:@"%@ %@", self.quotationObj.mAcccountStateName, self.quotationObj.mAcccountCountry];
        }
        
        [self setPhoneNumbers];
        
        self.mDeliveryLocation.text = self.quotationObj.mDeliveryLocation;
        self.mFinancier.text = self.quotationObj.mTMFinancier;
        self.mCustomerGSTIN.text = self.quotationObj.mCustomerGSTIN;
        self.mDealerGSTIN.text = self.quotationObj.mTMDealerGST;
        self.mProductDescription.text = self.quotationObj.mTMProductDescription;
        self.mDealerName.text = [NSString stringWithFormat:@"For %@", self.quotationObj.mTMDisplayName];
        
        [self calculatePrice];
        
        [self setTermsAndConditions];
    }
}

- (void)setPhoneNumbers {
    
    NSString *phoneNumberText = @"";
    
    if ([self.quotationObj.mQuoteType isCaseInsesitiveEqualTo:@"Individual"]) {
        if (self.quotationObj.mHomePhoneNumber && self.quotationObj.mWorkPhoneNumber) {
            phoneNumberText = [NSString stringWithFormat:@"(R)-()%@ (O)-()%@", self.quotationObj.mHomePhoneNumber, self.quotationObj.mWorkPhoneNumber];
        } else if (self.quotationObj.mHomePhoneNumber) {
            phoneNumberText = [NSString stringWithFormat:@"(R)-%@", self.quotationObj.mHomePhoneNumber];
        } else if (self.quotationObj.mWorkPhoneNumber) {
            phoneNumberText = [NSString stringWithFormat:@"(O)-%@", self.quotationObj.mWorkPhoneNumber];
        }
    } else {
        phoneNumberText = self.quotationObj.mAccMainContactNum;
    }
    
    self.mMobileNumber.text = self.quotationObj.mCellNumber;
    self.mPhoneNumber.text = phoneNumberText;
}

- (void)setTermsAndConditions {
    
    NSString *tAndCString = [NSString stringWithFormat:@"1 Above prices are current ex-showroom prices. Buyers will have to pay prices prevailing at the time of delivery.\n2 Optionals, accessories, insurance, registration, taxes,other levies etc. will be charged extra as applicable.\n3 Prices are for current specifications and are subject to change without notice.\n4 Prices and additional charges as above will have to be paid completely, to conclude the sales.\n5 Payment for all the above items will be by demand drafts/cheques, favoring %@ payable at %@ Outstation cheques will not be accepted\n6 Delivery will be effected after two days of completion of finance documentation, submission of PDCs,approval & disbursment of loans etc.\n7 Acceptance of advance/deposit by seller is merely an indication of an intention to sell and doesnot result into a contract of sale\n8 All disputes arising between the parties hereto shall be referred to arbitration according to the arbitration laws of the country.\n9 Only the courts of %@ shall have jurisdiction in any proceedings relating to this contract.\n10 The company shall not be liable due to any prevention, hindrance, or delay in manufacture, delivery of vehicles or accessories /optionals due to shortage of material, strike, riot, civil commotion, accident, machinery breakdown government policies, acts of god and nature, and all events beyond the control of the company.\n11 The seller shall have a general lien on goods for all moneys due to seller from buyer on account of this or other transaction.\n12 Taxes as applicable.\n13 This is to inform all our esteemed customers that any advance payments for purchase of vehicles made by them to us are our own liability and our Principals M/S Tata Motors Ltd. are in no way, implicitly or explicitly responsible for any vicarious liability for t the refund of advance or delivery of vehicles thereof, as they deal with us on a Principal to Principal basis.", self.quotationObj.mTMDisplayName, self.quotationObj.mTMPayAt, self.quotationObj.mTMJurisdictionCity];
    
    if (!self.quotationObj.mTaxCategory || !([self.quotationObj.mTaxCategory isCaseInsesitiveEqualTo:@"GST"] ||
        [self.quotationObj.mTaxCategory isCaseInsesitiveEqualTo:@"IGST"])) {
        
        tAndCString = [tAndCString stringByAppendingString:[NSString stringWithFormat:@"\n14 I/we hereby certify that my/our Registration Certificate under the %@ is in force on the date on which the sale of the goods specified in this bill / cash memorandum is made by me/us and that the transaction of sale covered by this bill / cash memorandum has been effected by me/us in the regular course of my / our business.", self.quotationObj.mTMOrgTermCondition]];
    }
    
    self.termsAndConditions.text = tAndCString;
}

- (void)calculatePrice {
    
    BOOL rootBundleFlag = [self.quotationObj.mProdType hasValue] && [self.quotationObj.mProdType isCaseInsesitiveEqualTo:@"Bundle"];
    BOOL oneTimeCharge = [self.quotationObj.mPriceType hasValue] && [self.quotationObj.mPriceType isCaseInsesitiveEqualTo:@"One-Time"];
    
    // Rollup Amount
    double rollupAmount = 0;
    if ([self.quotationObj.mRollupAmount hasValue]) {
        rollupAmount = [self.quotationObj.mRollupAmount doubleValue];
    }
    
    // Item Price
    double itemPrice = 0;
    
    // Unit Price
    double unitPrice = 0;
    if ([self.quotationObj.mUnitPrice hasValue]) {
        unitPrice = [self.quotationObj.mUnitPrice doubleValue];
    }
    
    // Adjusted List Price
    double adjustedListPrice = 0;
    if ([self.quotationObj.mAdjustedListPrice hasValue]) {
        adjustedListPrice = [self.quotationObj.mAdjustedListPrice doubleValue];
    }
    
    // Discount Percent
    double discountPercent = 0;
    if ([self.quotationObj.mDiscountPercentage hasValue]) {
        discountPercent = [self.quotationObj.mDiscountPercentage doubleValue];
    }
    
    // Discount Amount
    double discountAmount = 0;
    if ([self.quotationObj.mDiscountAmount hasValue]) {
        discountAmount = [self.quotationObj.mDiscountAmount doubleValue];
    }
    
    double a = adjustedListPrice * (100 - discountPercent) / 100;
    double b = adjustedListPrice - discountAmount;
    
    if (unitPrice == 0) {
        
        if (a == 0) {
            if (b == 0) {
                itemPrice = adjustedListPrice;
            } else {
                itemPrice = b;
            }
        } else {
            itemPrice = a;
        }
    }
    
    
    // Rollup Item Price
    double rollupItemPrice = 0;
    
    if (oneTimeCharge) {
        if (rollupAmount != 0) {
            if (itemPrice != 0) {
                rollupItemPrice = rollupAmount + itemPrice;
            } else {
                rollupItemPrice = rollupAmount;
            }
        } else {
            rollupItemPrice = itemPrice;
        }
    }
    
    double rollupItemPriceFinal = 0;
    if ([self.quotationObj.mParentQuoteItemID hasValue] && rootBundleFlag) {
        rollupItemPriceFinal = 0;
    } else {
        rollupItemPriceFinal = rollupItemPrice;
    }
    
    // Set Qunatity
    int qty = [self.quotationObj.mQty intValue];
    self.mQuantity.text = self.quotationObj.mQty;
    
    // Set Unit Price
    self.mUnitPrice.text = [NSString stringWithFormat:@"%.2f", rollupItemPriceFinal];
    
    // Set Amount
    double amount = rollupItemPriceFinal * qty;
    self.mAmount.text = [NSString stringWithFormat:@"%.2f", amount];
    
    // Set Speed Governor Quantity
    self.mSpeedGovernorQty.text = self.quotationObj.mQty;
    
    // Set Speed Governor Amount
    double speedGovernorPrice = [self.quotationObj.mSpeedQovernorPrice doubleValue];
    double speedGovernorAmount = speedGovernorPrice * qty;
    self.mSpeedGovernorAmount.text = [NSString stringWithFormat:@"%.2f", speedGovernorAmount];
    
    // Set Grand Total Amount
    double grandTotalAmount = amount + speedGovernorAmount;
    self.mGrandTotalAmount.text = [NSString stringWithFormat:@"%.2f", grandTotalAmount];
    
    [self convertGrandTotalAmountInWords:self.mGrandTotalAmount.text];
}

- (void)convertGrandTotalAmountInWords:(NSString *)grandTotalAmountString {
    
    NSString *amountInWords = @"";
    
    NSArray *grandTotalAmountComponents = [grandTotalAmountString componentsSeparatedByString:@"."];
    
    if ([grandTotalAmountComponents count] > 1) {
        
        NSString *rupeeComponent = [grandTotalAmountComponents objectAtIndex:0];
        NSString *paiseComponent = [grandTotalAmountComponents objectAtIndex:1];
        
        NSString *rupeeInWords = [self getGrandTotalAmountInWords:rupeeComponent];
        
        if (![paiseComponent isCaseInsesitiveEqualTo:@"00"]) {
            
            NSString *paiseInWords = [self getGrandTotalAmountInWords:paiseComponent];
            amountInWords = [NSString stringWithFormat:@"Rupees %@ and paise %@ only.", rupeeInWords, paiseInWords];
            
        } else {
            amountInWords = [NSString stringWithFormat:@"Rupees %@ only.", rupeeInWords];
        }
        
    } else {
        amountInWords = [NSString stringWithFormat:@"Rupees %@ only.", [self getGrandTotalAmountInWords:self.mGrandTotalAmount.text]];
    }
    
    // Set Grand Total Amount in Words
    amountInWords = [amountInWords stringByReplacingOccurrencesOfString:@"-" withString:@" "];
    self.mGrandTotalAmountInWords.text = amountInWords;
}

- (NSString *)getFormattedQuoteCreationDate:(NSString *)stringDate {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    [dateFormatter setDateFormat:dateFormatyyyyMMddTHHmmssZ];
    NSDate *date = [dateFormatter dateFromString:self.quotationObj.mCreated];
    return [date ToISTStringInFormat:dateFormatddMMMyyyyHyphen];
}

- (NSString *)getGrandTotalAmountInWords:(NSString *)grandTotalAmountStr {
    
    NSString *wordString = @"";
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle: NSNumberFormatterSpellOutStyle];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_IN"];
    [formatter setLocale:locale];
    [formatter setNumberStyle: NSNumberFormatterSpellOutStyle];
    
    
    if ([grandTotalAmountStr length] > 5) {
        
        NSString* strConvertOne = [grandTotalAmountStr substringFromIndex:[grandTotalAmountStr length] - 5];
        NSString* strConvertTwo = [grandTotalAmountStr substringToIndex:[grandTotalAmountStr length] - 5];
        
        wordString = [[self getGrandTotalAmountInWords:strConvertOne] stringByAppendingString:wordString];
        int length = (int)[strConvertTwo length];
        for (int i = 0; i < length;) {
            
            NSRange range;
            if (length > 2 && i == 0) {
                range = NSMakeRange(length - i - 2, 2);
            }
            else {
                range = NSMakeRange(0, length - i);
            }
            
            NSString *strFirst = [strConvertTwo substringWithRange:range];
            if ([strFirst intValue] == 0) {
                if (i == 0)
                    i += 2;
                else
                    break;
                continue;
            }
            
            if (i == 0) {
                strFirst = [formatter stringFromNumber:[NSNumber numberWithDouble:[strFirst doubleValue]]];
                strFirst = [strFirst stringByAppendingFormat:@" lakh "];
                wordString = [strFirst stringByAppendingString:wordString];
            }
            else {
                strFirst = [self getGrandTotalAmountInWords:strFirst];
                strFirst = [strFirst stringByAppendingFormat:@" crore "];
                wordString = [strFirst stringByAppendingString:wordString];
                break;
            }
            
            i += 2;
        }
    }
    else if ([grandTotalAmountStr intValue] != 0) {
        
        double amount = [grandTotalAmountStr doubleValue];
        NSString *convertStr = [formatter stringFromNumber:[NSNumber numberWithDouble:amount]];
        
        NSString *firstCapChar = [convertStr substringToIndex:1];
        wordString = [convertStr stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:firstCapChar];
    }
    return  [wordString capitalizedString];
}

- (void)generatePDF {
    
    NSMutableData *pdfData = [NSMutableData data];
    
    UIGraphicsBeginPDFContextToData(pdfData, CGRectMake(0, 0, 612, 792), nil); // 595, 842 595/1024
    UIGraphicsBeginPDFPage();
    CGContextRef pdfContext = UIGraphicsGetCurrentContext();
    CGContextScaleCTM(pdfContext, 0.598, 0.598); //0.581
    
    [self.quotationView.layer renderInContext:pdfContext];
    
    UIGraphicsEndPDFContext();
    
    NSArray* documentDirectoryArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    
    NSString* documentsDirectory = [documentDirectoryArray objectAtIndex:0];
    
    NSString *quotationPDFName = @"";
    NSString *customerName = @"";
    
    if ([self.quotationObj.mQuoteType isCaseInsesitiveEqualTo:@"Individual"]) {
        customerName = self.quotationObj.mContactFullName;
    } else {
        customerName = self.quotationObj.mAccName;
    }
    
    quotationPDFName = [NSString stringWithFormat:@"Quotation for %@.pdf", customerName];
    
    NSString* completePDFStoragePath = [documentsDirectory stringByAppendingPathComponent:quotationPDFName];
    
    [pdfData writeToFile:completePDFStoragePath atomically:YES];
    NSLog(@"PDF Path:%@", completePDFStoragePath);
    
    [self emailQuotationWithName:quotationPDFName];
}

- (void)emailQuotationWithName:(NSString *)quotationPDFName {
    
    NSString *messageBody = @"";
    
    NSArray* documentDirectoryArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    
    NSString* documentsDirectory = [documentDirectoryArray objectAtIndex:0];
    NSString* completePDFStoragePath = [documentsDirectory stringByAppendingPathComponent:quotationPDFName];
    NSData *attachmentData = [NSData dataWithContentsOfFile: completePDFStoragePath];
    
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailComposeViewController = [[MFMailComposeViewController alloc] init];
        mailComposeViewController.mailComposeDelegate = self;
        [mailComposeViewController setSubject:EMAIL_SUBJECT];
        [mailComposeViewController setMessageBody:messageBody isHTML:NO];
        [mailComposeViewController addAttachmentData:attachmentData mimeType:@"application/pdf" fileName:quotationPDFName];
        [self presentViewController:mailComposeViewController animated:YES completion:NULL];
    }
    else {
        [UtilityMethods alert_ShowMessage:MESSAGE_SETUP_MAIL_ACCOUNT
                                withTitle:TITLE_NO_MAIL_ACCOUNTS
                              andOKAction:^{
                               
                                  NSURL* mailURL = [NSURL URLWithString:[NSString stringWithFormat:@"mailto:"]];
                                  if ([[UIApplication sharedApplication] canOpenURL:mailURL]) {
                                      [[UIApplication sharedApplication] openURL:mailURL];
                                  }
                                                                              
        }];
    }
}

- (void)removeAllQuotationPDFs {
    
    // Get documents directory path
    NSFileManager  *manager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    // Get all the files in documents directory
    NSArray *allFiles = [manager contentsOfDirectoryAtPath:documentsDirectory error:nil];
    
    // Filter out only the quotation pdf files
    NSPredicate *extensionFilter = [NSPredicate predicateWithFormat:@"self ENDSWITH '.pdf'"];
    NSPredicate *quotationFilter = [NSPredicate predicateWithFormat:@"self CONTAINS[cd] %@", @"quotation"];
    NSPredicate *combinedPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[extensionFilter, quotationFilter]];
    NSArray *mPDFFilesArray = [allFiles filteredArrayUsingPredicate:combinedPredicate];
    
    // Delete all the existing quotation PDF Files
    for (NSString *mPDFFile in mPDFFilesArray) {
        NSError *error = nil;
        [manager removeItemAtPath:[documentsDirectory stringByAppendingPathComponent:mPDFFile] error:&error];
        NSAssert(!error, @"Assertion: PDF file deletion shall never throw an error.");
    }
}

#pragma mark - IBAction

- (IBAction)sendQuote:(id)sender {
    [self generatePDF];
}

@end
