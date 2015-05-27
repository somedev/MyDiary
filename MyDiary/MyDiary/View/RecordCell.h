//
//  RecordCell.h
//  MyDiary
//
//  Created by Eduard Panasiuk on 19.03.14.
//  Copyright (c) 2014 Eduard Panasiuk. All rights reserved.
//

@interface RecordCell : UITableViewCell

- (void)setupWithTitle:(NSAttributedString*)title
                record:(NSAttributedString*)record
                 color:(UIColor*)color;

@end
