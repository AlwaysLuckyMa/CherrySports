//
//  NoteXMLParser.m
//  路书Demo
//
//  Created by 嘟嘟 on 2017/7/31.
//  Copyright © 2017年 MC. All rights reserved.
//

#import "NoteXMLParser.h"

@implementation NoteXMLParser

// 开始解析
- (void)start
{
//    NSString * path = [[NSBundle mainBundle] pathForResource:@"GPX-1505803722659" ofType:@"gpx"];
//    NSURL    * url  = [NSURL fileURLWithPath:path];
    NSArray     * paths    = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES);
    NSString    * filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:self.gpxFileName ];// 保存文件
    NSURL       * url      = [NSURL fileURLWithPath:filePath];
    NSXMLParser * parser   = [[NSXMLParser alloc] initWithContentsOfURL:url];//开始解析 xml
    parser.delegate        = self ;
    [parser parse];
    NSlog(@"解析完毕");
}

//文档开始时触发 ,开始解析时 只触发一次
- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    _notes = [NSMutableArray new];
}

// 文档出错时触发
- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    NSlog(@"%@",parseError);
}

//遇到一个开始标签触发
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    _currentTagName  = elementName; //把elementName 赋值给 成员变量 currentTagName
    
    //如果名字 是trkpt就取出 lat and lon
    if ([_currentTagName isEqualToString:@"trkpt"])
    {
        NSlog(@"attributeDict------%@",attributeDict);
        NSString * _lat             = [attributeDict objectForKey:@"lat"];
        NSString * _long            = [attributeDict objectForKey:@"lon"];
        NSString * XML_Location_Str = [NSString stringWithFormat:@"%@,%@", _lat, _long ];
        NSMutableDictionary * dict  = [[NSMutableDictionary alloc]init];    // 实例化一个可变的字典对象,用于存放
        [dict setObject:XML_Location_Str forKey:@"Location_XML"]; //把id 放入字典中
        [_notes addObject:dict];                                  // 把可变字典 放入到 可变数组集合_notes 变量中
    }
}

#pragma mark 该方法主要是解析元素文本的主要场所，由于换行符和回车符等特殊字符也会触发该方法，因此要判断并剔除换行符和回车符
// 遇到字符串时 触发
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    //替换回车符 和空格,其中 stringByTrimmingCharactersInSet 是剔除字符的方法,[NSCharacterSet whitespaceAndNewlineCharacterSet]指定字符集为换行符和回车符;
    string  = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([string isEqualToString:@""])
    {
        return;
    }
    
    NSMutableDictionary * dict = [_notes lastObject];
    if ([_currentTagName isEqualToString:@"ele"] && dict)
    {
        [dict setObject:string forKey:@"ele"];
    }
    
    if ([_currentTagName isEqualToString:@"time"] && dict)
    {
        [dict setObject:string forKey:@"time"];
    }
}

//遇到结束标签触发
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    self.currentTagName = nil ;
    //该方法主要是用来 清理刚刚解析完成的元素产生的影响，以便于不影响接下来解析
}

// 遇到文档结束时触发
-(void)parserDidEndDocument:(NSXMLParser *)parser{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reload_GPX" object:self.notes userInfo:nil];
    //进入该方法就意味着解析完成，需要清理一些成员变量，同时要将数据返回给表示层（表示图控制器） 通过广播机制将数据通过广播通知投送到 表示层
    self.notes = nil;
}

@end
