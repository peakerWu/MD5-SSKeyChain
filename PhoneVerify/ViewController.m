//
//  ViewController.m
//  PhoneVerify
//
//  Created by dev on 16/4/15.
//  Copyright © 2016年 donglian@eastunion.net. All rights reserved.
//

#import "ViewController.h"
#import <SSKeychain.h>

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

@end
