//
//  EGRKWebserviceRepository.m
//  e-Guru
//
//  Created by Juili on 27/11/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import "EGRKWebserviceRepository.h"
#import "EGTaluka.h"
#import "EGFinancier.h"
#import "EGMMGeography.h"
#import "EGPl.h"
#import "EGPpl.h"
#import "EGLob.h"
#import "EGReferralCustomer.h"
#import "EGBroker.h"
#import "EGTGM.h"
#import "EGVCNumber.h"
#import "AAATokenMO+CoreDataClass.h"
#import "AAATokenMO+CoreDataProperties.h"
#import "PostHelper.h"
#import "AccessTokenManager.h"
#import "AppRepo.h"
#import "UtilityMethods.h"
#import "EGVCList.h"
#import "EGPin.h"
#import "EGRKRequestDescriptor.h"
#import "EGDse.h"
#import "EGOfflineMasterSyncHelper.h"
#import "EGQuotation.h"
#import "EGExclusionListModel.h"
#import "EGParameterListModel.h"
#import "UtilityMethods.h"


#define NO_DATA_MESSAGE @"Could not fetch data"

static EGRKWebserviceRepository *_sharedRepository;
@implementation EGRKWebserviceRepository{
    EGRestKitSetupManager *egRKManager;
    EGRKObjectMapping *egRKMappings;
    EGRKRequestDescriptor *egRKRequestDescriptors;
    EGRKResponseDescriptor *egRKDescriptors;
    AppDelegate *appDelegate;
}

+(EGRKWebserviceRepository *)sharedRepository{
    return [[EGRKWebserviceRepository alloc]init];
}


- (instancetype )init
{
    self = [super init];
    if (self) {
        egRKManager = [EGRestKitSetupManager sharedSetup];
        egRKMappings = [EGRKObjectMapping sharedMapping];
        egRKDescriptors = [EGRKResponseDescriptor sharedDescriptor];
        egRKRequestDescriptors = [EGRKRequestDescriptor sharedDescriptor];
    }
    return self;
}

- (void)setAccessToken:(RKObjectManager *)objectManager {
    AAATokenMO *tokenObject = [[AppRepo sharedRepo] getTokenDetails];
    if (tokenObject) {
        NSString *value = [NSString stringWithFormat:@"%@ %@", tokenObject.tokenType, tokenObject.accessToken];
        NSLog(@"!!!access token: %@",value);
        [objectManager.HTTPClient setDefaultHeader:@"Authorization" value:value];
    }
}

#pragma mark - Logout Operation

- (void)performLogoutWithSuccessAction:(void (^)(id response))successBlock andFailureAction:(void (^)(NSError *error))failureBlock {
    
    [self postObject:nil
                path:LOGOUTURL
          parameters:nil
             success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                 
                 if (successBlock) {
                     successBlock([mappingResult firstObject]);
                 }
                 
             } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                 if (failureBlock) {
                     
                     failureBlock(error);
                 }
             }];
}

#pragma mark - Login Operation

- (void)performLogin:(NSDictionary *)queryDictionary andSuccessAction:(void (^)(Login *response))successBlock andFailureAction:(void (^)(NSError *error))failureBlock {
    
    [self postObject:[[Login alloc] init]
                path:LOGINURL
          parameters:queryDictionary
             success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                 
                 if (successBlock) {
                     successBlock([mappingResult firstObject]);
                     
                 }
                 
             } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                 if (failureBlock) {
                     
                     failureBlock(error);
                     
                 }
             }];
}

#pragma mark - offlineSync
- (void)getOfflineSyncInformation:(NSDictionary *)queryDictionary andSuccessAction:(void (^)(NSDictionary *response))successBlock andFailureAction:(void (^)(NSError *error))failureBlock{
    
    [self postPath:OFFLINEMASTERQUERYURL
        parameters:queryDictionary
        showLoader:NO
showDefaultErrorMessage:NO
           success:^(AFRKHTTPRequestOperation *operation, id responseObject) {
               NSError *jsonError;
               
               id jsonDictionaryOrArray = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&jsonError];
               if(jsonError) {
                   // check the error description
                   failureBlock(jsonError);
                   NSLog(@"json error : %@", [jsonError localizedDescription]);
               } else {
                   // use the jsonDictionaryOrArray
                   if (successBlock) {
                       successBlock(jsonDictionaryOrArray);
                   }
               }
           } failure:^(AFRKHTTPRequestOperation *operation, NSError *error) {
               if (failureBlock) {
                   failureBlock(error);
               }
               
           }];
}

//- (void)downloadOfflineMasterFile:(NSString *)downloadLink andSuccessAction:(void (^)(NSData *response))successBlock andFailureAction:(void (^)(NSError *error))failureBlock{
//
//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:downloadLink]];
//    NSURLSessionConfiguration* config = [NSURLSessionConfiguration defaultSessionConfiguration];
//    NSURLSession *session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[NSOperationQueue currentQueue]];
//    NSURLSessionDownloadTask* task = [session downloadTaskWithRequest:request];
//    [task resume];
//}
//
//
//- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location{
//
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"masterDownloadedNotification" object:[NSData dataWithContentsOfURL:location]];
//    NSLog(@"File saved at %@",location);
//
//}
//
//- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
//      didWriteData:(int64_t)bytesWritten
// totalBytesWritten:(int64_t)totalBytesWritten
//totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite{
//
//    CGFloat percentDone = (double)totalBytesWritten/(double)totalBytesExpectedToWrite;
//    NSLog(@"Downloaded :  %f",percentDone);
//    // Notify user.
//}
//
//
//- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
// didResumeAtOffset:(int64_t)fileOffset
//expectedTotalBytes:(int64_t)expectedTotalBytes{
//
//    NSLog(@"File Offst :  %lld",fileOffset);
//    // Notify user.
//}
//-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error{
//    [task cancel];
//    if(error){
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"masterDownloadedNotification" object:error];
//    }
//}

# pragma mark - Contact Operations

- (void)searchContactWithContactNumber:(NSDictionary *)queryDictionary andSucessAction:(void (^)(EGPagination *paginationObj))sucessBlock andFailuerAction:(void (^)(NSError *error))failuerBlock
{
    
    [self postObject:[[EGPagination alloc]init]
                path:SEARCHCONTACTURL parameters:queryDictionary
          showLoader:FALSE
showDefaultErrorMessage:YES
             success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                 if (sucessBlock) {
                     sucessBlock([mappingResult firstObject]);
                 }
                 NSLog(@"%@", [mappingResult description]);
                 
             } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                 if (failuerBlock) {
                     failuerBlock(error);
                 }
             }];
}

- (void)createContact:(NSDictionary *)queryDictionary withShowLoading:(BOOL)shouldShowLoading andSucessAction:(void (^)(NSDictionary *contact))sucessBlock andFailuerAction:(void (^)(NSError *error))failuerBlock
{
    [self postPath:CREATECONTACTURL parameters:queryDictionary showLoader:shouldShowLoading showDefaultErrorMessage:shouldShowLoading success:^(AFRKHTTPRequestOperation *operation, id responseObject) {
        NSError *jsonError;
        
        id jsonDictionaryOrArray = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&jsonError];
        if(jsonError) {
            // check the error description
            failuerBlock(jsonError);
            NSLog(@"json error : %@", [jsonError localizedDescription]);
        } else {
            // use the jsonDictionaryOrArray
            if (sucessBlock) {
                sucessBlock(jsonDictionaryOrArray);
            }
        }
    } failure:^(AFRKHTTPRequestOperation *operation, NSError *error) {
        if (failuerBlock) {
            failuerBlock(error);
        }
        
    }];
}

- (void)createContact:(NSDictionary *)queryDictionary andSucessAction:(void (^)(NSDictionary *contact))sucessBlock andFailuerAction:(void (^)(NSError *error))failuerBlock
{
    [self createContact:queryDictionary withShowLoading:YES andSucessAction:sucessBlock andFailuerAction:failuerBlock];
}

# pragma mark - Opportunity Operations

- (void)searchOpportunity:(NSDictionary *)queryDictionary andSucessAction:(void (^)(EGPagination *paginationObj))sucessBlock andFailuerAction:(void (^)(NSError *error))failuerBlock
{
    [self postObject:[[EGPagination alloc]init] path:SEARCHOPTYURL parameters:queryDictionary showLoader:NO showDefaultErrorMessage:YES success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        
        if (sucessBlock) {
            sucessBlock([mappingResult firstObject]);
        }
        NSLog(@"%@", [mappingResult description]);
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"%@",[error description]);
        if (failuerBlock) {
            failuerBlock(error);
        }
    }];
}

- (void)updateOpportunity:(NSDictionary *)queryDictionary andSucessAction:(void (^)(id contact))sucessBlock andFailuerAction:(void (^)(NSError *error))failuerBlock
{
    [[RKObjectManager sharedManager].HTTPClient patchPath:UPDATEOPTYURL parameters:queryDictionary success:^(AFRKHTTPRequestOperation *operation, id responseObject) {
        NSError *jsonError;
        
        id jsonDictionaryOrArray = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&jsonError];
        if(jsonError) {
            // check the error description
            failuerBlock(jsonError);
            NSLog(@"json error : %@", [jsonError localizedDescription]);
        } else {
            // use the jsonDictionaryOrArray
            if (sucessBlock) {
                sucessBlock(jsonDictionaryOrArray);
            }
        }
        
    } failure:^(AFRKHTTPRequestOperation *operation, NSError *error) {
        if (failuerBlock) {
            failuerBlock(error);
        }
        
    }];
}

- (void)getListOfCampaigns:(NSDictionary *)queryDictionary andSucessAction:(void (^)(id contact))sucessBlock andFailuerAction:(void (^)(NSError *error))failuerBlock
{
    [self postObject:[[EGCampaign alloc]init]
                path:CAMPAIGNLISTURL
          parameters:queryDictionary
             success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                 if (sucessBlock) {
                     sucessBlock([mappingResult dictionary]);
                 }
                 NSLog(@"%@", [mappingResult description]);
             }
             failure:^(RKObjectRequestOperation *operation, NSError *error) {
                 if (failuerBlock) {
                     failuerBlock(error);
                 }
             }];
}

- (void)getDSElist:(NSDictionary *)queryDictionary andSucessAction:(void (^)(id contact))sucessBlock andFailuerAction:(void (^)(NSError *error))failuerBlock showLoader:(BOOL) showLoader
{
    [self postObject:[[EGDse alloc]init]
                path:DSELISTURL
          parameters:queryDictionary
          showLoader:showLoader
showDefaultErrorMessage:true
             success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                 if (sucessBlock) {
                     sucessBlock([mappingResult dictionary]);
                 }
                 NSLog(@"%@", [mappingResult description]);
             }
             failure:^(RKObjectRequestOperation *operation, NSError *error) {
                 if (failuerBlock) {
                     failuerBlock(error);
                 }
             }];
}

- (void)linkCampaign:(NSDictionary *)queryDictionary andSucessAction:(void (^)(NSDictionary *contact))sucessBlock andFailuerAction:(void (^)(NSError *error))failuerBlock
{
    [self postPath:LINKCAMPAIGNURL parameters:queryDictionary success:^(AFRKHTTPRequestOperation *operation, id responseObject) {
        NSError *jsonError;
        
        id jsonDictionaryOrArray = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&jsonError];
        if(jsonError) {
            // check the error description
            failuerBlock(jsonError);
            NSLog(@"json error : %@", [jsonError localizedDescription]);
        } else {
            // use the jsonDictionaryOrArray
            if (sucessBlock) {
                sucessBlock(jsonDictionaryOrArray);
            }
        }
    } failure:^(AFRKHTTPRequestOperation *operation, NSError *error) {
        if (failuerBlock) {
            failuerBlock(error);
        }
        
    }];
}


- (void)assignOptyDSM:(NSDictionary *)queryDictionary andSucessAction:(void (^)(NSDictionary *contact))sucessBlock andFailuerAction:(void (^)(NSError *error))failuerBlock
{
    [self postPath:ASSIGNOPTYURL parameters:queryDictionary success:^(AFRKHTTPRequestOperation *operation, id responseObject) {
        NSError *jsonError;
        
        id jsonDictionaryOrArray = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&jsonError];
        if(jsonError) {
            // check the error description
            failuerBlock(jsonError);
            NSLog(@"json error : %@", [jsonError localizedDescription]);
        } else {
            // use the jsonDictionaryOrArray
            if (sucessBlock) {
                sucessBlock(jsonDictionaryOrArray);
            }
        }
    } failure:^(AFRKHTTPRequestOperation *operation, NSError *error) {
        if (failuerBlock) {
            failuerBlock(error);
        }
        
    }];
}

- (void)assignActivityDSM:(NSDictionary *)queryDictionary andSucessAction:(void (^)(NSDictionary *contact))sucessBlock andFailuerAction:(void (^)(NSError *error))failuerBlock
{
    [self postPath:ASSIGNACTIVITYURL parameters:queryDictionary success:^(AFRKHTTPRequestOperation *operation, id responseObject) {
        NSError *jsonError;
        
        id jsonDictionaryOrArray = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&jsonError];
        if(jsonError) {
            // check the error description
            failuerBlock(jsonError);
            NSLog(@"json error : %@", [jsonError localizedDescription]);
        } else {
            // use the jsonDictionaryOrArray
            if (sucessBlock) {
                sucessBlock(jsonDictionaryOrArray);
            }
        }
    } failure:^(AFRKHTTPRequestOperation *operation, NSError *error) {
        if (failuerBlock) {
            failuerBlock(error);
        }
        
    }];
}


