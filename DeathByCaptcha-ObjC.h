//
//  DeathByCaptcha-ObjC.h
//  
//
//  Created by Majd Alfhaily on 6/16/16.
//
//

#import <Foundation/Foundation.h>

@interface DeathByCaptcha : NSObject
@property (retain, nonatomic) NSString *username;
@property (retain, nonatomic) NSString *password;
@property (nonatomic) NSTimeInterval timeout;

+ (instancetype)sharedInstance;

/**
 *  Uploads and solves the captcha by DeathByCaptcha then return the text in a dictionary.
 *
 *  @param path          Path to image file. Extension could be png, jpg, gif or bmp.
 *  @param checkInterval How often should the captcha be check if it was solved. Should be 5 or more, default is 5.
 *
 *  @return A dictionary with the following keys: captcha, is_correct, status, text.
 */
+ (NSDictionary *)solveCaptchaFromFileAtPath:(NSString *)path
                               checkInterval:(NSTimeInterval)checkInterval;

/**
 *  Uploads the captcha to be solved by DeathByCaptcha. 'text' key in resposne is normally empty, you should use the pollStatusForCaptchaWithID: to get the captcha answer.
 *
 *  @param path Path to image file. Extension could be png, jpg, gif or bmp.
 *
 *  @return A dictionary with the following keys: captcha, is_correct, status, text (mostly empty).
 */
+ (NSDictionary *)uploadCaptchaFromFileAtPath:(NSString *)path;

/**
 *  Polls DeathByCaptcha to check the answer of the specified captcha id.
 *
 *  @param captchaId Identifier of captcha returned using uploadCaptchaFromFileAtPath:
 *
 *  @return A dictionary with the following keys: captcha, is_correct, status, text.
 */
+ (NSDictionary *)pollStatusForCaptchaWithID:(NSString *)captchaId;

/**
 *  Reports incorrectly solved captcha and get refunded if the captcha was uploaded less than an hour ago.
 *
 *  @param captchaId Identifier of captcha returned using uploadCaptchaFromFileAtPath:
 *
 *  @return A dictionary with the following keys: captcha, is_correct, status, text.
 */
+ (NSDictionary *)reportIncorrectlySolvedCaptchaWithID:(NSString *)captchaId;

/**
 *  Get the credit balance of current account.
 *
 *  @return A dictionary with the following keys: balance, is_banned, rate, status, user.
 */
+ (NSDictionary *)accountCreditBalance;

/**
 *  Get the current status of DeathByCaptcha service.
 *
 *  @return A dictionary with the following keys: is_service_overloaded, solved_in, status, todays_accuracy.
 */
+ (NSDictionary *)currentServerStatus;

@end