//
//  AFNet.h
//
//
//  Created by zhb on 15-1-9.
//  Copyright (c) 2015年 zhb. All rights reserved.


#import <Foundation/Foundation.h>
#import "UIImageView+AFNetworking.h"

@interface AFNet : NSObject

/**
 *  发送一个POST请求
 *

 */
+ (void)postWithURL:(NSString *)url params:(NSDictionary *)params success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;

/**
 *  发送一个POST请求(上传文件数据)
 *

 */
+ (void)postWithURL:(NSString *)url params:(NSDictionary *)params formDataArray:(NSArray *)formDataArray success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;

/**
 *  发送一个GET请求
 *
 */
+ (void)getWithURL:(NSString *)url params:(NSDictionary *)params success:(void (^)(id JSON))success failure:(void (^)(NSError *error))failure;

+ (void)getJsonWithURL:(NSString *)urlStr success:(void (^)(id JSON))success failure:(void (^)(NSError *error))failure;

+ (NSString*)getJsonWithURL:(NSString*)urlStr;

@end


/**
 *  用来封装文件数据的模型
 */
@interface FormData : NSObject
/**
 *  文件数据
 */
@property (nonatomic, strong) NSData *data;

/**
 *  参数名
 */
@property (nonatomic, copy) NSString *name;

/**
 *  文件名
 */
@property (nonatomic, copy) NSString *filename;

/**
 *  文件类型
 */
@property (nonatomic, copy) NSString *mimeType;
@end

