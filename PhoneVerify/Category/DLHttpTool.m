//
//  DLHttpTool.m
//  RecordLocation
//
//  Created by dev on 16/3/3.
//  Copyright © 2016年 donglian@eastunion.net. All rights reserved.
//

#import "DLHttpTool.h"
#import <AFNetworking.h>
@implementation DLHttpTool

+ (void)postWithURL:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    // 1.创建请求管理对象
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    // 2.发送请求
    [mgr POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];

}

+ (void)postWithURL:(NSString *)url params:(NSDictionary *)params formDataArray:(NSArray *)formDataArray success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    // 1.创建请求管理对象
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    // 2.发送请求
    [mgr POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (DLFormData *_formData in formDataArray) {
            [formData appendPartWithFileData:_formData.data name:_formData.name fileName:_formData.filename mimeType:_formData.mimeType];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)getWithURL:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    // 1.创建请求管理对象
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json", @"text/json", nil];
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    // 2.发送请求
    [mgr GET:url parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

@end

/**
 *  用来封装文件数据的模型
 */
@implementation DLFormData

@end