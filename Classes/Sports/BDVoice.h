//
//  BDVoice.h
//  CherrySports
//
//  Created by 嘟嘟 on 2017/9/26.
//  Copyright © 2017年 dkb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BDVoice : NSObject<BDSSpeechSynthesizerDelegate>

//百度语音合成
+ (void)BDVoiceStar:(id)viewcontroller BDSpeakStr:(NSString *)speakStr;

@end