- (void)createC1:(NSDictionary *)queryDictionary andSucessAction:(void (^)(NSDictionary *contact))sucessBlock andFailuerAction:(void (^)(NSError *error))failuerBlock
{
    [self postPath:CREATEQUOTE parameters:queryDictionary success:^(AFRKHTTPRequestOperation *operation, id responseObject) {
        NSError *jsonError;
        
        id jsonDictionaryOrArray = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&jsonError];
        if(jsonError) {
            // check the error description
            failuerBlock(jsonError);
            NSLog(@"json error : %@", [jsonError localizedDescription]);
        } else {
            // use the jsonDictionaryOrArray
            if (sucessBlock) {
                sucessBlock(jsonDictionaryOrArray);
            }
        }
    } failure:^(AFRKHTTPRequestOperation *operation, NSError *error) {
        if (failuerBlock) {
            failuerBlock(error);
        }
        
    }];
}

- (void)getListOfLOBsandSuccessAction:(void (^)(NSArray *responseArray))successBlock andFailuerAction:(void (^)(NSError *error))failuerBlock {
    
    [self postObject:[[EGLob alloc]init]
                path:LOBLISTURL
          parameters:nil
             success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                 if (successBlock) {
                     successBlock([mappingResult array]);
                 }
                 NSLog(@"%@", [mappingResult description]);
             }
             failure:^(RKObjectRequestOperation *operation, NSError *error) {
                 if (failuerBlock) {
                     failuerBlock(error);
                 }
             }];
}


- (void)getListOfDSEs:(void (^)(NSArray *responseArray))successBlock andFailuerAction:(void (^)(NSError *error))failuerBlock {
    
    [self postObject:[[EGDse alloc]init]
                path:DSELISTURL
          parameters:nil
             success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                 if (successBlock) {
                     successBlock([mappingResult array]);
                 }
                 NSLog(@"%@", [mappingResult description]);
             }
             failure:^(RKObjectRequestOperation *operation, NSError *error) {
                 if (failuerBlock) {
                     failuerBlock(error);
                 }
             }];
}





- (void)getListOfPPL:(NSDictionary *)queryDictionary andSuccessAction:(void (^)(NSArray *responseArray))successBlock andFailuerAction:(void (^)(NSError *error))failuerBlock {
    
    [self postObject:[[EGPpl alloc]init]
                path:PPLLISTURL
          parameters:queryDictionary
             success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                 if (successBlock) {
                     successBlock([mappingResult array]);
                 }
                 NSLog(@"%@", [mappingResult description]);
             }
             failure:^(RKObjectRequestOperation *operation, NSError *error) {
                 if (failuerBlock) {
                     failuerBlock(error);
                 }
             }];
}

- (void)getListOfPL:(NSDictionary *)queryDictionary andSuccessAction:(void (^)(NSArray *responseArray))successBlock andFailuerAction:(void (^)(NSError *error))failuerBlock {
    
    [self postObject:[[EGPl alloc]init]
                path:PLLISTURL
          parameters:queryDictionary
             success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                 if (successBlock) {
                     successBlock([mappingResult array]);
                 }
                 NSLog(@"%@", [mappingResult description]);
             }
             failure:^(RKObjectRequestOperation *operation, NSError *error) {
                 if (failuerBlock) {
                     failuerBlock(error);
                 }
             }];
}

- (void)getVehicleApplication:(NSDictionary *)queryDictionary andSuccessAction:(void (^)(NSArray *responseArray))successBlock andFailuerAction:(void (^)(NSError *error))failuerBlock {
    
    [self postPath:VHAPPLICATIONURL parameters:queryDictionary success:^(AFRKHTTPRequestOperation *operation, id responseObject) {
        NSError *jsonError;
        
        id jsonDictionaryOrArray = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&jsonError];
        if(jsonError) {
            // check the error description
            failuerBlock(jsonError);
            NSLog(@"json error : %@", [jsonError localizedDescription]);
        } else {
            // use the jsonDictionaryOrArray
            if (successBlock) {
                successBlock(jsonDictionaryOrArray);
            }
        }
    } failure:^(AFRKHTTPRequestOperation *operation, NSError *error) {
        if (failuerBlock) {
            failuerBlock(error);
        }
        
    }];
}

- (void)getCustomerType:(NSDictionary *)queryDictionary andSuccessAction:(void (^)(NSArray *responseArray))successBlock andFailuerAction:(void (^)(NSError *error))failuerBlock {
    
    [self postPath:CUSTOMERTYPEURL parameters:queryDictionary success:^(AFRKHTTPRequestOperation *operation, id responseObject) {
        NSError *jsonError;
        
        id jsonDictionaryOrArray = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&jsonError];
        if(jsonError) {
            // check the error description
            failuerBlock(jsonError);
            NSLog(@"json error : %@", [jsonError localizedDescription]);
        } else {
            // use the jsonDictionaryOrArray
            if (successBlock) {
                successBlock(jsonDictionaryOrArray);
            }
        }
    } failure:^(AFRKHTTPRequestOperation *operation, NSError *error) {
        if (failuerBlock) {
            failuerBlock(error);
        }
        
    }];
}

- (void)getSourceOfContactSuccessAction:(void (^)(NSArray *responseArray))successBlock andFailuerAction:(void (^)(NSError *error))failuerBlock {
    
    [self postPath:SOURCEOFCONTACTURL parameters:nil success:^(AFRKHTTPRequestOperation *operation, id responseObject) {
        NSError *jsonError;
        
        id jsonDictionaryOrArray = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&jsonError];
        if(jsonError) {
            // check the error description
            failuerBlock(jsonError);
            NSLog(@"json error : %@", [jsonError localizedDescription]);
        } else {
            // use the jsonDictionaryOrArray
            if (successBlock) {
                successBlock(jsonDictionaryOrArray);
            }
        }
    } failure:^(AFRKHTTPRequestOperation *operation, NSError *error) {
        if (failuerBlock) {
            failuerBlock(error);
        }
        
    }];
}

//- (void)getMMGeography:(NSDictionary *)queryDictionary andSuccessAction:(void (^)(NSArray *responseArray))successBlock andFailuerAction:(void (^)(NSError *error))failuerBlock {
//
//    [self postObject:[[EGMMGeography alloc]init]
//                                           path:MMGEOLISTURL
//                                     parameters:queryDictionary
//                                        success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
//                                            if (successBlock) {
//                                                successBlock([mappingResult array]);
//                                            }
//                                            NSLog(@"%@", [mappingResult description]);
//                                        }
//                                        failure:^(RKObjectRequestOperation *operation, NSError *error) {
//                                            if (failuerBlock) {
//                                                failuerBlock(error);
//                                            }
//                                        }];
//
//    [self postPath:MMGEOLISTURL parameters:queryDictionary success:^(AFRKHTTPRequestOperation *operation, id responseObject) {
//
//    } failure:^(AFRKHTTPRequestOperation *operation, NSError *error) {
//
//    }];
//}

- (void)getMMGeography:(NSDictionary *)queryDictionary
      andSuccessAction:(void (^)(NSArray *responseArray))successBlock
      andFailuerAction:(void (^)(NSError *error))failuerBlock {
    
    [self postPath:MMGEOLISTURL parameters:queryDictionary success:^(AFRKHTTPRequestOperation *operation, id responseObject) {
        NSError *jsonError;
        
        id jsonDictionaryOrArray = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&jsonError];
        if(jsonError) {
            // check the error description
            failuerBlock(jsonError);
            NSLog(@"json error : %@", [jsonError localizedDescription]);
        } else {
            // use the jsonDictionaryOrArray
            if (successBlock) {
                successBlock(jsonDictionaryOrArray);
            }
        }
    } failure:^(AFRKHTTPRequestOperation *operation, NSError *error) {
        if (failuerBlock) {
            failuerBlock(error);
        }
    }];
}

- (void)getBodyType:(NSDictionary *)queryDictionary andSuccessAction:(void (^)(NSArray *responseArray))successBlock andFailuerAction:(void (^)(NSError *error))failuerBlock {
    
    [self postPath:BODYTYPEURL parameters:queryDictionary success:^(AFRKHTTPRequestOperation *operation, id responseObject) {
        NSError *jsonError;
        
        id jsonDictionaryOrArray = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&jsonError];
        if(jsonError) {
            // check the error description
            failuerBlock(jsonError);
            NSLog(@"json error : %@", [jsonError localizedDescription]);
        } else {
            // use the jsonDictionaryOrArray
            if (successBlock) {
                successBlock(jsonDictionaryOrArray);
            }
        }
    } failure:^(AFRKHTTPRequestOperation *operation, NSError *error) {
        if (failuerBlock) {
            failuerBlock(error);
        }
        
    }];
}

- (void)getUsageCategory:(NSDictionary *)queryDictionary andSuccessAction:(void (^)(NSArray *responseArray))successBlock andFailuerAction:(void (^)(NSError *error))failuerBlock {
    
    [self postPath:USAGECATLISTURL parameters:queryDictionary success:^(AFRKHTTPRequestOperation *operation, id responseObject) {
        NSError *jsonError;
        
        id jsonDictionaryOrArray = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&jsonError];
        if(jsonError) {
            // check the error description
            failuerBlock(jsonError);
            NSLog(@"json error : %@", [jsonError localizedDescription]);
        } else {
            // use the jsonDictionaryOrArray
            if (successBlock) {
                successBlock(jsonDictionaryOrArray);
            }
        }
    } failure:^(AFRKHTTPRequestOperation *operation, NSError *error) {
        if (failuerBlock) {
            failuerBlock(error);
        }
        
    }];
}

- (void)getFinancierList:(NSDictionary *)queryDictionary andSuccessAction:(void (^)(NSArray *responseArray))successBlock andFailuerAction:(void (^)(NSError *error))failuerBlock {
    
    [self postObject:[[EGFinancier alloc]init]
                path:FINANCERLISTURL
          parameters:queryDictionary
          showLoader:false
showDefaultErrorMessage:true
             success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                 if (successBlock) {
                     successBlock([mappingResult array]);
                 }
                 NSLog(@"%@", [mappingResult description]);
             }
             failure:^(RKObjectRequestOperation *operation, NSError *error) {
                 if (failuerBlock) {
                     failuerBlock(error);
                 }
             }];
}

//new
- (void)getRegistrationDetails:(NSDictionary *)queryDictionary andSuccessAction:(void (^)(NSArray *responseArray))successBlock andFailuerAction:(void (^)(NSError *error))failuerBlock {
    
    [self postPath:CHASSISDETAILURL parameters:queryDictionary success:^(AFRKHTTPRequestOperation *operation, id responseObject) {
        NSError *jsonError;
        [UtilityMethods hideProgressHUD];
        id jsonDictionaryOrArray = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&jsonError];
        if(jsonError) {
            // check the error description
            failuerBlock(jsonError);
            NSLog(@"json error : %@", [jsonError localizedDescription]);
        } else {
            // use the jsonDictionaryOrArray
            if (successBlock) {
                successBlock(jsonDictionaryOrArray);
            }
        }
    } failure:^(AFRKHTTPRequestOperation *operation, NSError *error) {
        [UtilityMethods hideProgressHUD];
        if (failuerBlock) {
            failuerBlock(error);
//            [UtilityMethods showToastWithMessage:[error valueForKey:@"msg"]];
        }
        
    }];
}


- (void)getCampaignList:(NSDictionary *)queryDictionary andSuccessAction:(void (^)(NSArray *responseArray))successBlock andFailuerAction:(void (^)(NSError *error))failuerBlock {
    
    [self postObject:[[EGCampaign alloc]init]
                path:CAMPAIGNLISTURL
          parameters:queryDictionary
             success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                 if (successBlock) {
                     successBlock([mappingResult array]);
                 }
                 NSLog(@"%@", [mappingResult description]);
             }
             failure:^(RKObjectRequestOperation *operation, NSError *error) {
                 if (failuerBlock) {
                     failuerBlock(error);
                 }
             }];
}

- (void)get_Campaign_List:(NSDictionary *)queryDictionary withblock:(void (^)(NSArray *responseArray))successBlock andFailuerAction:(void (^)(NSError *error))failuerBlock {
    
    [self postPath:CAMPAIGNLISTURL parameters:queryDictionary success:^(AFRKHTTPRequestOperation *operation, id responseObject) {
        NSError *jsonError;
        
        id jsonDictionaryOrArray = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&jsonError];
        if(jsonError) {
            // check the error description
            failuerBlock(jsonError);
            NSLog(@"json error : %@", [jsonError localizedDescription]);
        } else {
            // use the jsonDictionaryOrArray
            if (successBlock) {
                NSMutableArray * array = [NSMutableArray new];
                
                for (NSDictionary * dict in [jsonDictionaryOrArray objectForKey:@"result"]) {
                    EGCampaign * campaign = [[EGCampaign alloc] init];
                    campaign.campaignDescription = [dict objectForKey:@"description"];
                    campaign.campaignName = [dict objectForKey:@"name"];
                    campaign.campaignID = [dict objectForKey:@"id"];
                    [array addObject:campaign];
                }
                
                successBlock(array);
            }
        }
    } failure:^(AFRKHTTPRequestOperation *operation, NSError *error) {
        if (failuerBlock) {
            failuerBlock(error);
        }
        
    }];
}

