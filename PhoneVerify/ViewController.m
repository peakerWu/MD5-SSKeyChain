//
//  ViewController.m
//  PhoneVerify
//
//  Created by dev on 16/4/15.
//  Copyright © 2016年 donglian@eastunion.net. All rights reserved.
//

#import "ViewController.h"
#import <SSKeychain.h>
#import "MBProgressHUD+MJ.h"
#import "NSString+Hash.h"
#import "DLHttpTool.h"

/** 存入钥匙串的服务信息 */
NSString * const serviceName = @"net.eastunion";

#define AccountKey @"account"


@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *accountTextfield;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextfield;
- (IBAction)login;
- (IBAction)delete;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.passwordTextfield.secureTextEntry = YES;
    
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
            // 判断密码是否存在，如果存在直接显示
            NSString *password = [SSKeychain passwordForService:serviceName account:account];
            
            self.passwordTextfield.text = password;
        }
    }
    
//    NSLog(@"%@", allAcounts);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)login {
    
    NSString *account = self.accountTextfield.text;
    NSString *password = self.passwordTextfield.text;
    // 1.判断账户密码 是否为空
    if (account.length == 0) {
        [MBProgressHUD showError:@"请输入用户名"];
        return;
    }
    if (password.length == 0) {
        [MBProgressHUD showError:@"请输入密码"];
        return;
    }
    // 2.存入钥匙串
    [SSKeychain setPassword:password forService:serviceName account:account];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:account forKey:AccountKey];
    [defaults synchronize];
    
    // 3.发送数据到服务器
//    NSString *url = @"";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"account"] = account;
    // md5加密,也可以哈希加密
    params[@"password"] = [[password stringByAppendingString:@"abcde"] md5String];
    
    NSString *md5 = [password md5String];
    NSString *md5Salt = [[password stringByAppendingString:@"abcde"] md5String];
    NSString *twoMd5 = [md5Salt md5String];
    
    NSLog(@"%@", md5);
    NSLog(@"%@", md5Salt);
    NSLog(@"%@", twoMd5);
    
    NSString *sha1 = [password sha1String];
    NSLog(@"sha1--%@", sha1);
    NSString *sha256 = [password sha256String];
    NSLog(@"sha256--%@", sha256);
    NSString *sha512 = [password sha512String];
    NSLog(@"sha512--%@", sha512);
    
//    [DLHttpTool postWithURL:url params:params success:^(id json) {
//        
//        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingMutableLeaves error:nil];
//        NSLog(@"%@", dict);
//        
//        
//    } failure:^(NSError *error) {
//        
//    }];
    
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


@end
