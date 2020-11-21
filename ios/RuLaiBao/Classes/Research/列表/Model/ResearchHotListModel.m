//
//  ResearchHotListModel.m
//  RuLaiBao
//
//  Created by qiu on 2018/4/26.
//  Copyright © 2018年 QiuFairy. All rights reserved.
//

#import "ResearchHotListModel.h"
#import "Configure.h"

@implementation ResearchHotListModel
-(instancetype)initHotListModelWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.questionId       = dic[@"questionId"];
        self.title       = dic[@"title"];
        self.descript       = dic[@"descript"];
        self.userName       = dic[@"userName"];
        self.answerCount       = dic[@"answerCount"];
        
        UIFont *font = [UIFont systemFontOfSize:18.0];
        CGFloat lineSpacing = 5;
        CGSize size = CGSizeMake(Width_Window-20, MAXFLOAT);
        
        NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:self.descript];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = lineSpacing;
        [attributeString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, self.descript.length)];
        [attributeString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, self.descript.length)];
        NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin;
        CGRect rect = [attributeString boundingRectWithSize:size options:options context:nil];
        
        CGFloat textHeight = rect.size.height;
        if(textHeight - font.lineHeight * 3 >= lineSpacing *3){
            //大于三行
            textHeight = font.lineHeight * 3 + lineSpacing *3;
        }
        self.itemSize = CGSizeMake(Width_Window, textHeight + 100);
        self.mutablAttrStr = attributeString;
    }
    return self;
}

@end