- (void)getInfluencersListSuccessAction:(void (^)(NSArray *responseArray))successBlock andFailuerAction:(void (^)(NSError *error))failuerBlock {
    
    [self postPath:INFLUENCERLISTURL parameters:nil success:^(AFRKHTTPRequestOperation *operation, id responseObject) {
        NSError *jsonError;
        
        id jsonDictionaryOrArray = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&jsonError];
        if(jsonError) {
            // check the error description
            failuerBlock(jsonError);
            NSLog(@"json error : %@", [jsonError localizedDescription]);
        } else {
            // use the jsonDictionaryOrArray
            if (successBlock) {
                successBlock(jsonDictionaryOrArray);
            }
        }
    } failure:^(AFRKHTTPRequestOperation *operation, NSError *error) {
        if (failuerBlock) {
            failuerBlock(error);
        }
        
    }];
}

- (void)getCompetitorListSuccessAction:(void (^)(NSArray *responseArray))successBlock andFailuerAction:(void (^)(NSError *error))failuerBlock {
    
    [self postPath:COMPETITORSLISTURL parameters:nil success:^(AFRKHTTPRequestOperation *operation, id responseObject) {
        NSError *jsonError;
        
        id jsonDictionaryOrArray = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&jsonError];
        if(jsonError) {
            // check the error description
            failuerBlock(jsonError);
            NSLog(@"json error : %@", [jsonError localizedDescription]);
        } else {
            // use the jsonDictionaryOrArray
            if (successBlock) {
                successBlock(jsonDictionaryOrArray);
            }
        }
    } failure:^(AFRKHTTPRequestOperation *operation, NSError *error) {
        if (failuerBlock) {
            failuerBlock(error);
        }
        
    }];
}

- (void)getProductCategoryList:(NSDictionary *)queryDictionary andSuccessAction:(void (^)(NSArray *responseArray))successBlock andFailuerAction:(void (^)(NSError *error))failuerBlock {
    
    [self postPath:PRODUCTCATURL parameters:queryDictionary success:^(AFRKHTTPRequestOperation *operation, id responseObject) {
        NSError *jsonError;
        
        id jsonDictionaryOrArray = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&jsonError];
        if(jsonError) {
            // check the error description
            failuerBlock(jsonError);
            NSLog(@"json error : %@", [jsonError localizedDescription]);
        } else {
            // use the jsonDictionaryOrArray
            if (successBlock) {
                successBlock(jsonDictionaryOrArray);
            }
        }
    } failure:^(AFRKHTTPRequestOperation *operation, NSError *error) {
        if (failuerBlock) {
            failuerBlock(error);
        }
        
    }];
}

- (void)getReferralCustomer:(NSDictionary *)queryDictionary andSuccessAction:(void (^)(NSArray *responseArray))successBlock andFailuerAction:(void (^)(NSError *error))failuerBlock {
    
    [self postObject:[[EGReferralCustomer alloc]init]
                path:REFERRALCUSTOMERLISTURL
          parameters:queryDictionary
             success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                 if (successBlock) {
                     successBlock([mappingResult array]);
                 }
                 NSLog(@"%@", [mappingResult description]);
             }
             failure:^(RKObjectRequestOperation *operation, NSError *error) {
                 if (failuerBlock) {
                     failuerBlock(error);
                 }
             }];
}

- (void)getReferralType:(NSDictionary *)queryDictionary andSuccessAction:(void (^)(NSArray *responseArray))successBlock andFailuerAction:(void (^)(NSError *error))failuerBlock {
    
    [self postPath:REFERALTYPELISTURL parameters:queryDictionary
           success:^(AFRKHTTPRequestOperation *operation, id responseObject) {
               [UtilityMethods convertResponseToJSON:responseObject success:^(id  _Nullable jsonResponse) {
                   successBlock(jsonResponse);
               } failure:^(NSError * _Nullable error) {
                   failuerBlock(error);
               }];
           } failure:^(AFRKHTTPRequestOperation *operation, NSError *error) {
               failuerBlock(error);
           }];
}

- (void)getTGMList:(NSDictionary *)queryDictionary andSuccessAction:(void (^)(NSArray *responseArray))successBlock andFailuerAction:(void (^)(NSError *error))failuerBlock {
    
    [self postObject:[[EGTGM alloc]init]
                path:TGMURL
          parameters:queryDictionary
             success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                 if (successBlock) {
                     successBlock([mappingResult array]);
                 }
                 NSLog(@"%@", [mappingResult description]);
             }
             failure:^(RKObjectRequestOperation *operation, NSError *error) {
                 if (failuerBlock) {
                     failuerBlock(error);
                 }
             }];
}

- (void)getBrokerDetails:(NSDictionary *)queryDictionary andSuccessAction:(void (^)(NSArray *responseArray))successBlock andFailuerAction:(void (^)(NSError *error))failuerBlock {
    
    [self postObject:[[EGBroker alloc]init]
                path:BROKERDETAILURL
          parameters:queryDictionary
             success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                 if (successBlock) {
                     successBlock([mappingResult array]);
                 }
                 NSLog(@"%@", [mappingResult description]);
             }
             failure:^(RKObjectRequestOperation *operation, NSError *error) {
                 if (failuerBlock) {
                     failuerBlock(error);
                 }
             }];
}

- (void)createOpportunity:(NSDictionary *)requestDictionary andSuccessAction:(void (^)(NSDictionary *responseDictionary))successBlock andFailuerAction:(void (^)(NSError *error))failuerBlock {
    
    [self createOpportunity:requestDictionary withShowLoading:YES andSuccessAction:successBlock andFailuerAction:failuerBlock];
}

- (void)createOpportunity:(NSDictionary *)requestDictionary withShowLoading:(BOOL)shouldShowLoading andSuccessAction:(void (^)(NSDictionary *responseDictionary))successBlock andFailuerAction:(void (^)(NSError *error))failuerBlock {
    
    [self postPath:CREATEOPTYURL parameters:requestDictionary showLoader:shouldShowLoading showDefaultErrorMessage:shouldShowLoading success:^(AFRKHTTPRequestOperation *operation, id responseObject) {
        if (successBlock) {
            [UtilityMethods convertResponseToJSON:responseObject success:^(id  _Nullable jsonResponse) {
                successBlock(jsonResponse);
            } failure:^(NSError * _Nullable error) {
                failuerBlock(error);
            }];
        }
    } failure:^(AFRKHTTPRequestOperation *operation, NSError *error) {
        if (failuerBlock) {
            failuerBlock(error);
        }
    }
     ];
}

- (void)updateOpportunity:(NSDictionary *)queryDictionary andSuccessAction:(void (^)(NSArray *responseArray))successBlock andFailuerAction:(void (^)(NSError *error))failuerBlock {
    
    [self postPath:UPDATEOPTYURL parameters:queryDictionary showLoader:true showDefaultErrorMessage:false success:^(AFRKHTTPRequestOperation *operation, id responseObject) {
        NSError *jsonError;
        
        id jsonDictionaryOrArray = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&jsonError];
        if(jsonError) {
            // check the error description
            failuerBlock(jsonError);
            NSLog(@"json error : %@", [jsonError localizedDescription]);
        } else {
            // use the jsonDictionaryOrArray
            if (successBlock) {
                successBlock(jsonDictionaryOrArray);
            }
        }
    } failure:^(AFRKHTTPRequestOperation *operation, NSError *error) {
        if (failuerBlock) {
            failuerBlock(error);
        }
    }];
}

//new api for crm Submit
- (void)crmSubmitCall:(NSDictionary *)queryDictionary andSuccessAction:(void (^)(NSArray *resArray))successBlock andFailuerAction:(void (^)(NSError *error))failuerBlock {
    
    [self postPath:submitToCRM parameters:queryDictionary showLoader:true showDefaultErrorMessage:false success:^(AFRKHTTPRequestOperation *operation, id responseObject) {
        NSError *jsonError;
        
        id jsonDictionaryOrArray = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&jsonError];
        if(jsonError) {
            // check the error description
            failuerBlock(jsonError);
            NSLog(@"json error : %@", [jsonError localizedDescription]);
        } else {
            // use the jsonDictionaryOrArray
            if (successBlock) {
                successBlock(jsonDictionaryOrArray);
            }
        }
    } failure:^(AFRKHTTPRequestOperation *operation, NSError *error) {
        if (failuerBlock) {
            failuerBlock(error);
        }
    }];
}

- (void)getVCList:(NSDictionary *)queryDictionary andSuccessAction:(void (^)(EGPagination *paginationObj))successBlock andFailuerAction:(void (^)(NSError *error))failuerBlock {
    
    [self postObject:[[EGPagination alloc]init]
                path:VCLISTURL
          parameters:queryDictionary
          showLoader:false
showDefaultErrorMessage:true
             success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                 if (successBlock) {
                     successBlock([mappingResult firstObject]);
                 }
                 NSLog(@"%@", [mappingResult description]);
             } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                 if (failuerBlock) {
                     failuerBlock(error);
                 }
             }];
}

- (void)getSalesStageSuccessAction:(void (^)(NSArray *responseArray))successBlock andFailureAction:(void (^)(NSError *error))failureBlock {
    
    [self postPath:OPTYSALESSTAGEURL parameters:nil success:^(AFRKHTTPRequestOperation *operation, id responseObject) {
        
        [UtilityMethods convertResponseToJSON:responseObject success:^(id jsonResponse) {
            successBlock(jsonResponse);
        } failure:^(NSError *error) {
            failureBlock(error);
        }];
        
    } failure:^(AFRKHTTPRequestOperation *operation, NSError *error) {
        failureBlock(error);
    }];
}

- (void)getEventListSuccessAction:(void (^)(NSArray *responseArray))successBlock andFailureAction:(void (^)(NSError *error))failureBlock {
    
    [self postObject:[[EGFinancier alloc]init]
                path:EVENTURL
          parameters:nil
          showLoader:true
showDefaultErrorMessage:true
             success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                 if (successBlock) {
                     successBlock([mappingResult array]);
                 }
                 NSLog(@"%@", [mappingResult description]);
             }
             failure:^(RKObjectRequestOperation *operation, NSError *error) {
                 if (failureBlock) {
                     failureBlock(error);
                 }
             }];
}

# pragma mark - Activity

- (void)createActivity:(NSDictionary *)queryDictionary andSucessAction:(void (^)(id activity))sucessBlock andFailuerAction:(void (^)(NSError *error))failuerBlock
{
    [self createActivity:queryDictionary withLoadingView:YES andSucessAction:sucessBlock andFailuerAction:failuerBlock];
}

//TODO - LoadingView or any view should not be part of API repo logic. Not a good place to have this.
- (void)createActivity:(NSDictionary *)queryDictionary withLoadingView:(BOOL)shouldShowLoadingView andSucessAction:(void (^)(id activity))sucessBlock andFailuerAction:(void (^)(NSError *error))failuerBlock
{
    [self postPath:CREATEACTIVITYURL parameters:queryDictionary showLoader:shouldShowLoadingView showDefaultErrorMessage:shouldShowLoadingView success:^(AFRKHTTPRequestOperation *operation, id responseObject) {
        NSError *jsonError;
        
        id jsonDictionaryOrArray = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&jsonError];
        if(jsonError) {
            // check the error description
            failuerBlock(jsonError);
            NSLog(@"json error : %@", [jsonError localizedDescription]);
        } else {
            // use the jsonDictionaryOrArray
            NSLog(@"SUCCC");
            if (sucessBlock) {
                sucessBlock(jsonDictionaryOrArray);
            }
        }
    } failure:^(AFRKHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"FAILED");
        if (failuerBlock) {
            failuerBlock(error);
        }
    }];
}

- (void)getPendingActivityListForGivenOpportunity:(NSDictionary *)queryDictionary andSucessAction:(void (^)(EGPagination *paginationObj))sucessBlock andFailuerAction:(void (^)(NSError *error))failuerBlock
{
    
    
    [self postObject:[[EGPagination alloc]init]
                path:SEARCHACTIVITYURL parameters:queryDictionary
          showLoader:FALSE
showDefaultErrorMessage:YES
             success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                 if (sucessBlock) {
                     sucessBlock([mappingResult firstObject]);
                 }
                 NSLog(@"%@", [mappingResult description]);
                 
             } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                 if (failuerBlock) {
                     failuerBlock(error);
                 }
             }];
    
}
- (void)getActivityTypeListForGivenOpportunity:(NSDictionary *)queryDictionary andSucessAction:(void (^)(id type))sucessBlock andFailuerAction:(void (^)(NSError *error))failuerBlock
{
    [self postPath:ACTIVITYTYPELISTURL parameters:queryDictionary success:^(AFRKHTTPRequestOperation *operation, id responseObject) {
        NSError *jsonError;
        
        id jsonDictionaryOrArray = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&jsonError];
        if(jsonError) {
            // check the error description
            failuerBlock(jsonError);
            NSLog(@"json error : %@", [jsonError localizedDescription]);
        } else {
            // use the jsonDictionaryOrArray
            if (sucessBlock) {
                sucessBlock(jsonDictionaryOrArray);
            }
        }
    } failure:^(AFRKHTTPRequestOperation *operation, NSError *error) {
        if (failuerBlock) {
            failuerBlock(error);
        }
        
    }];
}

#pragma mark - Financier

