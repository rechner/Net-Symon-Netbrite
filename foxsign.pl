#!/usr/bin/perl
use strict;
use warnings;
use lib 'lib';

use Net::Symon::NetBrite qw(:constants);
use Net::Symon::NetBrite::Zone;

use Net::MQTT::Simple;

use Config::Simple;

sub main {
    my $cfg = new Config::Simple('app.ini');


    my $mqtt = Net::MQTT::Simple->new($cfg->param('MQTT.address'));

    #$mqtt->retain( "topic/here" => "Message here");
    
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
            rect => [0, 20, 200, 32],
            default_font => 'proportional_9',
            default_color => COLOR_YELLOW,
            
        ),
    );

    $mqtt->run(
        "/symon/main" => sub {
            my ($topic, $message) = @_;
            print "[$topic] $message\n";
            $sign->message('main', $message);
        },
        "/symon/second" => sub {
            my ($topic, $message) = @_;
            print "[$topic] $message\n";
            $sign->message('second', $message);
        },
        "/symon/reboot" => sub {
            my ($topic, $message) = @_;
            print "[$topic] $message\n";
            $sign->reboot();
        }
    );



    exit(0);
}

main;
