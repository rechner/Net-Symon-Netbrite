#!/usr/bin/perl
use strict;
use warnings;
use lib 'lib';

use Net::Symon::NetBrite qw(:constants);
use Net::Symon::NetBrite::Zone;

use Config::Simple;


my $cfg = new Config::Simple('app.ini');

my $sign = Net::Symon::NetBrite->new(
    address => $cfg->param('NETBRITE.address')
);

$sign->zones(
    main  => Net::Symon::NetBrite::Zone->new(
       rect => [0, 1, 200, 16],
        default_font => 'monospace_16',
        default_color => COLOR_YELLOW,
    ),
    second => Net::Symon::NetBrite::Zone->new(
        rect => [0, 17, 200, 32],
        default_font => 'proportional_9',
        default_color => COLOR_YELLOW,
        
    ),
);

my $message = "{red}{scrolloff}Upcoming Events";
$sign->message('main', $message);

$sign->message('second', "Upcoming events....  {red}3D Modeling 101: {green}Saturday 26 October @ 11:00... {red}Git for Makers: {green}Tuesday 29 October @ 19:00...");

exit(0);