- (void)searchFinancierOpty:(NSDictionary *)queryDictionary andSucessAction:(void (^)(EGPagination *paginationObj))sucessBlock andFailuerAction:(void (^)(NSError *error))failuerBlock
{
    [self postObject:[[EGPagination alloc]init] path:searchFinancierOptyURL parameters:queryDictionary showLoader:NO showDefaultErrorMessage:YES success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        
        if (sucessBlock) {
            sucessBlock([mappingResult firstObject]);
        }
        NSLog(@"%@", [mappingResult description]);
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"%@",[error description]);
        if (failuerBlock) {
            failuerBlock(error);
        }
    }];
}
//get  fetch financier method 
- (void)fetchFinancier:(NSDictionary *)queryDictionary andSuccessAction:(void (^)(EGPagination *paginationObj))successBlock andFailuerAction:(void (^)(NSError *error))failuerBlock {

    [self postObject:[[EGPagination alloc] init] path:fetchFinancierURL
          parameters:queryDictionary
          showLoader:false showDefaultErrorMessage:true
             success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                 successBlock([mappingResult firstObject]);
             }
             failure:^(RKObjectRequestOperation *operation, NSError *error) {
                 failuerBlock(error);
             }];
}

//-(void)financierFieldFetchData:(NSDictionary *)queryDictionary andSucessAction:(void(^)(id financierFieldObj))sucessBlock andFailureAction:(void (^)(NSError *error))failuerBlock{
//
//    [self postPath:fetchFinancierURL parameters:queryDictionary success:^(AFRKHTTPRequestOperation *operation, id responseObject) {
//        
//        NSError *jsonError;
//        id jsonDictOrArray = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&jsonError];
//        if (jsonError) {
//            failuerBlock(jsonError);
//            NSLog(@"json error : %@", [jsonError localizedDescription]);
//        } else {
//            NSLog(@"SUCCESS");
//            if (sucessBlock) {
//                sucessBlock(jsonDictOrArray);
//            }
//        }
//    } failure:^(AFRKHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"FAILED");
//        if (failuerBlock) {
//            failuerBlock(error);
//        }
//    }];
//}

////post fetchinancierList detail method
//-(void)fetchFinancier:(NSDictionary *)queryDictionary andSucessAction:(void(^)(id financierFieldData))sucessBlock andFailureAction:(void (^)(NSError *error))failuerBlock{
//    
//    [self postPath:fetchFinancierURL parameters:queryDictionary success:^(AFRKHTTPRequestOperation *operation, id responseObject) {
//        
//        NSError *jsonError;
//        id jsonDictOrArray = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&jsonError];
//        if (jsonError) {
//            failuerBlock(jsonError);
//            NSLog(@"json error : %@", [jsonError localizedDescription]);
//        } else {
//            NSLog(@"SUCCESS");
//            if (sucessBlock) {
//                sucessBlock(jsonDictOrArray);
//            }
//        }
//    } failure:^(AFRKHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"FAILED");
//        if (failuerBlock) {
//            failuerBlock(error);
//        }
//    }];
//}

-(void)searchFinancier:(NSDictionary *)queryDictionary andSucessAction:(void(^)(id financier))sucessBlock andFailureAction:(void (^)(NSError *error))failuerBlock{
    
    [self postPath:SEARCHFINANCIERURL parameters:queryDictionary success:^(AFRKHTTPRequestOperation *operation, id responseObject) {
        
                NSError *jsonError;
                id jsonDictOrArray = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&jsonError];
                if (jsonError) {
                    failuerBlock(jsonError);
                    NSLog(@"json error : %@", [jsonError localizedDescription]);
                } else {
                    NSLog(@"SUCCESS");
                    if (sucessBlock) {
                        sucessBlock(jsonDictOrArray);
                    }
                }
            } failure:^(AFRKHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"FAILED");
                if (failuerBlock) {
                    failuerBlock(error);
                }
            }];
}

-(void)searchFinancierTMFBranch:(NSDictionary *)queryDictionary andSucessAction:(void(^)(id tmfBranchDetail))sucessBlock andFailureAction:(void (^)(NSError *error))failuerBlock{
    
   [self postPath:SEARCHBDMBranchURL parameters:queryDictionary success:^(AFRKHTTPRequestOperation *operation, id responseObject) {
        NSError *jsonError;
        
        id jsonDictOrArray = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&jsonError];
        if (jsonError) {
            failuerBlock(jsonError);
            NSLog(@"json error : %@", [jsonError localizedDescription]);
        } else {
            NSLog(@"SUCCESS");
            if (sucessBlock) {
                sucessBlock(jsonDictOrArray);
            }
        }
    } failure:^(AFRKHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"FAILED");
        if (failuerBlock) {
            failuerBlock(error);
        }
    }];
}

-(void)sendOTP:(NSDictionary *)queryDictionary andSucessAction:(void(^)(id otp))sucessBlock andFailureAction:(void (^)(NSError *error))failuerBlock{
    
    [self postPath:SENDOTPURL parameters:queryDictionary success:^(AFRKHTTPRequestOperation *operation, id responseObject) {
        NSError *jsonError;
        
        id jsonDictOrArray = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&jsonError];
        if (jsonError) {
            failuerBlock(jsonError);
            NSLog(@"json error : %@", [jsonError localizedDescription]);
        } else {
            NSLog(@"SUCCESS");
            if (sucessBlock) {
                sucessBlock(jsonDictOrArray);
            }
        }
    } failure:^(AFRKHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"FAILED");
        if (failuerBlock) {
            failuerBlock(error);
        }
    }];
    
}

-(void)verifyOTP:(NSDictionary *)queryDictionary andSucessAction:(void(^)(id verifiedMsg))sucessBlock andFailureAction:(void (^)(NSError *error))failuerBlock{
    
    [self postPath:VERIFYOTPURL parameters:queryDictionary success:^(AFRKHTTPRequestOperation *operation, id responseObject) {
        NSError *jsonError;
        
        id jsonDictOrArray = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&jsonError];
        if (jsonError) {
            failuerBlock(jsonError);
            NSLog(@"json error : %@", [jsonError localizedDescription]);
        } else {
            NSLog(@"SUCCESS");
            if (sucessBlock) {
                sucessBlock(jsonDictOrArray);
            }
        }
    } failure:^(AFRKHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"FAILED");
        if (failuerBlock) {
            failuerBlock(error);
        }
    }];
    
}


-(void)createFinancier:(NSDictionary *)queryDictionary andSucessAction:(void(^)(id response))sucessBlock andFailureAction:(void (^)(NSError *error))failuerBlock{
    
    [self postPath:CREATEFINANCIERURL parameters:queryDictionary success:^(AFRKHTTPRequestOperation *operation, id responseObject) {
        NSError *jsonError;
        
        id jsonDictOrArray = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&jsonError];
        if (jsonError) {
            failuerBlock(jsonError);
            NSLog(@"json error : %@", [jsonError localizedDescription]);
        } else {
            NSLog(@"SUCCESS");
            if (sucessBlock) {
                sucessBlock(jsonDictOrArray);
            }
        }
    } failure:^(AFRKHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"FAILED");
        if (failuerBlock) {
            failuerBlock(error);
        }
    }];
    
}

- (void)searchActivity:(NSDictionary *)queryDictionary andSucessAction:(void (^)(EGPagination *paginationObj))sucessBlock andFailuerAction:(void (^)(NSError *error))failuerBlock
{
    [self postObject:[[EGPagination alloc]init]
                path:SEARCHACTIVITYURL
          parameters:queryDictionary
          showLoader:NO
showDefaultErrorMessage:YES
             success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                 if (sucessBlock) {
                     sucessBlock([mappingResult firstObject]);
                 }
                 NSLog(@"%@", [mappingResult description]);
             }
             failure:^(RKObjectRequestOperation *operation, NSError *error) {
                 if (failuerBlock) {
                     failuerBlock(error);
                 }
             }];
}

- (void)updateActivity:(NSDictionary *)queryDictionary andSucessAction:(void (^)(id responseDictionary))sucessBlock andFailuerAction:(void (^)(NSError *error))failuerBlock {
    
    [self postPath:UPDATEACTIVITYURL
        parameters:queryDictionary
        showLoader:true
showDefaultErrorMessage:false
           success:^(AFRKHTTPRequestOperation *operation, id responseObject) {
               NSError *jsonError;
               
               id jsonDictionaryOrArray = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&jsonError];
               if(jsonError) {
                   // check the error description
                   failuerBlock(jsonError);
                   NSLog(@"json error : %@", [jsonError localizedDescription]);
               } else {
                   // use the jsonDictionaryOrArray
                   if (sucessBlock) {
                       sucessBlock(jsonDictionaryOrArray);
                   }
               }
           } failure:^(AFRKHTTPRequestOperation *operation, NSError *error) {
               if (failuerBlock) {
                   failuerBlock(error);
               }
               
           }];
}

# pragma mark - Address Operations

- (void)getStates:(NSDictionary *)queryDictionary andSucessAction:(void (^)(NSArray *statesArray))sucessBlock andFailuerAction:(void (^)(NSError *error))failuerBlock
{
    [self postObject:[[EGState alloc]init] path:STATELISTURL
          parameters:queryDictionary
             success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                 if (sucessBlock) {
                     sucessBlock([mappingResult array]);
                 }
                 NSLog(@"%@", [mappingResult description]);
             }
             failure:^(RKObjectRequestOperation *operation, NSError *error) {
                 if (failuerBlock) {
                     failuerBlock(error);
                 }
             }];
}

//- (void)searchFinancier:(NSDictionary *)queryDictionary andSucessAction:(void (^)(id financierArray))sucessBlock andFailuerAction:(void (^)(NSError *error))failuerBlock
//{
//    [self postPath:ACTIVITYTYPELISTURL parameters:queryDictionary success:^(AFRKHTTPRequestOperation *operation, id responseObject) {
//        NSError *jsonError;
//
//        id jsonDictionaryOrArray = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&jsonError];
//        if(jsonError) {
//            // check the error description
//            failuerBlock(jsonError);
//            NSLog(@"json error : %@", [jsonError localizedDescription]);
//        } else {
//            // use the jsonDictionaryOrArray
//            if (sucessBlock) {
//                sucessBlock(jsonDictionaryOrArray);
//            }
//        }
//    } failure:^(AFRKHTTPRequestOperation *operation, NSError *error) {
//        if (failuerBlock) {
//            failuerBlock(error);
//        }
//
//    }];
//}

- (void)getDistrictFromState:(NSDictionary *)queryDictionary andSucessAction:(void (^)(NSDictionary *contact))sucessBlock andFailuerAction:(void (^)(NSError *error))failuerBlock
{
    
    [self postPath:DISTRICTLISTURL parameters:queryDictionary success:^(AFRKHTTPRequestOperation *operation, id responseObject) {
        NSError *jsonError;
        
        id jsonDictionaryOrArray = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&jsonError];
        if(jsonError) {
            // check the error description
            failuerBlock(jsonError);
            NSLog(@"json error : %@", [jsonError localizedDescription]);
        } else {
            // use the jsonDictionaryOrArray
            if (sucessBlock) {
                sucessBlock(jsonDictionaryOrArray);
            }
        }
    } failure:^(AFRKHTTPRequestOperation *operation, NSError *error) {
        if (failuerBlock) {
            failuerBlock(error);
        }
        
    }];
    
    
}
- (void)getCityFromDistrict:(NSDictionary *)queryDictionary andSucessAction:(void (^)(NSDictionary *contact))sucessBlock andFailuerAction:(void (^)(NSError *error))failuerBlock
{
    [self postPath:CITYLISTURL parameters:queryDictionary success:^(AFRKHTTPRequestOperation *operation, id responseObject) {
        NSError *jsonError;
        
        id jsonDictionaryOrArray = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&jsonError];
        if(jsonError) {
            // check the error description
            failuerBlock(jsonError);
            NSLog(@"json error : %@", [jsonError localizedDescription]);
        } else {
            // use the jsonDictionaryOrArray
            if (sucessBlock) {
                sucessBlock(jsonDictionaryOrArray);
            }
        }
    } failure:^(AFRKHTTPRequestOperation *operation, NSError *error) {
        if (failuerBlock) {
            failuerBlock(error);
        }
        
    }];
}
- (void)getTalukaFromCityDistrict:(NSDictionary *)queryDictionary andSucessAction:(void (^)(NSDictionary *contact))sucessBlock andFailuerAction:(void (^)(NSError *error))failuerBlock
{
    [self postObject:[[EGTaluka alloc]init]
                path:TALUKALISTURL
          parameters:queryDictionary
             success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                 if (sucessBlock) {
                     sucessBlock([mappingResult dictionary]);
                 }
                 NSLog(@"%@", [mappingResult description]);
             }
             failure:^(RKObjectRequestOperation *operation, NSError *error) {
                 if (failuerBlock) {
                     failuerBlock(error);
                 }
             }];
}
- (void)getPinFromTalukaCityDistrictState:(NSDictionary *)queryDictionary andSucessAction:(void (^)(NSDictionary *contact))sucessBlock andFailuerAction:(void (^)(NSError *error))failuerBlock
{
    [self postPath:PINCODELISTURL parameters:queryDictionary showLoader:false showDefaultErrorMessage:false success:^(AFRKHTTPRequestOperation *operation, id responseObject) {
        NSError *jsonError;
        
        id jsonDictionaryOrArray = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&jsonError];
        if(jsonError) {
            // check the error description
            failuerBlock(jsonError);
            NSLog(@"json error : %@", [jsonError localizedDescription]);
        } else {
            // use the jsonDictionaryOrArray
            if (sucessBlock) {
                sucessBlock(jsonDictionaryOrArray);
            }
        }
    } failure:^(AFRKHTTPRequestOperation *operation, NSError *error) {
        if (failuerBlock) {
            failuerBlock(error);
        }
        
    }];
}
- (void)getAllFromPin:(NSDictionary *)queryDictionary andSucessAction:(void (^)(NSDictionary *contact))sucessBlock andFailuerAction:(void (^)(NSError *error))failuerBlock
{
    [self postPath:PINCODELISTURL parameters:queryDictionary success:^(AFRKHTTPRequestOperation *operation, id responseObject) {
        if (sucessBlock) {
            sucessBlock(responseObject);
        }
        
    } failure:^(AFRKHTTPRequestOperation *operation, NSError *error) {
        if (failuerBlock) {
            failuerBlock(error);
        }
        
    }];
}

