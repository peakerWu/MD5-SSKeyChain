//
//  ViewController.m
//  PhoneVerify
//
//  Created by dev on 16/4/15.
//  Copyright © 2016年 donglian@eastunion.net. All rights reserved.
//

#import "ViewController.h"
#import <SSKeychain.h>
#import <CommonCrypto/CommonDigest.h>

NSString *const serviceName = @"net.eastunion";
//NSString *const account = @"你好";
#define AccountKey @"account"
//#define password @"net.eastunion"


@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *accountTextfield;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextfield;
- (IBAction)login;
- (IBAction)delete;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 取出所有用户
    NSArray *allAcounts = [SSKeychain allAccounts];
    
    // 从沙河中取出上次存储的账户信息
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString * getAccount =[defaults objectForKey:AccountKey];
    
    // 判断是否存在账户信息，如果有直接
    for (NSDictionary *dict in allAcounts) {
        NSString *account = dict[@"acct"];
        
        if ([account isEqualToString:getAccount]) {
            
            self.accountTextfield.text = account;
            
            NSString *password = [SSKeychain passwordForService:serviceName account:account];
            
            self.passwordTextfield.text = password;
        }
    }
    
    NSLog(@"%@", allAcounts);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)login {
    
    NSString *account = self.accountTextfield.text;
    NSString *password = self.passwordTextfield.text;
    
    if (![account isEqualToString:@""] && ![password isEqualToString:@""] ) {
        [SSKeychain setPassword:password forService:serviceName account:account];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:account forKey:AccountKey];
        [defaults synchronize];
    }
    
}

- (IBAction)delete {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *getAccount = [defaults objectForKey:AccountKey];
    // 删除密码
    [SSKeychain deletePasswordForService:serviceName account:getAccount];
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

//- (NSString *)md5:(NSString *)str{
//    // 转化成utf-8
//    const char *cStr=[str UTF8String];
//    // 开辟一个16字节(128位:MD5加密出来就是128位/bit(字节)，1字节=8位)的空间
//    unsigned char result[16];
//    // 加密存储到result中，将cStr字符串转换成了32位，一般来说，此过程不可逆，即只能加密，不能解密
//    CC_MD5(cStr, strlen(cStr), result);
//    // 其中%02x是格式控制符：‘x’表示以16进制输出，‘02’表示不足两位，前面补0
//    return [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
//            result[0], result[1], result[2], result[3],
//            result[4], result[5], result[6], result[7],
//            result[8], result[9], result[10], result[11],
//            result[12], result[13], result[14], result[15]];
//}

// md5加密另一种写法：利用for循环输出
- (NSString *)md5:(NSString *)str{
    // 转化成utf-8
    const char *cStr=[str UTF8String];
    // 开辟一个16字节(128位:MD5加密出来就是128位/bit(字节)，1字节=8位)的空间
    unsigned char result[16];
    // 加密存储到result中，将cStr字符串转换成了32位
    CC_MD5(cStr, strlen(cStr), result);
    // 其中%02x是格式控制符：‘x’表示以16进制输出，‘02’表示不足两位，前面补0
    NSMutableString *mStr=[NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH];
    for (int i=0; i<CC_MD5_DIGEST_LENGTH; i++) {
        [mStr appendFormat:@"%02X",result[i]];
    }
    return mStr;
}

// sha1加密
- (NSString *)sha1:(NSString *)str{
    const char *cStr=[str cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data=[NSData dataWithBytes:cStr length:str.length];
    
    uint8_t disgest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, data.length, disgest);
    
    NSMutableString *output=[NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH*2];
    
    for (int i=0; i<CC_SHA1_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x",disgest[i]];
    }
    
    return output;
}


@end
