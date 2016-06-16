//
//  DeathByCaptcha-ObjC.m
//  
//
//  Created by Majd Alfhaily on 6/16/16.
//
//

#import "DeathByCaptcha-ObjC.h"
#import <STHTTPRequest/STHTTPRequest.h>

@implementation DeathByCaptcha

+ (instancetype)sharedInstance {
    static DeathByCaptcha *__sharedInstance;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        __sharedInstance = [[self alloc] init];
    });
    
    return __sharedInstance;
}

- (id)init {
    self = [super init];
    
    if (self) {
        self.timeout = 10;
    }
    
    return self;
}

#pragma mark - Private

+ (STHTTPRequest *)DBCGETRequestWithURL:(NSURL *)url {
    STHTTPRequest *request = [STHTTPRequest requestWithURL:url];
    [request setHeaderWithName:@"Accept" value:@"application/json"];
    [request setHTTPMethod:@"GET"];
    [request setTimeoutSeconds:[DeathByCaptcha sharedInstance].timeout];
    [request setIgnoreCache:YES];
    return request;
}

+ (STHTTPRequest *)DBCPOSTRequestWithURL:(NSURL *)url {
    if (([DeathByCaptcha sharedInstance].username && [DeathByCaptcha sharedInstance].password)) {
        STHTTPRequest *request = [STHTTPRequest requestWithURL:url];
        [request setHeaderWithName:@"Accept" value:@"application/json"];
        [request setHTTPMethod:@"POST"];
        [request setTimeoutSeconds:[DeathByCaptcha sharedInstance].timeout];
        [request setIgnoreCache:YES];
        return request;
    }
    
    NSLog(@"[DeathByCaptcha] Both a username and password must be defined in the shared instance!");
    return nil;
}

+ (NSDictionary *)responseFromRequest:(STHTTPRequest *)request {
    [request startSynchronousWithError:nil];
    if (request.responseData) {
        return [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingAllowFragments error:nil];
    }
    
    return nil;
}

#pragma mark - Public

+ (NSDictionary *)solveCaptchaFromFileAtPath:(NSString *)path checkInterval:(NSTimeInterval)checkInterval {
    if (checkInterval < 5) {
        checkInterval = 5;
    }
    
    NSDictionary *uploadResponse = [DeathByCaptcha uploadCaptchaFromFileAtPath:path];
    
    if (uploadResponse) {
        if ([[uploadResponse allKeys] containsObject:@"captcha"] && [[uploadResponse allKeys] containsObject:@"text"]) {
            if ([uploadResponse[@"text"] isEqualToString:@""] ||
                [uploadResponse[@"text"] isEqual:[NSNull null]]) {
                for (int i = 0; i < 5; i++) {
                    NSDictionary *pollResponse = [DeathByCaptcha pollStatusForCaptchaWithID:uploadResponse[@"captcha"]];
                    if ([[pollResponse allKeys] containsObject:@"text"] &&
                        ![pollResponse[@"text"] isEqualToString:@""] &&
                        ![pollResponse[@"text"] isEqual:[NSNull null]]) {
                        return pollResponse;
                    }
                    sleep(checkInterval);
                }
                
                return @{@"error": @"still_not_solved"};
            } else {
                return uploadResponse;
            }
        } else {
            return @{@"error": @"unknown_response"};
        }
    }
    
    return nil;
}

+ (NSDictionary *)uploadCaptchaFromFileAtPath:(NSString *)path {
    STHTTPRequest *request = [DeathByCaptcha DBCPOSTRequestWithURL:[NSURL URLWithString:@"http://api.dbcapi.me/api/captcha"]];
    
    if (request) {
        if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
            if ([[[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil] fileSize] < 180000) {
                NSString *extension = [[path pathExtension] lowercaseString];
                if ([extension isEqualToString:@"jpg"] ||
                    [extension isEqualToString:@"png"] ||
                    [extension isEqualToString:@"gif"] ||
                    [extension isEqualToString:@"bmp"]) {
                    [request setPOSTDictionary:@{@"username": [DeathByCaptcha sharedInstance].username,
                                                 @"password": [DeathByCaptcha sharedInstance].password}];
                    [request addFileToUpload:path parameterName:@"captchafile"];
                    return [DeathByCaptcha responseFromRequest:request];
                } else {
                    return @{@"error": @"unsupported_file_format"};
                }
            } else {
                return @{@"error": @"file_too_big"};
            }
        } else {
            return @{@"error": @"file_does_not_exist"};
        }
    }
    
    return nil;
}

+ (NSDictionary *)pollStatusForCaptchaWithID:(NSString *)captchaId {
    STHTTPRequest *request = [DeathByCaptcha DBCGETRequestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://api.dbcapi.me/api/captcha/%@", captchaId]]];
    
    if (request) {
        return [DeathByCaptcha responseFromRequest:request];
    }
    
    return nil;
}

+ (NSDictionary *)reportIncorrectlySolvedCaptchaWithID:(NSString *)captchaId {
    STHTTPRequest *request = [DeathByCaptcha DBCPOSTRequestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://api.dbcapi.me/api/captcha/%@/report", captchaId]]];
    
    if (request) {
        [request setPOSTDictionary:@{@"username": [DeathByCaptcha sharedInstance].username,
                                     @"password": [DeathByCaptcha sharedInstance].password}];
        return [DeathByCaptcha responseFromRequest:request];
    }
    
    return nil;
}

+ (NSDictionary *)accountCreditBalance {
    STHTTPRequest *request = [DeathByCaptcha DBCPOSTRequestWithURL:[NSURL URLWithString:@"http://api.dbcapi.me/api/user"]];
    
    if (request) {
        [request setPOSTDictionary:@{@"username": [DeathByCaptcha sharedInstance].username,
                                     @"password": [DeathByCaptcha sharedInstance].password}];
        return [DeathByCaptcha responseFromRequest:request];
    }
    
    return nil;
}

+ (NSDictionary *)currentServerStatus {
    STHTTPRequest *request = [DeathByCaptcha DBCGETRequestWithURL:[NSURL URLWithString:@"http://api.dbcapi.me/api/status"]];
    
    if (request) {
        return [DeathByCaptcha responseFromRequest:request];
    }
    
    return nil;
}

@end
