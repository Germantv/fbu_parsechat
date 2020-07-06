//
//  ChatCell.h
//  parsechat
//
//  Created by German Flores on 7/6/20.
//  Copyright © 2020 German Flores. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChatCell : UITableViewCell

// MARK: Outlets
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

@end

NS_ASSUME_NONNULL_END