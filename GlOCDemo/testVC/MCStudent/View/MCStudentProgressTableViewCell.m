//
//  MCStudentProgressTableViewCell.m
//  GlOCDemo
//
//  Created by 小柠檬 on 2018/11/1.
//  Copyright © 2018年 小柠檬. All rights reserved.
//

#import "MCStudentProgressTableViewCell.h"
#import "Masonry.h"

@implementation MCStudentProgressTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createBaseView];
    }
    return self;
}

- (void)createBaseView {
    UIImageView *headImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:headImageView];
    [headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.contentView).offset(15);
        make.top.equalTo(self.contentView).offset(15);
        make.width.height.mas_equalTo(49);
    }];
    
    UILabel *nameLabel = [[UILabel alloc] init];
    //leftLabel.textColor = [UIColor colorWithHex:<#(NSString *)#>];
   // leftLabel.font = SYSTEMFONT(<#FONTSIZE#>);
    [self addSubview:nameLabel];
//    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.leading.equalTo(headImageView.mas_trailing).offset(10);
//        make.w
//    }];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
