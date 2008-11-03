//
//  main.m
//  Deploy Manager
//
//  Created by Ed Schmalzle on 10/29/08.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import <MacRuby/MacRuby.h>

int main(int argc, char *argv[])
{
    return macruby_main("rb_main.rb", argc, argv);
}
