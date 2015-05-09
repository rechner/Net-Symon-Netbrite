#!/usr/bin/perl
use strict;
use warnings;
use lib 'lib';

use Net::Symon::NetBrite qw(:constants);
use Net::Symon::NetBrite::Zone;

use Net::XMPP;
use Config::Simple;

my $cfg = new Config::Simple('app.ini');

# my $sign = Net::Symon::NetBrite->new(
#     address => $cfg->param('NETBRITE.address')
# );

# $sign->zones(
#    main  => Net::Symon::NetBrite::Zone->new(
#        rect => [0, 1, 160, 16],
#        default_font => 'proportional_5',
#        default_color => COLOR_RED,
#    ));

# <>;
# $sign->message('line1', 'Monkeys are awesome');
# <>;
# $sign->message('line5', '{red}The {green}Quick {red}Brown Fox Jumps Over the Lazy Dog');
# $sign->message('line1', 'Monkeys are awesome');
# <>;

my $server = $cfg->param('XMPP.server');
my $port = $cfg->param('XMPP.port');
my $username = $cfg->param('XMPP.username');
my $password = $cfg->param('XMPP.password');
my $resource = $cfg->param('XMPP.resource');

my $Connection = new Net::XMPP::Client(debuglevel=>0, debugfile=>'stdout');
$Connection->SetCallBacks(message=>\&InMessage);
my $status = $Connection->Connect(hostname=>$server,
                                  componentname=>$server,
                                  port=>$port,
                                  srv=>1,
                                  tls=>1,
                                  ssl_ca_path=>'/etc/ssl/certs');

$SIG{HUP} = \&Stop;
$SIG{KILL} = \&Stop;
$SIG{TERM} = \&Stop;
$SIG{INT} = \&Stop;

if (!(defined($status)))
{
    print "ERROR:  Jabber server is down or connection was not allowed.\n";
    print "        ($!)\n";
    exit(0);
}

my @result = $Connection->AuthSend(username=>$username,
                                   password=>$password,
                                   resource=>$resource);

if ($result[0] ne "ok")
{
    print "ERROR: Authorization failed: $result[0] - $result[1]\n";
    exit(0);
}

$Connection->RosterGet();
$Connection->PresenceSend();
while(defined($Connection->Process())) { }

exit(0);

sub Stop
{
    print "Exiting...\n";
    $Connection->Disconnect();
    exit(0);
}

sub InMessage
{
    my $sid = shift;
    my $message = shift;
    
    my $type = $message->GetType();
    my $fromJID = $message->GetFrom("jid");
    
    my $from = $fromJID->GetUserID();
    my $resource = $fromJID->GetResource();
    my $body = $message->GetBody();
    print "===\n";
    print "Message ($type)\n";
    print "  From: $from ($resource)\n";
    print "  Body: $body\n";
}

