#!/usr/bin/env perl
use strict;
use warnings;
use FindBin qw($Bin);
use lib "$Bin/../lib";
use Mail::SendGrid;
use Getopt::Long;


my %opt;
GetOptions( \%opt, 'help|h', 'username|u=s', 'password|p=s', 
    'start_date|s:s', 'end_date|e:s', 'days|d:i', 'limit|l:i', 'offset|s:i',
    'type|t:s', 'email|e:s') or usage();
usage() if !$opt{username} or !$opt{password} or $opt{help};

my $sendgrid = Mail::SendGrid->new(
    api_user => delete $opt{username},
    api_key => delete $opt{password},
);

for my $bounce ($sendgrid->bounces(\%opt)) {
    print "Bounce: " . $bounce->email. "\n";
}


sub usage {
    print <<USAGE;
$0: bounces.pl [opts]

Options:
username   (string) REQUIRED. SendGrid username (api_user)
password   (string) REQUIRED. SendGrid password (api_key)
days       (int)    Number of days in the past to retrieve (includes today)
start_date (string) Start date of date range (YYYY-MM-DD)
send_date  (string) End date of date range (YYYY-MM-DD)
limit      (int)    Limit number of results returned
offset     (int)    Beginning point in the list to retrieve from
USAGE
    die 0;
}