- (void)getAllTaluka:(NSDictionary *)queryDictionary andSucessAction:(void (^)(id contact , EGRKWebserviceRepository *sender))sucessBlock andFailuerAction:(void (^)(NSError *error))failuerBlock
{
    [self postObject:[[EGTaluka alloc]init] path:LOCATIONBYTALUKALISTURL parameters:queryDictionary showLoader:false showDefaultErrorMessage:true success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        if (sucessBlock) {
            sucessBlock([mappingResult dictionary],self);
        }
        NSLog(@"Taluka DATADICT :%@ Taluka Result : %@",queryDictionary, [mappingResult description]);
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        if (failuerBlock) {
            failuerBlock(error);
        }
    }];
    
    
}


- (void)getAllPIN:(NSDictionary *)queryDictionary andSucessAction:(void (^)(EGReversePincode* reversePinData))sucessBlock andFailuerAction:(void (^)(NSError *error))failuerBlock
{
    [self postObject:[[EGReversePincode alloc]init]
                path:PINCODELISTURLFROMGPS
          parameters:queryDictionary
             success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                 if (sucessBlock) {
                     sucessBlock([mappingResult firstObject]);
                 }
                 NSLog(@"%@", [mappingResult description]);
             }
             failure:^(RKObjectRequestOperation *operation, NSError *error) {
                 if (failuerBlock) {
                     failuerBlock(error);
                 }
             }];
}


# pragma mark - Account Operations

- (void)searchAccount:(NSDictionary *)queryDictionary andSucessAction:(void (^)(EGPagination *paginationObj))sucessBlock andFailuerAction:(void (^)(NSError *error))failuerBlock
{
    
    [self postObject:[[EGPagination alloc]init]
                path:SEARCHACCOUNTURL parameters:queryDictionary
          showLoader:FALSE
showDefaultErrorMessage:YES
             success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                 if (sucessBlock) {
                     sucessBlock([mappingResult firstObject]);
                 }
                 NSLog(@"%@", [mappingResult description]);
                 
             } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                 if (failuerBlock) {
                     failuerBlock(error);
                 }
             }];
    
}

- (void)createAccount:(NSDictionary *)queryDictionary withShowLoading:(BOOL)shouldShowLoading andSucessAction:(void (^)(NSDictionary *contact))sucessBlock andFailuerAction:(void (^)(NSError *error))failuerBlock
{
    [self postPath:CREATEACCOUNTURL parameters:queryDictionary showLoader:shouldShowLoading showDefaultErrorMessage:shouldShowLoading success:^(AFRKHTTPRequestOperation *operation, id responseObject) {
        
        NSError *jsonError;
        
        id jsonDictionaryOrArray = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&jsonError];
        if(jsonError) {
            // check the error description
            failuerBlock(jsonError);
            NSLog(@"json error : %@", [jsonError localizedDescription]);
        } else {
            // use the jsonDictionaryOrArray
            if (sucessBlock) {
                sucessBlock(jsonDictionaryOrArray);
            }
        }
    } failure:^(AFRKHTTPRequestOperation *operation, NSError *error) {
        if (failuerBlock) {
            failuerBlock(error);
        }
        
    }];
    
}
- (void)createAccount:(NSDictionary *)queryDictionary andSucessAction:(void (^)(NSDictionary *contact))sucessBlock andFailuerAction:(void (^)(NSError *error))failuerBlock
{
    [self createAccount:queryDictionary withShowLoading:YES andSucessAction:sucessBlock andFailuerAction:failuerBlock];
}

# pragma mark - Other Fetch Operations

- (void)opprtunityLostResoneList:(NSDictionary *)queryDictionary andSucessAction:(void (^)(id contact))sucessBlock andFailuerAction:(void (^)(NSError *error))failuerBlock
{
    [self postPath:OPTYLOSTREASONURL parameters:queryDictionary success:^(AFRKHTTPRequestOperation *operation, id responseObject) {
        NSError *jsonError;
        
        id jsonDictionaryOrArray = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&jsonError];
        if(jsonError) {
            // check the error description
            failuerBlock(jsonError);
            NSLog(@"json error : %@", [jsonError localizedDescription]);
        } else {
            // use the jsonDictionaryOrArray
            if (sucessBlock) {
                sucessBlock(jsonDictionaryOrArray);
            }
        }
    } failure:^(AFRKHTTPRequestOperation *operation, NSError *error) {
        if (failuerBlock) {
            failuerBlock(error);
        }
        
    }];
}

- (void)opprtunityLostMakeList:(NSDictionary *)queryDictionary andSucessAction:(void (^)(id contact))sucessBlock andFailuerAction:(void (^)(NSError *error))failuerBlock
{
    [self postPath:OPTYLOSTMAKEURL parameters:queryDictionary success:^(AFRKHTTPRequestOperation *operation, id responseObject) {
        NSError *jsonError;
        
        id jsonDictionaryOrArray = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&jsonError];
        if(jsonError) {
            // check the error description
            failuerBlock(jsonError);
            NSLog(@"json error : %@", [jsonError localizedDescription]);
        } else {
            // use the jsonDictionaryOrArray
            if (sucessBlock) {
                sucessBlock(jsonDictionaryOrArray);
            }
        }
    } failure:^(AFRKHTTPRequestOperation *operation, NSError *error) {
        if (failuerBlock) {
            failuerBlock(error);
        }
        
    }];
}

- (void)opprtunityLostModelList:(NSDictionary *)queryDictionary andSucessAction:(void (^)(id contact))sucessBlock andFailuerAction:(void (^)(NSError *error))failuerBlock
{
    [self postPath:OPTYLOSTMODELURL parameters:queryDictionary success:^(AFRKHTTPRequestOperation *operation, id responseObject) {
        NSError *jsonError;
        
        id jsonDictionaryOrArray = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&jsonError];
        if(jsonError) {
            // check the error description
            failuerBlock(jsonError);
            NSLog(@"json error : %@", [jsonError localizedDescription]);
        } else {
            // use the jsonDictionaryOrArray
            if (sucessBlock) {
                sucessBlock(jsonDictionaryOrArray);
            }
        }
    } failure:^(AFRKHTTPRequestOperation *operation, NSError *error) {
        if (failuerBlock) {
            failuerBlock(error);
        }
        
    }];
}


- (void)mark_as_lost:(NSDictionary *)queryDictionary andSucessAction:(void (^)(id responseDictionary))sucessBlock andFailuerAction:(void (^)(AFRKHTTPRequestOperation *operation, NSError *error))failuerBlock {
    
    [self postPath:MARKASLOSTURL
        parameters:queryDictionary
        showLoader:true
showDefaultErrorMessage:false
           success:^(AFRKHTTPRequestOperation *operation, id responseObject) {
               NSError *jsonError;
               
               id jsonDictionaryOrArray = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&jsonError];
               if(jsonError) {
                   // check the error description
                   failuerBlock(operation, jsonError);
                   NSLog(@"json error : %@", [jsonError localizedDescription]);
               } else {
                   // use the jsonDictionaryOrArray
                   if (sucessBlock) {
                       sucessBlock(jsonDictionaryOrArray);
                   }
               }
           } failure:^(AFRKHTTPRequestOperation *operation, NSError *error) {
               if (failuerBlock) {
                   failuerBlock(operation, error);
               }
               
           }];
}





- (void)pplList:(NSDictionary *)queryDictionary andSucessAction:(void (^)(id contact))sucessBlock andFailuerAction:(void (^)(NSError *error))failuerBlock
{
    [self postPath:PPLLISTURL parameters:queryDictionary success:^(AFRKHTTPRequestOperation *operation, id responseObject) {
        NSError *jsonError;
        
        id jsonDictionaryOrArray = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&jsonError];
        if(jsonError) {
            // check the error description
            failuerBlock(jsonError);
            NSLog(@"json error : %@", [jsonError localizedDescription]);
        } else {
            // use the jsonDictionaryOrArray
            if (sucessBlock) {
                sucessBlock(jsonDictionaryOrArray);
            }
        }
    } failure:^(AFRKHTTPRequestOperation *operation, NSError *error) {
        if (failuerBlock) {
            failuerBlock(error);
        }
        
    }];
}
//SSL Pinning

//-(void)testSSLPinning{
//
//    AFRKHTTPClient * client = [RKObjectManager sharedManager].HTTPClient;
//
//    [client postPath:nil parameters:nil success:^(AFRKHTTPRequestOperation *operation, id responseObject) {
//        NSError *jsonError;
//
//        id jsonDictionaryOrArray = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&jsonError];
//        if(jsonError) {
//            // check the error description
//            NSLog(@"Valid cer");
//            NSLog(@"json error : %@", [jsonError localizedDescription]);
//        } else {
//            // use the jsonDictionaryOrArray
//            NSLog(@"Invalid cer");
//        }
//    } failure:^(AFRKHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"Invalid cer");
//
//    }];
//
//}

#pragma mark - Dashboard Operations

- (void)getPPLwisePipeline:(NSDictionary *)queryDictionary andSuccessAction:(void (^)(EGPagination *))successBlock andFailuerAction:(void (^)(NSError *))failuerBlock {
    
    [self postObject:[[EGPagination alloc] init] path:PPLPIPELINEURL
          parameters:queryDictionary
          showLoader:false showDefaultErrorMessage:true
             success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                 successBlock([mappingResult firstObject]);
             }
             failure:^(RKObjectRequestOperation *operation, NSError *error) {
                 failuerBlock(error);
             }];
}

- (void)getDSEwisePipeline:(NSDictionary *)queryDictionary andSuccessAction:(void (^)(EGPagination *))successBlock andFailuerAction:(void (^)(NSError *))failuerBlock {
    
    [self postObject:[[EGPagination alloc] init] path:DSEWiseURL
          parameters:queryDictionary
          showLoader:false showDefaultErrorMessage:false
             success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                 successBlock([mappingResult firstObject]);
             }
             failure:^(RKObjectRequestOperation *operation, NSError *error) {
                 failuerBlock(error);
             }];
}

- (void)getActualVsTargetPipeline:(NSDictionary *)queryDictionary andSuccessAction:(void (^)(EGPagination *))successBlock andFailuerAction:(void (^)(NSError *))failuerBlock {
    
    [self postObject:[[EGPagination alloc] init] path:ACTUALVSTARGETURL
          parameters:queryDictionary
          showLoader:false showDefaultErrorMessage:false
             success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                 successBlock([mappingResult firstObject]);
             }
             failure:^(RKObjectRequestOperation *operation, NSError *error) {
                 failuerBlock(error);
             }];
}
- (void)getDSEMiswisePipeline:(NSDictionary *)queryDictionary andSuccessAction:(void (^)(EGPagination *))successBlock andFailuerAction:(void (^)(NSError *))failuerBlock {
    
    [self postObject:[[EGPagination alloc] init] path:DSEMisWiseURL
          parameters:queryDictionary
          showLoader:false showDefaultErrorMessage:true
             success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                 successBlock([mappingResult firstObject]);
             }
             failure:^(RKObjectRequestOperation *operation, NSError *error) {
                 failuerBlock(error);
             }];
}

- (void)getDSEMisDetailswisePipeline:(NSDictionary *)queryDictionary andSuccessAction:(void (^)(EGPagination *))successBlock andFailuerAction:(void (^)(NSError *))failuerBlock {
    
    [self postObject:[[EGPagination alloc] init] path:DSEMisDetailsWiseURL
          parameters:queryDictionary
          showLoader:false showDefaultErrorMessage:true
             success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                 successBlock([mappingResult firstObject]);
             }
             failure:^(RKObjectRequestOperation *operation, NSError *error) {
                 failuerBlock(error);
             }];
}
- (void)getMMGeowisePipeline:(NSDictionary *)queryDictionary andSuccessAction:(void (^)(EGPagination *))successBlock andFailuerAction:(void (^)(NSError *))failuerBlock {
    
    [self postObject:[[EGPagination alloc] init] path:MMGEOPIPELINEURL
          parameters:queryDictionary
          showLoader:false showDefaultErrorMessage:true
             success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                 successBlock([mappingResult firstObject]);
             }
             failure:^(RKObjectRequestOperation *operation, NSError *error) {
                 failuerBlock(error);
             }];
}

- (void)getMMAPPwisePipeline:(NSDictionary *)queryDictionary andSuccessAction:(void (^)(EGPagination *))successBlock andFailuerAction:(void (^)(NSError *))failuerBlock {
    
    [self postObject:[[EGPagination alloc] init] path:MMAPPPIPELINEURL
          parameters:queryDictionary
          showLoader:false showDefaultErrorMessage:true
             success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                 successBlock([mappingResult firstObject]);
             }
             failure:^(RKObjectRequestOperation *operation, NSError *error) {
                 failuerBlock(error);
             }];
}

# pragma mark - NFA Operations

