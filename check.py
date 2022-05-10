#!/usr/bin/python
# -*-coding:utf-8 -*-

import os
import commands

def check():

    for path, dir_list, file_list in os.walk('./'):

        for file_name in file_list:

            # 略过 .DS_Store 文件
            if file_name.find('.DS_Store') != -1:
                continue

            # 略过 没有framework  .a 的文件
            #if path.find('.framework') == -1 and file_name.find('.a') == -1:
                #continue

            full_path = os.path.join(path, file_name)
            # print(full_path)

            if full_path.endswith('.h'):
                continue

            (status, output) = commands.getstatusoutput('file %s' % full_path)
            index = output.find('Mach-O universal binary')
            if index != -1:
                # print(full_path)

                (status, output) = commands.getstatusoutput('strings %s | grep -ir "uiwebview"' % full_path)
                if len(output) > 0:
                    print (full_path)



if __name__ == "__main__":
    print('Start to check library')
    check()
