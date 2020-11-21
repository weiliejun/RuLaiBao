//
//  InfoDataModel.m
//  RuLaiBao
//
//  Created by qiu on 2018/4/8.
//  Copyright © 2018年 QiuFairy. All rights reserved.
//

#import "InfoDataModel.h"
#import "Configure.h"
#import "NSString+Custom.h"
#import "TYAttributedLabel.h"
#import "ReplyModel.h"

@interface InfoDataModel ()

@end

@implementation InfoDataModel

-(instancetype)initWithDic:(NSDictionary *)dic SpeechmanId:(NSString *)speechmanId{
    self = [super init];
    if (self) {
        self.commentId       = dic[@"commentId"];
        self.commentName     = dic[@"commentName"];
        self.commentPhoto    = dic[@"commentPhoto"];
        
        self.cid             = dic[@"cid"];
        self.commentContent  = dic[@"commentContent"];
        self.commentTime     = dic[@"commentTime"];
        self.replys =[self processReplyArr:dic[@"replys"]];
        
        self.textContainers =[self addReplyToTableViewItemS:self.replys];
        
        if ([speechmanId isEqualToString:[StoreTool getUserID]]) {
            if (self.replys.count != 0 ) {
                self.btnHidden = @"true";
            }else{
                self.btnHidden = @"false";
            }
        }else{
            self.btnHidden = @"true";
        }
        
        /** 处理数据 */
        NSMutableParagraphStyle *muStyle = [[NSMutableParagraphStyle alloc]init];
        UIFont *font = [UIFont systemFontOfSize:18.0];
        muStyle.alignment = NSTextAlignmentLeft;//对齐方式
        muStyle.lineSpacing = 3.0;
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:self.commentContent];
        [attrString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, attrString.length)];
        [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor customTitleColor] range:NSMakeRange(0, attrString.length)];
        [attrString addAttribute:NSParagraphStyleAttributeName value:muStyle range:NSMakeRange(0, attrString.length)];
        NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin;
        CGFloat sizeHeight= [attrString boundingRectWithSize:CGSizeMake(Width_Window- 2*10, CGFLOAT_MAX) options:options context:nil].size.height;
        
        if (sizeHeight > font.lineHeight) {//margin
            muStyle.lineSpacing = 3.0;//设置行间距离
        }else{
            muStyle.lineSpacing = CGFLOAT_MIN;//设置行间距离
        }
        
        self.mutablAttrStr = attrString;
        
        //算text的layout
        CGFloat textHeight = sizeHeight+0.5;
        
        self.frameLayout = CGRectMake(10, 8+40+8, Width_Window-20, textHeight);
        
        if ([self.btnHidden isEqualToString:@"true"]) {
             self.headerHeight = self.frameLayout.origin.y+self.frameLayout.size.height +8;
        }else{
             self.headerHeight = self.frameLayout.origin.y+self.frameLayout.size.height +5+30+8;
        }
    }
    return self;
}
-(NSArray *)processReplyArr:(NSArray *)arr{
     NSMutableArray *tmp1 = [NSMutableArray array];
    for (NSDictionary *dict1 in arr) {
        ReplyModel *infoModel = [[ReplyModel alloc]initReplyModelWithDic:dict1];
        [tmp1 addObject:infoModel];
    }
    return [tmp1 copy];
}

- (NSArray *)addReplyToTableViewItemS:(NSArray *)replyArr{
    NSMutableArray *tmp = [NSMutableArray array];
    
    for (NSInteger i = 0; i < replyArr.count; ++i) {
        [tmp addObject:[self creatTextContainer:replyArr[i]]];
    }
    return [tmp copy];
}

- (TYTextContainer *)creatTextContainer:(ReplyModel *)model{
    NSString *replyNameStr = [NSString stringWithFormat:@"%@",model.replyName];
    NSString *text = [NSString stringWithFormat:@"%@回复：%@",replyNameStr,model.replyContent];
    // 属性文本生成器
    TYTextContainer *textContainer = [[TYTextContainer alloc]init];
    textContainer.text = text;
    textContainer.font = [UIFont systemFontOfSize:16.0];
    textContainer.textColor = [UIColor customTitleColor];
    textContainer.linesSpacing = 2;
//    NSString *linkDtaStr = [NSString stringWithFormat:@"点击了%@",replyNameStr];
//    [textContainer addLinkWithLinkData:linkDtaStr linkColor:nil underLineStyle:kCTUnderlineStyleNone range:[text rangeOfString:replyNameStr]];
    textContainer = [textContainer createTextContainerWithTextWidth:Width_Window-30];
    return textContainer;
}
@end