- (void)searchNFA:(NSDictionary *)queryDictionary andSucessAction:(void (^)(EGPagination *paginationObj))sucessBlock andFailuerAction:(void (^)(NSError *error))failuerBlock
{
    [self postObject:[[EGPagination alloc]init] path:SEARCHNFAURL parameters:queryDictionary showLoader:NO showDefaultErrorMessage:YES success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        
        if (sucessBlock) {
            sucessBlock([mappingResult firstObject]);
        }
        NSLog(@"%@", [mappingResult description]);
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"%@",[error description]);
        if (failuerBlock) {
            failuerBlock(error);
        }
    }];
    
}

- (void)getDealTypeSuccessAction:(void (^)(NSArray *))successBlock andFailuerAction:(void (^)(NSError *))failuerBlock {
    
    [self postPath:NFA_DEAL_TYPE_URL parameters:nil success:^(AFRKHTTPRequestOperation *operation, id responseObject) {
        NSError *jsonError;
        
        id jsonDictionaryOrArray = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&jsonError];
        if(jsonError) {
            // check the error description
            failuerBlock(jsonError);
            NSLog(@"json error : %@", [jsonError localizedDescription]);
        } else {
            // use the jsonDictionaryOrArray
            if (successBlock) {
                successBlock(jsonDictionaryOrArray);
            }
        }
    } failure:^(AFRKHTTPRequestOperation *operation, NSError *error) {
        failuerBlock(error);
    }];
}

- (void)getBillingSuccessAction:(void (^)(NSArray *))successBlock andFailuerAction:(void (^)(NSError *))failuerBlock {
    
    [self postPath:NFA_BILLING_URL parameters:nil success:^(AFRKHTTPRequestOperation *operation, id responseObject) {
        NSError *jsonError;
        
        id jsonDictionaryOrArray = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&jsonError];
        if(jsonError) {
            // check the error description
            failuerBlock(jsonError);
            NSLog(@"json error : %@", [jsonError localizedDescription]);
        } else {
            // use the jsonDictionaryOrArray
            if (successBlock) {
                successBlock(jsonDictionaryOrArray);
            }
        }
    } failure:^(AFRKHTTPRequestOperation *operation, NSError *error) {
        failuerBlock(error);
    }];
}

- (void)createNFA:(NSDictionary *)requestDictionary andSuccessAction:(void (^)(NSDictionary *responseDictionary))successBlock andFailuerAction:(void (^)(NSError *error))failuerBlock {
    
    [self postPath:NFA_CREATE_URL parameters:requestDictionary success:^(AFRKHTTPRequestOperation *operation, id responseObject) {
        if (successBlock) {
            [UtilityMethods convertResponseToJSON:responseObject success:^(id  _Nullable jsonResponse) {
                successBlock(jsonResponse);
            } failure:^(NSError * _Nullable error) {
                failuerBlock(error);
            }];
        }
    } failure:^(AFRKHTTPRequestOperation *operation, NSError *error) {
        if (failuerBlock) {
            failuerBlock(error);
        }
    }
     ];
}

- (void)updateNFA:(NSDictionary *)requestDictionary andSuccessAction:(void (^)(NSDictionary *responseDictionary))successBlock andFailuerAction:(void (^)(NSError *error))failuerBlock {
    
    [self postPath:NFA_UPDATE_URL parameters:requestDictionary success:^(AFRKHTTPRequestOperation *operation, id responseObject) {
        if (successBlock) {
            [UtilityMethods convertResponseToJSON:responseObject success:^(id  _Nullable jsonResponse) {
                successBlock(jsonResponse);
            } failure:^(NSError * _Nullable error) {
                failuerBlock(error);
            }];
        }
    } failure:^(AFRKHTTPRequestOperation *operation, NSError *error) {
        if (failuerBlock) {
            failuerBlock(error);
        }
    }
     ];
}

- (void)getUserPosition:(NSDictionary *)queryDictionary andSuccessAction:(void (^)(NSArray *))successBlock andFailuerAction:(void (^)(NSError *error))failuerBlock {
    
    [self postObject:[[NFAUserPositionModel alloc] init]
                path:NFA_GET_USER_POSITION
          parameters:queryDictionary
          showLoader:true
showDefaultErrorMessage:true
             success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                 if (successBlock) {
                     successBlock([mappingResult array]);
                 }
                 NSLog(@"%@", [mappingResult description]);
             }
             failure:^(RKObjectRequestOperation *operation, NSError *error) {
                 if (failuerBlock) {
                     failuerBlock(error);
                 }
             }];
}

- (void)getNextAuthority:(NSDictionary *)queryDictionary andSuccessAction:(void (^)(NFANextAuthorityModel *))successBlock andFailuerAction:(void (^)(NSError *error))failuerBlock {
    
    [self postObject:[[NFANextAuthorityModel alloc] init]
                path:NFA_GET_NEXT_AUTHORITY
          parameters:queryDictionary
          showLoader:true
showDefaultErrorMessage:true
             success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                 if (successBlock) {
                     successBlock([mappingResult firstObject]);
                 }
                 NSLog(@"%@", [mappingResult description]);
             }
             failure:^(RKObjectRequestOperation *operation, NSError *error) {
                 if (failuerBlock) {
                     failuerBlock(error);
                 }
             }];
}

#pragma mark - PUSH NOTIFICATIONS

- (void)registerDeviceForNotification:(NSDictionary *)queryDictionary
                     andSuccessAction:(void (^)(NSDictionary *response))successBlock
                     andFailureAction:(void (^)(NSError *error))failureBlock {
    
    [self postPath:REGISTER_DEVICE parameters:queryDictionary showLoader:NO showDefaultErrorMessage:NO
           success:^(AFRKHTTPRequestOperation *operation, id responseObject) {
               NSError *jsonError;
               
               id jsonDictionaryOrArray = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&jsonError];
               if(jsonError) {
                   // check the error description
                   failureBlock(jsonError);
                   NSLog(@"json error : %@", [jsonError localizedDescription]);
               } else {
                   // use the jsonDictionaryOrArray
                   if (successBlock) {
                       successBlock(jsonDictionaryOrArray);
                   }
               }
           } failure:^(AFRKHTTPRequestOperation *operation, NSError *error) {
               if (failureBlock) {
                   failureBlock(error);
               }
               
           }];
}

- (void)deRegisterDeviceFromNotification:(NSDictionary *)queryDictionary
                        andSuccessAction:(void (^)(NSDictionary *response))successBlock
                        andFailureAction:(void (^)(NSError *error))failureBlock {
    
    [self postPath:DEREGISTER_DEVICE parameters:queryDictionary showLoader:NO showDefaultErrorMessage:NO
           success:^(AFRKHTTPRequestOperation *operation, id responseObject) {
               NSError *jsonError;
               
               id jsonDictionaryOrArray = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&jsonError];
               if(jsonError) {
                   // check the error description
                   failureBlock(jsonError);
                   NSLog(@"json error : %@", [jsonError localizedDescription]);
               } else {
                   // use the jsonDictionaryOrArray
                   if (successBlock) {
                       successBlock(jsonDictionaryOrArray);
                   }
               }
           } failure:^(AFRKHTTPRequestOperation *operation, NSError *error) {
               if (failureBlock) {
                   failureBlock(error);
               }
               
           }];
}

- (void)getNotificationList:(NSDictionary *)queryDictionary andSuccessAction:(void (^)(EGPagination *))successBlock andFailuerAction:(void (^)(NSError *))failuerBlock {
    
    [self postObject:[[EGPagination alloc] init] path:GET_NOTIFICATION_LIST
          parameters:queryDictionary
          showLoader:false showDefaultErrorMessage:true
             success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                 successBlock([mappingResult firstObject]);
             }
             failure:^(RKObjectRequestOperation *operation, NSError *error) {
                 failuerBlock(error);
             }];
}

- (void)deleteNotification:(NSDictionary *)queryDictionary andSucessAction:(void (^)(NSDictionary *responseDict))sucessBlock andFailuerAction:(void (^)(NSError *error))failuerBlock {
    
    [self postPath:DELETE_NOTIFICATION parameters:queryDictionary success:^(AFRKHTTPRequestOperation *operation, id responseObject) {
        NSError *jsonError;
        
        id jsonDictionaryOrArray = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&jsonError];
        if(jsonError) {
            // check the error description
            failuerBlock(jsonError);
            NSLog(@"json error : %@", [jsonError localizedDescription]);
        } else {
            // use the jsonDictionaryOrArray
            if (sucessBlock) {
                sucessBlock(jsonDictionaryOrArray);
            }
        }
    } failure:^(AFRKHTTPRequestOperation *operation, NSError *error) {
        if (failuerBlock) {
            failuerBlock(error);
        }
        
    }];
}

#pragma mark - Email Quotation

- (void)getQuotationDetails:(NSDictionary *)queryDictionary andSuccessAction:(void (^)(EGQuotation *))successBlock andFailuerAction:(void (^)(NSError *error))failuerBlock {
    
    [self postObject:[[EGQuotation alloc] init]
                path:GET_QUOTATION_DETAILS
          parameters:queryDictionary
          showLoader:true
showDefaultErrorMessage:true
             success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                 if (successBlock) {
                     successBlock([mappingResult firstObject]);
                 }
                 NSLog(@"%@", [mappingResult description]);
             }
             failure:^(RKObjectRequestOperation *operation, NSError *error) {
                 if (failuerBlock) {
                     failuerBlock(error);
                 }
             }];
}

#pragma mark - POST COMMON METHODS

- (void)postObject:(id)object
              path:(NSString *)path
        parameters:(NSDictionary *)parameters
           success:(void (^)(RKObjectRequestOperation *operation, RKMappingResult *mappingResult))success
           failure:(void (^)(RKObjectRequestOperation *operation, NSError *error))failure {
    
    [self postObject:object path:path parameters:parameters showLoader:true showDefaultErrorMessage:true success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        success(operation, mappingResult);
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        failure(operation, error);
    }];
}

- (void)postObject:(id)object
              path:(NSString *)path
        parameters:(NSDictionary *)parameters
        showLoader:(BOOL)showLoader
showDefaultErrorMessage:(BOOL)showDefaultError
           success:(void (^)(RKObjectRequestOperation *operation, RKMappingResult *mappingResult))success
           failure:(void (^)(RKObjectRequestOperation *operation, NSError *error))failure {
    
    if (![path isEqualToString:LOGINURL]) {
        NSLog(@"Request:%@%@", BaseURL, path);
        NSLog(@"Params:%@", parameters);
    }
    
    // Show Loader
    [UtilityMethods showProgressHUD:showLoader];
    // Prepare Object Manager
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    
    // Set Access Token (Not for login API)
    if (![path isEqualToString:LOGINURL]) {
        [self setAccessToken:objectManager];
    }
    [objectManager postObject:object
                         path:path
                   parameters:parameters
                      success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                          // Hide Loader
                          NSLog(@"%@",operation.HTTPRequestOperation.responseString);
                          if (showLoader) {
                              [UtilityMethods hideProgressHUD];
                          }
                          if (success) {
                              if (showDefaultError) {
                                  if ([mappingResult count] == 0) {
                                      [UtilityMethods showToastWithMessage:NO_DATA_MESSAGE];
                                  }
                              }
                              success(operation, mappingResult);
                          }
                          
                      } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                          NSLog(@"TTT FAILED");
                          // Hide Loader
                          if (showLoader) {
                              [UtilityMethods hideProgressHUD];
                          }
                          NSLog(@"status code ---->%ld",(long)operation.HTTPRequestOperation.response.statusCode);
                          if (failure) {
                              if (operation.HTTPRequestOperation.response.statusCode == 401) { // access token expired
                                  
                                  if ([path isEqualToString:LOGINURL]) {
                                      [UtilityMethods convertJSONStringToDictionary:error.localizedRecoverySuggestion success:^(NSDictionary * _Nullable jsonDictionary) {
                                          [UtilityMethods showToastWithMessage:[jsonDictionary objectForKey:@"msg"]];
                                      } failure:^(NSError * _Nullable error) {
                                          
                                      }];
                                  }
                                  else {
                                      PostHelper *postHelper = [[PostHelper alloc] init];
                                      postHelper.object = object;
                                      postHelper.path = path;
                                      postHelper.parameters = parameters;
                                      postHelper.successBlock = success;
                                      postHelper.failureBlock = failure;
                                      postHelper.postRequestType = PostRequestTypeMapped;
                                      
                                      [[AccessTokenManager sharedManager] renewAccessToken:postHelper];
                                  }
                              }
                              else if (operation.HTTPRequestOperation.response.statusCode == 412){
                                  [UtilityMethods convertJSONStringToDictionary:error.localizedRecoverySuggestion success:^(NSDictionary * _Nullable jsonDictionary) {
                                      [UtilityMethods showToastWithMessage:[jsonDictionary objectForKey:@"msg"]];
                                      failure(operation, error);
                                      
                                  } failure:^(NSError * _Nullable error) {
                                      failure(operation, error);
                                  }];
                              }
                              else if (operation.HTTPRequestOperation.response.statusCode == 0){
                                  // failure(operation, error);
                                  [UtilityMethods convertJSONStringToDictionary:error.localizedRecoverySuggestion success:^(NSDictionary * _Nullable jsonDictionary) {
                                      [UtilityMethods showToastWithMessage:[jsonDictionary objectForKey:@"msg"]];
                                      failure(operation, error);
                                      
                                  } failure:^(NSError * _Nullable mError) {
                                      failure(operation, error);
                                  }];
                                  
                              }
                              else if (operation.HTTPRequestOperation.response.statusCode == 500){
                                  [UtilityMethods showToastWithMessage:[error localizedDescription]];
                                  failure(operation, error);
                              }
                              else {
                                  if (showDefaultError) {
                                      //[UtilityMethods showToastWithMessage:NO_DATA_MESSAGE];
                                  }
                                  failure(operation, error);
                              }
                          }
                      }];
}

