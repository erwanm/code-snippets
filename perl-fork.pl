#!/usr/bin/perl

use strict;
use warnings;

my $n=5;
my $tasks=7;

my @pids; 
for (my $i=0; $i< $n; $i++) {
    $pids[$i] = fork();
    die "Cannot fork: $!" if (!defined($pids[$i]));
    print("starting task $i: pid $pids[$i]\n");
    if (! $pids[$i]) { # only the subprocess here.
	for (my $j=1; $j <= $tasks; $j++) {
	    print("task $i: $j\n");
	    sleep(int(rand(4)));
	}
	exit $i+10; # end of subprocess
    }
}
sleep(10);

my $done=0;
while ($done < $n) {
    my $pid = wait();
    my $res = $? >> 8;
    for (my $i=0;$i<$n;$i++) {
	if ($pid == $pids[$i]) {
	    print "was able to catch pid $pid i.e. task $i with return status $res\n";
	}
    }
    $done++;
    print "done=$done\n";
}
