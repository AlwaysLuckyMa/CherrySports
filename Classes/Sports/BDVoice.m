//
//  BDVoice.m
//  CherrySports
//
//  Created by 嘟嘟 on 2017/9/26.
//  Copyright © 2017年 dkb. All rights reserved.
//

#import "BDVoice.h"

@implementation BDVoice

+ (void)BDVoiceStar:(id)viewcontroller BDSpeakStr:(NSString *)speakStr
{
    NSString * AppID     = @"10188209";
    NSString * APIKey    = @"jGN6gc7Ggky6otk7WSSoXbLl";
    NSString * SecretKey = @"8f6eb7d110f4c58bb35f72d53fc4161a";
    [[BDSSpeechSynthesizer sharedInstance] setApiKey:APIKey withSecretKey:SecretKey];//设置apiKey和secretKey
    [[BDSSpeechSynthesizer sharedInstance] setSynthParam:[NSNumber numberWithInt:BDS_SYNTHESIZER_SPEAKER_FEMALE] forKey:BDS_SYNTHESIZER_PARAM_SPEAKER];//女声
    [[BDSSpeechSynthesizer sharedInstance] setSynthParam:[NSNumber numberWithInt:9] forKey:BDS_SYNTHESIZER_PARAM_VOLUME];//音量 0 ~9
    [[BDSSpeechSynthesizer sharedInstance] setSynthParam:[NSNumber numberWithInt:6] forKey:BDS_SYNTHESIZER_PARAM_SPEED]; //语速 0 ~9
    [[BDSSpeechSynthesizer sharedInstance] setSynthParam:[NSNumber numberWithInt:5] forKey:BDS_SYNTHESIZER_PARAM_PITCH]; //语调 0 ~9
    [[BDSSpeechSynthesizer sharedInstance] setSynthParam:[NSNumber numberWithInt: BDS_SYNTHESIZER_AUDIO_ENCODE_MP3_16K] forKey:BDS_SYNTHESIZER_PARAM_AUDIO_ENCODING];//mp3音质 压缩的16K
    NSString * offlineChineseSpeechData        = [[NSBundle mainBundle] pathForResource:@"Chinese_Speech_Female"      ofType:@"dat"];
    NSString * offlineChineseTextData          = [[NSBundle mainBundle] pathForResource:@"Chinese_Text"               ofType:@"dat"];
    NSString * offlineChineseLicenseFile       = [[NSBundle mainBundle] pathForResource:@"offline_engine_tmp_license" ofType:@"dat"];
    NSString * offlineEngineEnglishSpeechData  = [[NSBundle mainBundle] pathForResource:@"English_Speech_Female"      ofType:@"dat"];
    NSString * offlineEngineEnglishTextData    = [[NSBundle mainBundle] pathForResource:@"English_Text"               ofType:@"dat"];
    NSError  * err = [[BDSSpeechSynthesizer sharedInstance] loadOfflineEngine:offlineChineseTextData speechDataPath:offlineChineseSpeechData licenseFilePath:offlineChineseLicenseFile withAppCode:AppID];
    if(err){NSlog(@"汉语离线--错误--%@",err);return;}
    err = [[BDSSpeechSynthesizer sharedInstance] loadEnglishDataForOfflineEngine:offlineEngineEnglishTextData speechData:offlineEngineEnglishSpeechData];
    if(err){NSlog(@"英语离线--错误--%@",err);return;}
    [[BDSSpeechSynthesizer sharedInstance] setSynthesizerDelegate:viewcontroller]; // 获得合成器实例
    [[BDSSpeechSynthesizer sharedInstance] setSynthesizerDelegate:viewcontroller]; // 设置委托对象
    NSError * speakError = nil; // 开始合成并播放
    if([[BDSSpeechSynthesizer sharedInstance] speakSentence:speakStr withError:&speakError] == -1)
    {NSlog(@"错误: %ld, %@", (long)speakError.code, speakError.localizedDescription);}
}

- (void)synthesizerStartWorkingSentence:(NSInteger)SynthesizeSentence
{NSlog(@"开始合成的句子 %zi", SynthesizeSentence);}

- (void)synthesizerFinishWorkingSentence:(NSInteger)SynthesizeSentence
{NSlog(@"完成合成的句子 %zi", SynthesizeSentence);}

- (void)synthesizerSpeechStartSentence:(NSInteger)SpeakSentence
{NSlog(@"开始播放语音 %zi", SpeakSentence);}

- (void)synthesizerSpeechEndSentence:(NSInteger)SpeakSentence
{NSlog(@"结束播放语音 %zi", SpeakSentence);}

@end