- (void)postPath:(NSString *)path
      parameters:(NSDictionary *)parameters
         success:(void (^)(AFRKHTTPRequestOperation *operation, id responseObject))success
         failure:(void (^)(AFRKHTTPRequestOperation *operation, NSError *error))failure {
    
    [self postPath:path parameters:parameters showLoader:true showDefaultErrorMessage:true success:^(AFRKHTTPRequestOperation *operation, id responseObject) {
        success(operation, responseObject);
    } failure:^(AFRKHTTPRequestOperation *operation, NSError *error) {
        failure(operation, error);
    }];
}

- (void)postPath:(NSString *)path
      parameters:(NSDictionary *)parameters
      showLoader:(BOOL)showLoader
showDefaultErrorMessage:(BOOL)showDefaultError
         success:(void (^)(AFRKHTTPRequestOperation *operation, id responseObject))success
         failure:(void (^)(AFRKHTTPRequestOperation *operation, NSError *error))failure {
    
    NSLog(@"Request:%@%@", BaseURL, path);
    NSLog(@"Params:%@", parameters);
    
    [UtilityMethods showProgressHUD:showLoader];
    // Prepare Object Manager
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    // Set Access Token
    [self setAccessToken:objectManager];
    [objectManager.HTTPClient postPath:path parameters:parameters success:^(AFRKHTTPRequestOperation *operation, id responseObject) {
        
        if (showLoader) {
            [UtilityMethods hideProgressHUD];
        }
        if (success) {
            
            // Logic to show No Data toast message
            if (showDefaultError) {
                
                [UtilityMethods convertResponseToJSON:responseObject success:^(id jsonResponse) {
                    if ([jsonResponse isKindOfClass:[NSDictionary class]]) {
                        NSDictionary *dictionary = (NSDictionary *)jsonResponse;
                        if (!dictionary || [dictionary count] == 0) {
                            [UtilityMethods showToastWithMessage:NO_DATA_MESSAGE];
                        }
                    }
                    else if ([jsonResponse isKindOfClass:[NSArray class]]){
                        NSArray *array = (NSArray *)jsonResponse;
                        if (!array || [array count] == 0) {
                            [UtilityMethods showToastWithMessage:NO_DATA_MESSAGE];
                        }
                    }
                } failure:^(NSError *error) {
                    [UtilityMethods showToastWithMessage:NO_DATA_MESSAGE];
                }];
            }
            
            success(operation, responseObject);
        }
        
    } failure:^(AFRKHTTPRequestOperation *operation, NSError *error) {
        
        // Hide Loader
        if (showLoader) {
            [UtilityMethods hideProgressHUD];
        }
        if (failure) {
            if (operation.response.statusCode == 401) { // access token expired
                
                PostHelper *postHelper = [[PostHelper alloc] init];
                postHelper.path = path;
                postHelper.parameters = parameters;
                postHelper.afSuccessBlock = success;
                postHelper.afFailureBlock = failure;
                postHelper.postRequestType = PostRequestTypeUnMapped;
                
                [[AccessTokenManager sharedManager] renewAccessToken:postHelper];
            }
            else if (operation.response.statusCode == 412){
                [UtilityMethods showToastWithMessage:[error localizedRecoverySuggestion]];
                [UtilityMethods hideProgressHUD];
                
                @try {
               
                [UtilityMethods convertJSONStringToDictionary:error.localizedRecoverySuggestion success:^(NSDictionary * _Nullable jsonDictionary) {
                    id responseMessage = [jsonDictionary objectForKey:@"msg"];
                    
                    if ([responseMessage isKindOfClass:[NSString class]]) {
                        [UtilityMethods showToastWithMessage:[jsonDictionary objectForKey:@"msg"]];
                    }
                    else if([responseMessage isKindOfClass:[NSDictionary class]]) {
                        NSDictionary *responseDictionary = (NSDictionary *)responseMessage;
                        id message = [responseDictionary objectForKey:@"Failed"];
                        if (message && [message isKindOfClass:[NSString class]]) {
                            [UtilityMethods showToastWithMessage:message];
                        }
                    }
                    failure(operation, error);
                    
                } failure:^(NSError * _Nullable error) {
                    [UtilityMethods showToastWithMessage:[error localizedDescription]];
                    failure(operation, error);
                }];
                
                } @catch (NSException *exception) {
                    [UtilityMethods showToastWithMessage:@"No Results Found"];
                }
                
            }
            else if (operation.response.statusCode == 0){
                failure(operation, error);
            }
            else if (operation.response.statusCode == 500){
                [UtilityMethods showToastWithMessage:[error localizedDescription]];
                failure(operation, error);
            }
            
            else {
                if (showDefaultError) {
                    [UtilityMethods showToastWithMessage:NO_DATA_MESSAGE];
                }
                failure(operation, error);
            }
        }
        
    }];
}


- (void)getPath:(NSString *)path
     parameters:(NSDictionary *)parameters
        success:(void (^)(AFRKHTTPRequestOperation *operation, id responseObject))success
        failure:(void (^)(AFRKHTTPRequestOperation *operation, NSError *error))failure {
    
    [self getPath:path parameters:parameters showLoader:true showDefaultErrorMessage:true success:^(AFRKHTTPRequestOperation *operation, id responseObject) {
        success(operation, responseObject);
    } failure:^(AFRKHTTPRequestOperation *operation, NSError *error) {
        failure(operation, error);
    }];
}

- (void)getPath:(NSString *)path
     parameters:(NSDictionary *)parameters
     showLoader:(BOOL)showLoader
showDefaultErrorMessage:(BOOL)showDefaultError
        success:(void (^)(AFRKHTTPRequestOperation *operation, id responseObject))success
        failure:(void (^)(AFRKHTTPRequestOperation *operation, NSError *error))failure {
    
    NSLog(@"Request:%@%@", BaseURL, path);
    NSLog(@"Params:%@", parameters);
    
    [UtilityMethods showProgressHUD:showLoader];
    // Prepare Object Manager
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    
    [self setAccessToken:objectManager];
    
    //    [objectManager.HTTPClient postPath:path parameters:parameters success:^(AFRKHTTPRequestOperation *operation, id responseObject) {
    [objectManager.HTTPClient getPath:path parameters:parameters success:^(AFRKHTTPRequestOperation *operation, id responseObject) {
        
        
        if (showLoader) {
            [UtilityMethods hideProgressHUD];
        }
        if (success) {
            
            // Logic to show No Data toast message
            if (showDefaultError) {
                
                [UtilityMethods convertResponseToJSON:responseObject success:^(id jsonResponse) {
                    if ([jsonResponse isKindOfClass:[NSDictionary class]]) {
                        NSDictionary *dictionary = (NSDictionary *)jsonResponse;
                        if (!dictionary || [dictionary count] == 0) {
                            [UtilityMethods showToastWithMessage:NO_DATA_MESSAGE];
                        }
                    }
                    else if ([jsonResponse isKindOfClass:[NSArray class]]){
                        NSArray *array = (NSArray *)jsonResponse;
                        if (!array || [array count] == 0) {
                            [UtilityMethods showToastWithMessage:NO_DATA_MESSAGE];
                        }
                    }
                } failure:^(NSError *error) {
                    [UtilityMethods showToastWithMessage:NO_DATA_MESSAGE];
                }];
            }
            
            success(operation, responseObject);
        }
        
    } failure:^(AFRKHTTPRequestOperation *operation, NSError *error) {
        
        if (showLoader) {
            [UtilityMethods hideProgressHUD];
        }
        if (failure) {
            if (operation.response.statusCode == 401) { // access token expired
                
                PostHelper *postHelper = [[PostHelper alloc] init];
                postHelper.path = path;
                postHelper.parameters = parameters;
                postHelper.afSuccessBlock = success;
                postHelper.afFailureBlock = failure;
                postHelper.postRequestType = PostRequestTypeUnMapped;
                
                [[AccessTokenManager sharedManager] renewAccessToken:postHelper];
            }
            else if (operation.response.statusCode == 412){
                [UtilityMethods showToastWithMessage:[error localizedRecoverySuggestion]];
                
                [UtilityMethods convertJSONStringToDictionary:error.localizedRecoverySuggestion success:^(NSDictionary * _Nullable jsonDictionary) {
                    id responseMessage = [jsonDictionary objectForKey:@"msg"];
                    if ([responseMessage isKindOfClass:[NSString class]]) {
                        [UtilityMethods showToastWithMessage:[jsonDictionary objectForKey:@"msg"]];
                    }
                    else if([responseMessage isKindOfClass:[NSDictionary class]]) {
                        NSDictionary *responseDictionary = (NSDictionary *)responseMessage;
                        id message = [responseDictionary objectForKey:@"Failed"];
                        if (message && [message isKindOfClass:[NSString class]]) {
                            [UtilityMethods showToastWithMessage:message];
                        }
                    }
                    failure(operation, error);
                    
                } failure:^(NSError * _Nullable error) {
                    [UtilityMethods showToastWithMessage:[error localizedDescription]];
                    failure(operation, error);
                }];
            }
            else if (operation.response.statusCode == 0){
                failure(operation, error);
            }
            else if (operation.response.statusCode == 500){
                [UtilityMethods showToastWithMessage:[error localizedDescription]];
                failure(operation, error);
            }
            
            else {
                if (showDefaultError) {
                    [UtilityMethods showToastWithMessage:NO_DATA_MESSAGE];
                }
                failure(operation, error);
            }
        }
        
    }];
}

#pragma mark - Exclusion
- (void)applyLeave:(NSDictionary *)queryDictionary andSucessAction:(void (^)(id responseDictionary))sucessBlock andFailuerAction:(void (^)(NSError *error))failuerBlock {
    
    [self postPath:DSELEAVEURL
        parameters:queryDictionary
        showLoader:true
showDefaultErrorMessage:false
           success:^(AFRKHTTPRequestOperation *operation, id responseObject) {
               NSError *jsonError;
               
               id jsonDictionaryOrArray = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&jsonError];
               if(jsonError) {
                   // check the error description
                   failuerBlock(jsonError);
                   NSLog(@"json error : %@", [jsonError localizedDescription]);
               } else {
                   // use the jsonDictionaryOrArray
                   if (sucessBlock) {
                       sucessBlock(jsonDictionaryOrArray);
                   }
               }
           } failure:^(AFRKHTTPRequestOperation *operation, NSError *error) {
               if (failuerBlock) {
                   failuerBlock(error);
               }
               
           }];
}

- (void)cancelLeave:(NSDictionary *)queryDictionary andSucessAction:(void (^)(id responseDictionary))sucessBlock andFailuerAction:(void (^)(NSError *error))failuerBlock {
    
    [self postPath:DSECANCELLEAVEURL
        parameters:queryDictionary
        showLoader:true
showDefaultErrorMessage:false
           success:^(AFRKHTTPRequestOperation *operation, id responseObject) {
               NSError *jsonError;
               
               id jsonDictionaryOrArray = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&jsonError];
               if(jsonError) {
                   // check the error description
                   failuerBlock(jsonError);
                   NSLog(@"json error : %@", [jsonError localizedDescription]);
               } else {
                   // use the jsonDictionaryOrArray
                   if (sucessBlock) {
                       sucessBlock(jsonDictionaryOrArray);
                   }
               }
           } failure:^(AFRKHTTPRequestOperation *operation, NSError *error) {
               if (failuerBlock) {
                   failuerBlock(error);
               }
               
           }];
}
- (void)getExclusionlist:(NSDictionary *)queryDictionary andSucessAction:(void (^)(id contact))sucessBlock andFailuerAction:(void (^)(NSError *error))failuerBlock showLoader:(BOOL) showLoader
{
    [self postObject:[[EGExclusionListModel alloc]init]
                path:EXCLUSIONLISTURL
          parameters:queryDictionary
          showLoader:showLoader
showDefaultErrorMessage:true
             success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                 if (sucessBlock) {
                     sucessBlock([mappingResult firstObject]);
                 }
                 NSLog(@"%@", [mappingResult description]);
             }
             failure:^(RKObjectRequestOperation *operation, NSError *error) {
                 if (failuerBlock) {
                     failuerBlock(error);
                 }
             }];
}

#pragma mark - Parameter Settings
- (void)getParameterSettings:(NSDictionary *)queryDictionary andSucessAction:(void (^)(NSDictionary* parameters))sucessBlock andFailuerAction:(void (^)(NSError *error))failuerBlock showLoader:(BOOL) showLoader{
    [self postPath:PARAMETERSETTINGSURL
        parameters:queryDictionary
        showLoader:true
showDefaultErrorMessage:false
           success:^(AFRKHTTPRequestOperation *operation, id responseObject) {
               NSError *jsonError;
               
               id jsonDictionaryOrArray = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&jsonError];
               if(jsonError) {
                   // check the error description
                   failuerBlock(jsonError);
                   NSLog(@"json error : %@", [jsonError localizedDescription]);
               } else {
                   // use the jsonDictionaryOrArray
                   if (sucessBlock) {
                       sucessBlock(jsonDictionaryOrArray);
                   }
               }
           } failure:^(AFRKHTTPRequestOperation *operation, NSError *error) {
               if (failuerBlock) {
                   failuerBlock(error);
               }
               
           }];
    
