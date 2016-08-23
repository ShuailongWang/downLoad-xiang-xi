//
//  FileDownload.h
//  断点续传
//
//  Created by czbk on 16/7/15.
//  Copyright © 2016年 王帅龙. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileDownload : NSObject

-(void)downloadFileWithUrl:(NSString *)path sucessBlock:(void(^)(NSString *loacPath))sucessBlock failBlock:(void(^)(NSError *error))failBlock progressBlock:(void(^)(float progress))progressBlock;

-(void)downFileWithPath:(NSString*)path;

-(void)pauseDownload;
@end
