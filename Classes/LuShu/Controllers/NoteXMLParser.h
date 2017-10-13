//
//  NoteXMLParser.h
//  路书Demo
//
//  Created by 嘟嘟 on 2017/7/31.
//  Copyright © 2017年 MC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NoteXMLParser : NSObject  <NSXMLParserDelegate>

//解析出的数据，内部是字典类型
@property (strong,nonatomic) NSMutableArray * notes ;

//当前标签的名字 ,currentTagName 用于存储正在解析的元素名
@property (strong ,nonatomic) NSString * currentTagName ;

//gpx文件名
@property (strong ,nonatomic) NSString * gpxFileName ;

//开始解析
- (void)start;


@end