//    [self postObject:[[EGParameterListModel alloc]init]
//                path:PARAMETERSETTINGSURL
//          parameters:queryDictionary
//          showLoader:showLoader
//showDefaultErrorMessage:true
//             success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
//                 if (sucessBlock) {
//                     sucessBlock([mappingResult firstObject]);
//                 }
//                 NSLog(@"%@", [mappingResult description]);
//             }
//             failure:^(RKObjectRequestOperation *operation, NSError *error) {
//                 if (failuerBlock) {
//                     failuerBlock(error);
//                 }
//             }];
}

#pragma mark - My Influencer API
- (void)getMyInfluencerAPI:(NSDictionary *)queryDictionary andSucessAction:(void (^)(AFRKHTTPRequestOperation *op, id responseObject))sucessBlock andFailuerAction:(void (^)(AFRKHTTPRequestOperation *operation, NSError *error))failuerBlock
{
    AFRKHTTPClient *httpClient = [AFRKHTTPClient clientWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BaseURL,MYINFLUENCERURL]]]; //This can be re-used within a class property
    
    AAATokenMO *tokenObject = [[AppRepo sharedRepo] getTokenDetails];
    if (tokenObject) {
        NSString *value = [NSString stringWithFormat:@"%@ %@", tokenObject.tokenType, tokenObject.accessToken];
        [httpClient setDefaultHeader:@"Authorization" value:value];
    }
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:[NSString stringWithFormat:@"%@%@",BaseURL,MYINFLUENCERURL] parameters:queryDictionary];
    
    AFRKJSONRequestOperation *operation = [AFRKJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSLog(@"%@", JSON);
        sucessBlock(nil,JSON);
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"Request Failed with Error: %@, %@", error, error.userInfo);
        
        if (response.statusCode == 401) { // access token expired
            
            PostHelper *postHelper = [[PostHelper alloc] init];
            postHelper.path = MYINFLUENCERURL;
            postHelper.parameters = queryDictionary;
            postHelper.afSuccessBlock = sucessBlock;
            postHelper.afFailureBlock = failuerBlock;
            postHelper.postRequestType = PostRequestTypeUnMapped;

            [[AccessTokenManager sharedManager] renewAccessToken:postHelper];
        }
        else if (response.statusCode == 412){
            [UtilityMethods convertJSONStringToDictionary:error.localizedRecoverySuggestion success:^(NSDictionary * _Nullable jsonDictionary) {
                [UtilityMethods showToastWithMessage:[jsonDictionary objectForKey:@"msg"]];
                failuerBlock(nil,error);
            } failure:^(NSError * _Nullable error) {
                failuerBlock(nil,error);
            }];
        }
        else if (response.statusCode == 0){
            // failure(operation, error);
            [UtilityMethods convertJSONStringToDictionary:error.localizedRecoverySuggestion success:^(NSDictionary * _Nullable jsonDictionary) {
                [UtilityMethods showToastWithMessage:[jsonDictionary objectForKey:@"msg"]];
                failuerBlock(nil,error);
            } failure:^(NSError * _Nullable mError) {
                failuerBlock(nil,error);
            }];
        }
        else if (response.statusCode == 500){
            [UtilityMethods showToastWithMessage:[error localizedDescription]];
            failuerBlock(nil,error);
        }
        else {
            failuerBlock(nil,error);
        }
    }];
    [operation start];
}
- (void)addCustomerAPI:(NSDictionary *)queryDictionary isUpdate:(BOOL)isUpdate andSucessAction:(void (^)(AFRKHTTPRequestOperation *op, id responseObject))sucessBlock andFailuerAction:(void (^)(AFRKHTTPRequestOperation *operation, NSError *error))failuerBlock{
    
    NSString *urlString;
    if(isUpdate){
        urlString = [NSString stringWithFormat:@"%@%@",BaseURL,UPDATE_CUSTOMER];
    }else{
        urlString = [NSString stringWithFormat:@"%@%@",BaseURL,ADD_CUSTOMER];
    }
    AFRKHTTPClient *httpClient = [AFRKHTTPClient clientWithBaseURL:[NSURL URLWithString:urlString]];
    httpClient.parameterEncoding = AFRKJSONParameterEncoding;
    AAATokenMO *tokenObject = [[AppRepo sharedRepo] getTokenDetails];
    if (tokenObject) {
        NSString *value = [NSString stringWithFormat:@"%@ %@", tokenObject.tokenType, tokenObject.accessToken];
        [httpClient setDefaultHeader:@"Authorization" value:value];
    }
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:urlString parameters:queryDictionary];
    
    AFRKJSONRequestOperation *operation = [AFRKJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSLog(@"%@", JSON);
        sucessBlock(nil,JSON);
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"Request Failed with Error: %@, %@", error, error.userInfo);
        
        if (response.statusCode == 401) { // access token expired
            
            PostHelper *postHelper = [[PostHelper alloc] init];
            postHelper.path = isUpdate ? UPDATE_CUSTOMER : ADD_CUSTOMER;
            postHelper.parameters = queryDictionary;
            postHelper.afSuccessBlock = sucessBlock;
            postHelper.afFailureBlock = failuerBlock;
            postHelper.postRequestType = PostRequestTypeUnMapped;
            
            [[AccessTokenManager sharedManager] renewAccessToken:postHelper];
        }
        else if (response.statusCode == 412){
            [UtilityMethods convertJSONStringToDictionary:error.localizedRecoverySuggestion success:^(NSDictionary * _Nullable jsonDictionary) {
                [UtilityMethods showToastWithMessage:[jsonDictionary objectForKey:@"msg"]];
                failuerBlock(nil,error);
            } failure:^(NSError * _Nullable error) {
                failuerBlock(nil,error);
            }];
        }
        else if (response.statusCode == 0){
            // failure(operation, error);
            [UtilityMethods convertJSONStringToDictionary:error.localizedRecoverySuggestion success:^(NSDictionary * _Nullable jsonDictionary) {
                [UtilityMethods showToastWithMessage:[jsonDictionary objectForKey:@"msg"]];
                failuerBlock(nil,error);
            } failure:^(NSError * _Nullable mError) {
                failuerBlock(nil,error);
            }];
        }
        else if (response.statusCode == 500){
            [UtilityMethods showToastWithMessage:[error localizedDescription]];
            failuerBlock(nil,error);
        }
        else {
            failuerBlock(nil,error);
        }
    }];
    [operation start];
}

#pragma mark - My MyTeamDetails API
- (void)getMyTeamDetailsAPI:(NSString*)extensionName :(NSDictionary *)queryDictionary andSucessAction:(void (^)(AFRKHTTPRequestOperation *op, id responseObject))sucessBlock andFailuerAction:(void (^)(AFRKHTTPRequestOperation *operation, NSError *error))failuerBlock
{
//    BOOL showLoader = true;
//    [UtilityMethods showProgressHUD:showLoader];

    AFRKHTTPClient *httpClient = [AFRKHTTPClient clientWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BaseURL,extensionName]]]; //This can be re-used within a class property
    httpClient.parameterEncoding = AFRKJSONParameterEncoding;

    AAATokenMO *tokenObject = [[AppRepo sharedRepo] getTokenDetails];
    if (tokenObject) {
        NSString *value = [NSString stringWithFormat:@"%@ %@", tokenObject.tokenType, tokenObject.accessToken];
        [httpClient setDefaultHeader:@"Authorization" value:value];
    }
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:[NSString stringWithFormat:@"%@%@",BaseURL,extensionName] parameters:queryDictionary];
    
    AFRKJSONRequestOperation *operation = [AFRKJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
//        [UtilityMethods hideProgressHUD];
        NSLog(@"%@", JSON);
        sucessBlock(nil,JSON);
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"Request Failed with Error: %@, %@", error, error.userInfo);
//        [UtilityMethods hideProgressHUD];
        if (response.statusCode == 401) { // access token expired
            
            PostHelper *postHelper = [[PostHelper alloc] init];
            postHelper.path = extensionName;
            postHelper.parameters = queryDictionary;
            postHelper.afSuccessBlock = sucessBlock;
            postHelper.afFailureBlock = failuerBlock;
            postHelper.postRequestType = PostRequestTypeUnMapped;
            
            [[AccessTokenManager sharedManager] renewAccessToken:postHelper];
        }
        else if (response.statusCode == 412){
            [UtilityMethods convertJSONStringToDictionary:error.localizedRecoverySuggestion success:^(NSDictionary * _Nullable jsonDictionary) {
                [UtilityMethods showToastWithMessage:[jsonDictionary objectForKey:@"msg"]];
                failuerBlock(nil,error);
            } failure:^(NSError * _Nullable error) {
                failuerBlock(nil,error);
            }];
        }
        else if (response.statusCode == 0){
            // failure(operation, error);
            [UtilityMethods convertJSONStringToDictionary:error.localizedRecoverySuggestion success:^(NSDictionary * _Nullable jsonDictionary) {
                [UtilityMethods showToastWithMessage:[jsonDictionary objectForKey:@"msg"]];
                failuerBlock(nil,error);
            } failure:^(NSError * _Nullable mError) {
                failuerBlock(nil,error);
            }];
        }
        else if (response.statusCode == 500){
            [UtilityMethods showToastWithMessage:[error localizedDescription]];
            failuerBlock(nil,error);
        }
        else {
            [UtilityMethods hideProgressHUD];
            failuerBlock(nil,error);
        }
    }];
    [operation start];
}

/*
#pragma mark - My MyTeamDetails API
- (void)getMyTeamDetailsAPI:(NSString*)extensionName :(NSDictionary *)queryDictionary andSucessAction:(void (^)(AFRKHTTPRequestOperation *op, id responseObject))sucessBlock andFailuerAction:(void (^)(AFRKHTTPRequestOperation *operation, NSError *error))failuerBlock
{
    [self postPath:extensionName
        parameters:queryDictionary
        showLoader:true
showDefaultErrorMessage:false
           success:^(AFRKHTTPRequestOperation *operation, id responseObject) {
               NSError *jsonError;
               id JSON = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&jsonError];
               
               if(jsonError) {
                   failuerBlock(nil,jsonError);
                   NSLog(@"json error : %@", [jsonError localizedDescription]);
               } else {
                   // use the jsonDictionaryOrArray
                   if (sucessBlock) {
                       sucessBlock(nil,JSON);
                   }
               }
           } failure:^(AFRKHTTPRequestOperation *operation, NSError *error) {
               if (failuerBlock) {
                   failuerBlock(nil,error);
               }
               
           }];
}
*/

- (void)createGTMEActivity:(NSDictionary *)queryDictionary withLoadingView:(BOOL)shouldShowLoadingView andSucessAction:(void (^)(id activity))sucessBlock andFailuerAction:(void (^)(NSError *error))failuerBlock
{
    [self postPath:GTMECREATEACTIVITYURL parameters:queryDictionary showLoader:shouldShowLoadingView showDefaultErrorMessage:shouldShowLoadingView success:^(AFRKHTTPRequestOperation *operation, id responseObject) {
        NSError *jsonError;
        
        id jsonDictionaryOrArray = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&jsonError];
        if(jsonError) {
            // check the error description
            failuerBlock(jsonError);
            NSLog(@"json error : %@", [jsonError localizedDescription]);
        } else {
            // use the jsonDictionaryOrArray
            NSLog(@"SUCCC");
            if (sucessBlock) {
                sucessBlock(jsonDictionaryOrArray);
            }
        }
    } failure:^(AFRKHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"FAILED");
        if (failuerBlock) {
            failuerBlock(error);
        }
    }];
}

- (void)updateGTMEActivity:(NSDictionary *)queryDictionary withLoadingView:(BOOL)shouldShowLoadingView andSucessAction:(void (^)(id activity))sucessBlock andFailuerAction:(void (^)(NSError *error))failuerBlock
{
    [self postPath:GTMEUPDATEACTIVITYURL parameters:queryDictionary showLoader:shouldShowLoadingView showDefaultErrorMessage:shouldShowLoadingView success:^(AFRKHTTPRequestOperation *operation, id responseObject) {
        NSError *jsonError;
        
        id jsonDictionaryOrArray = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&jsonError];
        if(jsonError) {
            // check the error description
            failuerBlock(jsonError);
            NSLog(@"json error : %@", [jsonError localizedDescription]);
        } else {
            // use the jsonDictionaryOrArray
            NSLog(@"SUCCC");
            if (sucessBlock) {
                sucessBlock(jsonDictionaryOrArray);
            }
        }
    } failure:^(AFRKHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"FAILED");
        if (failuerBlock) {
            failuerBlock(error);
        }
    }];
}

- (void)searchGTMEActivity:(NSDictionary *)queryDictionary andSucessAction:(void (^)(EGPagination *paginationObj))sucessBlock andFailuerAction:(void (^)(NSError *error))failuerBlock
{
    [self postObject:[[EGPagination alloc]init]
                path:SEARCHGTMEACTIVITYURL
          parameters:queryDictionary
          showLoader:NO
showDefaultErrorMessage:YES
             success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                 if (sucessBlock) {
                     sucessBlock([mappingResult firstObject]);
                 }
                 NSLog(@"%@", [mappingResult description]);
             }
             failure:^(RKObjectRequestOperation *operation, NSError *error) {
                 if (failuerBlock) {
                     failuerBlock(error);
                 }
             }];
}
@end
