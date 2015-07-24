#!/usr/bin/perl
#
# SmoothWall CGIs
#
# (c) 2005-2015 SmoothWall Ltd

use lib ('/usr/lib/smoothwall');
use header qw ( :standard );

my %settings, %netsettings, %hostsettings;

readhash("/var/smoothwall/apcupsd/settings", \%settings);
readhash("${swroot}/ethernet/settings", \%netsettings);
readhash("${swroot}/main/settings", \%hostsettings);

open (FILE, ">/etc/apcupsd/apcupsd.conf");

print FILE <<END;
## apcupsd.conf v1.1 ##
##
##  for apcupsd release 3.14.13 (02 February 2015)
##
## "apcupsd" POSIX config file
#
##
## ========= General configuration parameters ============
##
#
#
LOCKFILE /var/lock
SCRIPTDIR /etc/apcupsd/scripts
NETSERVER on
EVENTSFILE /var/smoothwall/apcupsd/events
EVENTSFILEMAX 25

END

print FILE "NISIP $netsettings{'GREEN_ADDRESS'}\n";
print FILE "TIMEOUT $settings{'TO'}\n";

if ($settings{UPSMODE} eq '0') {
	print FILE "UPSCABLE smart\n";
	print FILE "UPSTYPE apcsmart\n";
	print FILE "DEVICE $settings{'UPSPORT'}\n";
}

if ($settings{UPSMODE} eq '1') {
        print FILE "UPSCABLE usb\n";
        print FILE "UPSTYPE usb\n";
        print FILE "DEVICE\n";
}

if ($settings{UPSMODE} eq '2') {
	print FILE "UPSCABLE smart\n";
	print FILE "UPSTYPE modbus\n";
	print FILE "DEVICE $settings{'UPSPORT'}\n";
}

if ($settings{UPSMODE} eq '3') {
	print FILE "UPSCABLE usb\n";
	print FILE "UPSTYPE modbus\n";
	print FILE "DEVICE\n";
}

if ($settings{UPSMODE} eq '4') {
        print FILE "UPSCABLE ether\n";
        print FILE "UPSTYPE net\n";
        print FILE "DEVICE $settings{'UPSIP'}\n";
}

if ($settings{UPSMODE} eq '5') {
        print FILE "UPSCABLE ether\n";
        print FILE "UPSTYPE pcnet\n";
        print FILE "DEVICE $settings{'UPSIP'}:$settings{'UPSUSER'}:$settings{'UPSAUTH'}\n";
}

if ($settings{UPSMODE} eq '6') {
        print FILE "UPSCABLE 940-0020B\n";
        print FILE "UPSTYPE dumb\n";
        print FILE "DEVICE $settings{'UPSPORT'}\n";
}

if ($settings{UPSMODE} eq '7') {
        print FILE "UPSCABLE 940-0020C\n";
        print FILE "UPSTYPE dumb\n";
        print FILE "DEVICE $settings{'UPSPORT'}\n";
}

if ($settings{UPSMODE} eq '8') {
        print FILE "UPSCABLE 940-0023A \n";
        print FILE "UPSTYPE dumb\n";
        print FILE "DEVICE $settings{'UPSPORT'}\n";
}

if ($settings{UPSMODE} eq '9') {
        print FILE "UPSCABLE 940-0024B \n";
        print FILE "UPSTYPE apcsmart\n";
        print FILE "DEVICE $settings{'UPSPORT'}\n";
}

if ($settings{UPSMODE} eq '10') {
        print FILE "UPSCABLE 940-0024C \n";
        print FILE "UPSTYPE apcsmart\n";
        print FILE "DEVICE $settings{'UPSPORT'}\n";
}

if ($settings{UPSMODE} eq '11') {
        print FILE "UPSCABLE 940-0024G \n";
        print FILE "UPSTYPE apcsmart\n";
        print FILE "DEVICE $settings{'UPSPORT'}\n";
}

if ($settings{UPSMODE} eq '12') {
        print FILE "UPSCABLE 940-0095A \n";
        print FILE "UPSTYPE dumb\n";
        print FILE "DEVICE $settings{'UPSPORT'}\n";
}

if ($settings{UPSMODE} eq '13') {
        print FILE "UPSCABLE 940-0095B \n";
        print FILE "UPSTYPE dumb\n";
        print FILE "DEVICE $settings{'UPSPORT'}\n";
}

if ($settings{UPSMODE} eq '14') {
        print FILE "UPSCABLE 940-0095C \n";
        print FILE "UPSTYPE dumb\n";
        print FILE "DEVICE $settings{'UPSPORT'}\n";
}

if ($settings{UPSMODE} eq '15') {
        print FILE "UPSCABLE 940-0119A \n";
        print FILE "UPSTYPE dumb\n";
        print FILE "DEVICE $settings{'UPSPORT'}\n";
}

if ($settings{UPSMODE} eq '16') {
        print FILE "UPSCABLE 940-0127A \n";
        print FILE "UPSTYPE dumb\n";
        print FILE "DEVICE $settings{'UPSPORT'}\n";
}

if ($settings{UPSMODE} eq '17') {
        print FILE "UPSCABLE 940-0128A \n";
        print FILE "UPSTYPE dumb\n";
        print FILE "DEVICE $settings{'UPSPORT'}\n";
}

if ($settings{UPSMODE} eq '18') {
        print FILE "UPSCABLE 940-1524C \n";
        print FILE "UPSTYPE apcsmart\n";
        print FILE "DEVICE $settings{'UPSPORT'}\n";
}

if ($settings{STANDALONE} eq 'on') {
        print FILE "UPSCLASS standalone\n";
        print FILE "UPSMODE disable\n";
}
if ($settings{STANDALONE} eq 'off') {
        print FILE "USPCLASS sharemaster\n";
        print FILE "UPSMODE share\n";
}

        print FILE "POLLTIME $settings{'POLLTIME'}\n";
        print FILE "ONBATTERYDELAY $settings{'BATTDELAY'}\n";
        print FILE "BATTERYLEVEL $settings{'BATTLEVEL'}\n";
        print FILE "MINUTES $settings{'RTMIN'}\n";
        print FILE "ANNOY $settings{'ANNOY'}\n";

if ($settings{UPSNAME} ne '') {
        print FILE "UPSNAME $settings{'UPSNAME'}\n";
}

if ($settings{NISPORT} ne '') {
        print FILE "NISPORT $settings{'NISPORT'}\n";
}

if ($settings{NOLOGINTYPE} eq '0') {
        print FILE "NOLOGON disable\n";
}
if ($settings{NOLOGINTYPE} eq '1') {
        print FILE "NOLOGON percent\n";
}
if ($settings{NOLOGINTYPE} eq '2') {
        print FILE "NOLOGON minutes\n";
}
if ($settings{NOLOGINTYPE} eq '3') {
        print FILE "NOLOGON always\n";
}


close FILE;


if ($settings{'ENABLEALERTS'} eq 'on' and $settings{MSGONBATTERY} eq 'on') {
  open (FILE, ">/var/smoothwall/apcupsd/scripts/onbattery");
  print FILE <<END;
#!/bin/sh
#
# UPS on battery alert script
#
#
HOSTNAME=$hostsettings{HOSTNAME}
MSG="\$HOSTNAME: Utility Power Failure! UPS running on batteries."
/sbin/apcaccess status $netsettings{'GREEN_ADDRESS'} > /var/log/apcupsd
#
(
        echo "\$MSG"
        echo " "
        cat /var/log/apcupsd
)| /sbin/smtp -f $settings{FROMADDR} -h $settings{MAILSVR} -s "\$MSG" $settings{CC1ADDR} $settings{ALERTADDR}

(
	echo "\$MSG"
	echo " "
	grep TIMELEFT /var/log/apcupsd
	grep STATUS /var/log/apcupsd
	grep BCHARGE /var/log/apcupsd
)| /sbin/smtp -f $settings{FROMADDR} -h $settings{MAILSVR} -s "\$MSG" $settings{CC2ADDR}

echo `date +%Y-%m-%d%t%T%t%z` " Onbattery Alert email sent to: $settings{CC1ADDR} $settings{CC2ADDR} $settings{ALERTADDR}" >> /var/smoothwall/apcupsd/events
exit 0
END

} elsif (-f "/var/smoothwall/apcupsd/scripts/onbattery") {
	unlink("/var/smoothwall/apcupsd/scripts/onbattery");
}
close FILE;


if ($settings{'ENABLEALERTS'} eq 'on' and $settings{MSGOFFBATTERY} eq 'on') {
open (FILE, ">/var/smoothwall/apcupsd/scripts/offbattery");
print FILE <<END;
#!/bin/sh
#
# Utility power returned alert script
#
#
HOSTNAME=$hostsettings{HOSTNAME}
MSG="\$HOSTNAME: Utility Power Failure! UPS no longer running on batteries."
/sbin/apcaccess status $netsettings{'GREEN_ADDRESS'} > /var/log/apcupsd
#
(
        echo "\$MSG"
        echo " "
        cat /var/log/apcupsd
)| /sbin/smtp -f $settings{FROMADDR} -h $settings{MAILSVR} -s "\$MSG" $settings{CC1ADDR} $settings{ALERTADDR}

(
	echo "\$MSG"
	echo " "
	grep TIMELEFT /var/log/apcupsd
	grep STATUS /var/log/apcupsd
	grep BCHARGE /var/log/apcupsd
)| /sbin/smtp -f $settings{FROMADDR} -h $settings{MAILSVR} -s "\$MSG" $settings{CC2ADDR}

echo `date +%Y-%m-%d%t%T%t%z` " Offbattery Alert email sent to: $settings{CC1ADDR} $settings{CC2ADDR} $settings{ALERTADDR}" >> /var/smoothwall/apcupsd/events
exit 0
END

}elsif (-f "/var/smoothwall/apcupsd/scripts/offbattery")
	{
	unlink("/var/smoothwall/apcupsd/scripts/offbattery");
	}

if ($settings{'ENABLEALERTS'} eq 'on' and $settings{MSGCOMMFAILURE} eq 'on') {
open (FILE, ">/var/smoothwall/apcupsd/scripts/commfailure");
print FILE <<END;
#!/bin/sh
#
# Communication with UPS lost alert script
#
#
HOSTNAME=$hostsettings{HOSTNAME}
MSG="\$HOSTNAME: Communication with UPS lost."
/sbin/apcaccess status $netsettings{'GREEN_ADDRESS'} > /var/log/apcupsd
#
(
        echo "\$MSG"
        echo " "
        cat /var/log/apcupsd
)| /sbin/smtp -f $settings{FROMADDR} -h $settings{MAILSVR} -s "\$MSG" $settings{CC1ADDR} $settings{ALERTADDR}

(
	echo "\$MSG"
	echo " "
	grep TIMELEFT /var/log/apcupsd
	grep STATUS /var/log/apcupsd
	grep BCHARGE /var/log/apcupsd
)| /sbin/smtp -f $settings{FROMADDR} -h $settings{MAILSVR} -s "\$MSG" $settings{CC2ADDR}

echo `date +%Y-%m-%d%t%T%t%z` " Commfailure Alert email sent to: $settings{CC1ADDR} $settings{CC2ADDR} $settings{ALERTADDR}" >> /var/smoothwall/apcupsd/events
exit 0
END

}elsif (-f "/var/smoothwall/apcupsd/scripts/commfailure")
	{
	unlink("/var/smoothwall/apcupsd/scripts/commfailure");
	}

if ($settings{'ENABLEALERTS'} eq 'on' and $settings{MSGCOMMOK} eq 'on') {
open (FILE, ">/var/smoothwall/apcupsd/scripts/commok");
print FILE <<END;
#!/bin/sh
#
# Communication with UPS restored alert script
#
#
HOSTNAME=$hostsettings{HOSTNAME}
MSG="\$HOSTNAME: Communication with UPS restored."
/sbin/apcaccess status $netsettings{'GREEN_ADDRESS'} > /var/log/apcupsd
#
(
        echo "\$MSG"
        echo " "
        cat /var/log/apcupsd
)| /sbin/smtp -f $settings{FROMADDR} -h $settings{MAILSVR} -s "\$MSG" $settings{CC1ADDR} $settings{ALERTADDR}

(
	echo "\$MSG"
	echo " "
	grep TIMELEFT /var/log/apcupsd
	grep STATUS /var/log/apcupsd
	grep BCHARGE /var/log/apcupsd
)| /sbin/smtp -f $settings{FROMADDR} -h $settings{MAILSVR} -s "\$MSG" $settings{CC2ADDR}

echo `date +%Y-%m-%d%t%T%t%z` " Commok Alert email sent to: $settings{CC1ADDR} $settings{CC2ADDR} $settings{ALERTADDR}" >> /var/smoothwall/apcupsd/events
exit 0
END

}elsif (-f "/var/smoothwall/apcupsd/scripts/commok")
	{
	unlink("/var/smoothwall/apcupsd/scripts/commok");
	}

if ($settings{'ENABLEALERTS'} eq 'on' and $settings{MSGCHANGEME} eq 'on') {
open (FILE, ">/var/smoothwall/apcupsd/scripts/changeme");
print FILE <<END;
#!/bin/sh
#
# UPS battery replacement required alert script
#
#
HOSTNAME=$hostsettings{HOSTNAME}
MSG="\$HOSTNAME: UPS batteries require replacement."
/sbin/apcaccess status $netsettings{'GREEN_ADDRESS'} > /var/log/apcupsd
#
(
        echo "\$MSG"
        echo " "
        cat /var/log/apcupsd
)| /sbin/smtp -f $settings{FROMADDR} -h $settings{MAILSVR} -s "\$MSG" $settings{CC1ADDR} $settings{ALERTADDR}

(
	echo "\$MSG"
	echo " "
	grep TIMELEFT /var/log/apcupsd
	grep STATUS /var/log/apcupsd
	grep BCHARGE /var/log/apcupsd
)| /sbin/smtp -f $settings{FROMADDR} -h $settings{MAILSVR} -s "\$MSG" $settings{CC2ADDR}

echo `date +%Y-%m-%d%t%T%t%z` " Changeme Alert email sent to: $settings{CC1ADDR} $settings{CC2ADDR} $settings{ALERTADDR}" >> /var/smoothwall/apcupsd/events
exit 0
END

}elsif (-f "/var/smoothwall/apcupsd/scripts/changeme")
	{
	unlink("/var/smoothwall/apcupsd/scripts/changeme");
	}

if ($settings{'ENABLEALERTS'} eq 'on' and $settings{MSGANNOY} eq 'on') {
open (FILE, ">/var/smoothwall/apcupsd/scripts/annoyme");
print FILE <<END;
#!/bin/sh
#
# Annoyme alert script
#
#
HOSTNAME=$hostsettings{HOSTNAME}
MSG="\$HOSTNAME: Power problems with UPS."
//sbin/apcaccess status $netsettings{'GREEN_ADDRESS'} > /var/log/apcupsd
#
(
        echo "\$MSG"
        echo " "
        cat /var/log/apcupsd
)| /sbin/smtp -f $settings{FROMADDR} -h $settings{MAILSVR} -s "\$MSG" $settings{CC1ADDR} $settings{ALERTADDR}

(
	echo "\$MSG"
	echo " "
	grep TIMELEFT /var/log/apcupsd
	grep STATUS /var/log/apcupsd
	grep BCHARGE /var/log/apcupsd
)| /sbin/smtp -f $settings{FROMADDR} -h $settings{MAILSVR} -s "\$MSG" $settings{CC2ADDR}

echo `date +%Y-%m-%d%t%T%t%z` " Annoyme Alert email sent to: $settings{CC1ADDR} $settings{CC2ADDR} $settings{ALERTADDR}" >> /var/smoothwall/apcupsd/events
exit 0
END

#system(" 0755 /var/smoothwall/apcupsd/scripts/annoyme");
}elsif (-f "/var/smoothwall/apcupsd/scripts/annoyme")
	{
	unlink("/var/smoothwall/apcupsd/scripts/annoyme");
	}

if ($settings{'ENABLEALERTS'} eq 'on' and $settings{MSGBATTATTACH} eq 'on') {
open (FILE, ">/var/smoothwall/apcupsd/scripts/battattach");
print FILE <<END;
#!/bin/sh
#
# Battattach alert script
#
#
HOSTNAME=$hostsettings{HOSTNAME}
MSG="\$HOSTNAME: UPS Battery has been reconnected."
/sbin/apcaccess status $netsettings{'GREEN_ADDRESS'} > /var/log/apcupsd
#
(
        echo "\$MSG"
        echo " "
        cat /var/log/apcupsd
)| /sbin/smtp -f $settings{FROMADDR} -h $settings{MAILSVR} -s "\$MSG" $settings{CC1ADDR} $settings{ALERTADDR}

(
	echo "\$MSG"
	echo " "
	grep TIMELEFT /var/log/apcupsd
	grep STATUS /var/log/apcupsd
	grep BCHARGE /var/log/apcupsd
)| /sbin/smtp -f $settings{FROMADDR} -h $settings{MAILSVR} -s "\$MSG" $settings{CC2ADDR}

echo `date +%Y-%m-%d%t%T%t%z` " Battattach Alert email sent to: $settings{CC1ADDR} $settings{CC2ADDR} $settings{ALERTADDR}" >> /var/smoothwall/apcupsd/events
exit 0
END

}elsif (-f "/var/smoothwall/apcupsd/scripts/battattach")
	{
	unlink("/var/smoothwall/apcupsd/scripts/battattach");
	}

if ($settings{'ENABLEALERTS'} eq 'on' and $settings{MSGBATTDETACH} eq 'on') {
open (FILE, ">/var/smoothwall/apcupsd/scripts/battdetach");
print FILE <<END;
#!/bin/sh
#
# Battdetach alert script
#
#
HOSTNAME=$hostsettings{HOSTNAME}
MSG="\$HOSTNAME: UPS Battery has been disconnected."
/sbin/apcaccess status $netsettings{'GREEN_ADDRESS'} > /var/log/apcupsd
#
(
        echo "\$MSG"
        echo " "
        cat /var/log/apcupsd
)| /sbin/smtp -f $settings{FROMADDR} -h $settings{MAILSVR} -s "\$MSG" $settings{CC1ADDR} $settings{ALERTADDR}

(
	echo "\$MSG"
	echo " "
	grep TIMELEFT /var/log/apcupsd
	grep STATUS /var/log/apcupsd
	grep BCHARGE /var/log/apcupsd
)| /sbin/smtp -f $settings{FROMADDR} -h $settings{MAILSVR} -s "\$MSG" $settings{CC2ADDR}

echo `date +%Y-%m-%d%t%T%t%z` " Battdetach Alert email sent to: $settings{CC1ADDR} $settings{CC2ADDR} $settings{ALERTADDR}" >> /var/smoothwall/apcupsd/events
exit 0
END

}elsif (-f "/var/smoothwall/apcupsd/scripts/battdetach")
	{
	unlink("/var/smoothwall/apcupsd/scripts/battdetach");
	}

if ($settings{'ENABLEALERTS'} eq 'on' and $settings{MSGDOSHUTDOWN} eq 'on') {
open (FILE, ">/var/smoothwall/apcupsd/scripts/doshutdown");
print FILE <<END;
#!/bin/sh
#
# Doshutdown alert script
#
#
HOSTNAME=$hostsettings{HOSTNAME}
MSG="\$HOSTNAME: UPS initiating Shutdown Sequence."
/sbin/apcaccess status $netsettings{'GREEN_ADDRESS'} > /var/log/apcupsd
#
(
        echo "\$MSG"
        echo " "
        cat /var/log/apcupsd
)| /sbin/smtp -f $settings{FROMADDR} -h $settings{MAILSVR} -s "\$MSG" $settings{CC1ADDR} $settings{ALERTADDR}

(
	echo "\$MSG"
	echo " "
	grep TIMELEFT /var/log/apcupsd
	grep STATUS /var/log/apcupsd
	grep BCHARGE /var/log/apcupsd
)| /sbin/smtp -f $settings{FROMADDR} -h $settings{MAILSVR} -s "\$MSG" $settings{CC2ADDR}

echo `date +%Y-%m-%d%t%T%t%z` " Doshutdown Alert email sent to: $settings{CC1ADDR} $settings{CC2ADDR} $settings{ALERTADDR}" >> /var/smoothwall/apcupsd/events
exit 0
END

}elsif (-f "/var/smoothwall/apcupsd/scripts/doshutdown")
	{
	unlink("/var/smoothwall/apcupsd/scripts/doshutdown");
	}

if ($settings{'ENABLEALERTS'} eq 'on' and $settings{MSGEMERGENCY} eq 'on') {
open (FILE, ">/var/smoothwall/apcupsd/scripts/emergency");
print FILE <<END;
#!/bin/sh
#
# Emergency alert script
#
#
HOSTNAME=$hostsettings{HOSTNAME}
MSG="\$HOSTNAME: Emergency Shutdown. Possible battery failure on UPS."
/sbin/apcaccess status $netsettings{'GREEN_ADDRESS'} > /var/log/apcupsd
#
(
        echo "\$MSG"
        echo " "
        cat /var/log/apcupsd
)| /sbin/smtp -f $settings{FROMADDR} -h $settings{MAILSVR} -s "\$MSG" $settings{CC1ADDR} $settings{ALERTADDR}

(
	echo "\$MSG"
	echo " "
	grep TIMELEFT /var/log/apcupsd
	grep STATUS /var/log/apcupsd
	grep BCHARGE /var/log/apcupsd
)| /sbin/smtp -f $settings{FROMADDR} -h $settings{MAILSVR} -s "\$MSG" $settings{CC2ADDR}

echo `date +%Y-%m-%d%t%T%t%z` " Emergency Alert email sent to: $settings{CC1ADDR} $settings{CC2ADDR} $settings{ALERTADDR}" >> /var/smoothwall/apcupsd/events
exit 0
END

}elsif (-f "/var/smoothwall/apcupsd/scripts/emergency")
	{
	unlink("/var/smoothwall/apcupsd/scripts/emergency");
	}

if ($settings{'ENABLEALERTS'} eq 'on' and $settings{MSGENDSELFTEST} eq 'on') {
open (FILE, ">/var/smoothwall/apcupsd/scripts/endselftest");
print FILE <<END;
#!/bin/sh
#
# Endselftest alert script
#
#
HOSTNAME=$hostsettings{HOSTNAME}
MSG="\$HOSTNAME: UPS Self Test ended."
/sbin/apcaccess status $netsettings{'GREEN_ADDRESS'} > /var/log/apcupsd
#
(
        echo "\$MSG"
        echo " "
        cat /var/log/apcupsd
)| /sbin/smtp -f $settings{FROMADDR} -h $settings{MAILSVR} -s "\$MSG" $settings{CC1ADDR} $settings{ALERTADDR}

(
	echo "\$MSG"
	echo " "
	grep TIMELEFT /var/log/apcupsd
	grep STATUS /var/log/apcupsd
	grep BCHARGE /var/log/apcupsd
)| /sbin/smtp -f $settings{FROMADDR} -h $settings{MAILSVR} -s "\$MSG" $settings{CC2ADDR}

echo `date +%Y-%m-%d%t%T%t%z` " Endselftest Alert email sent to: $settings{CC1ADDR} $settings{CC2ADDR} $settings{ALERTADDR}" >> /var/smoothwall/apcupsd/events
exit 0
END

}elsif (-f "/var/smoothwall/apcupsd/scripts/endselftest")
	{
	unlink("/var/smoothwall/apcupsd/scripts/endselftest");
	}

if ($settings{'ENABLEALERTS'} eq 'on' and $settings{MSGFAILING} eq 'on') {
open (FILE, ">/var/smoothwall/apcupsd/scripts/failing");
print FILE <<END;
#!/bin/sh
#
# Battery failing alert script
#
#
HOSTNAME=$hostsettings{HOSTNAME}
MSG="\$HOSTNAME: Battery power exhaused on UPS. Doing shutdown."
/sbin/apcaccess status $netsettings{'GREEN_ADDRESS'} > /var/log/apcupsd
#
(
        echo "\$MSG"
        echo " "
        cat /var/log/apcupsd
)| /sbin/smtp -f $settings{FROMADDR} -h $settings{MAILSVR} -s "\$MSG" $settings{CC1ADDR} $settings{ALERTADDR}

(
	echo "\$MSG"
	echo " "
	grep TIMELEFT /var/log/apcupsd
	grep STATUS /var/log/apcupsd
	grep BCHARGE /var/log/apcupsd
)| /sbin/smtp -f $settings{FROMADDR} -h $settings{MAILSVR} -s "\$MSG" $settings{CC2ADDR}

echo `date +%Y-%m-%d%t%T%t%z` " Failing Alert email sent to: $settings{CC1ADDR} $settings{CC2ADDR} $settings{ALERTADDR}" >> /var/smoothwall/apcupsd/events
exit 0
END

}elsif (-f "/var/smoothwall/apcupsd/scripts/failing")
	{
	unlink("/var/smoothwall/apcupsd/scripts/failing");
	}

if ($settings{'ENABLEALERTS'} eq 'on' and $settings{MSGKILLPOWER} eq 'on') {
open (FILE, ">/var/smoothwall/apcupsd/scripts/killpower");
print FILE <<END;
#!/bin/sh
#
# UPS killpower alert script
#
#
HOSTNAME=$hostsettings{HOSTNAME}
MSG="\$HOSTNAME: Apccontrol doing: /sbin/apcupsd --killpower on UPS!"
/sbin/apcaccess status $netsettings{'GREEN_ADDRESS'} > /var/log/apcupsd
#
(
        echo "\$MSG"
        echo " "
        cat /var/log/apcupsd
)| /sbin/smtp -f $settings{FROMADDR} -h $settings{MAILSVR} -s "\$MSG" $settings{CC1ADDR} $settings{ALERTADDR}

(
	echo "\$MSG"
	echo " "
	grep TIMELEFT /var/log/apcupsd
	grep STATUS /var/log/apcupsd
	grep BCHARGE /var/log/apcupsd
)| /sbin/smtp -f $settings{FROMADDR} -h $settings{MAILSVR} -s "\$MSG" $settings{CC2ADDR}

echo `date +%Y-%m-%d%t%T%t%z` " Killpower Alert email sent to: $settings{CC1ADDR} $settings{CC2ADDR} $settings{ALERTADDR}" >> /var/smoothwall/apcupsd/events
exit 0
END

}elsif (-f "/var/smoothwall/apcupsd/scripts/killpower")
	{
	unlink("/var/smoothwall/apcupsd/scripts/killpower");
	}

if ($settings{'ENABLEALERTS'} eq 'on' and $settings{MSGLOADLIMIT} eq 'on') {
open (FILE, ">/var/smoothwall/apcupsd/scripts/loadlimit");
print FILE <<END;
#!/bin/sh
#
# Loadlimit alert script
#
#
HOSTNAME=$hostsettings{HOSTNAME}
MSG="\$HOSTNAME: Remaining battery charge below limit on UPS. Doing shutdown."
/sbin/apcaccess status $netsettings{'GREEN_ADDRESS'} > /var/log/apcupsd
#
(
        echo "\$MSG"
        echo " "
        cat /var/log/apcupsd
)| /sbin/smtp -f $settings{FROMADDR} -h $settings{MAILSVR} -s "\$MSG" $settings{CC1ADDR} $settings{ALERTADDR}

(
	echo "\$MSG"
	echo " "
	grep TIMELEFT /var/log/apcupsd
	grep STATUS /var/log/apcupsd
	grep BCHARGE /var/log/apcupsd
)| /sbin/smtp -f $settings{FROMADDR} -h $settings{MAILSVR} -s "\$MSG" $settings{CC2ADDR}

echo `date +%Y-%m-%d%t%T%t%z` " Loadlimit Alert email sent to: $settings{CC1ADDR} $settings{CC2ADDR} $settings{ALERTADDR}" >> /var/smoothwall/apcupsd/events
exit 0
END

}elsif (-f "/var/smoothwall/apcupsd/scripts/loadlimit")
	{
	unlink("/var/smoothwall/apcupsd/scripts/loadlimit");
	}

if ($settings{'ENABLEALERTS'} eq 'on' and $settings{MSGPOWERBACK} eq 'on') {
open (FILE, ">/var/smoothwall/apcupsd/scripts/mainsback");
print FILE <<END;
#!/bin/sh
#
# Mainsback alert script
#
#
HOSTNAME=$hostsettings{HOSTNAME}
MSG="\$HOSTNAME: Utility Power Restored!"
/sbin/apcaccess status $netsettings{'GREEN_ADDRESS'} > /var/log/apcupsd
#
(
        echo "\$MSG"
        echo " "
        cat /var/log/apcupsd
)| /sbin/smtp -f $settings{FROMADDR} -h $settings{MAILSVR} -s "\$MSG" $settings{CC1ADDR} $settings{ALERTADDR}

(
	echo "\$MSG"
	echo " "
	grep TIMELEFT /var/log/apcupsd
	grep STATUS /var/log/apcupsd
	grep BCHARGE /var/log/apcupsd
)| /sbin/smtp -f $settings{FROMADDR} -h $settings{MAILSVR} -s "\$MSG" $settings{CC2ADDR}

echo `date +%Y-%m-%d%t%T%t%z` " Mainsback Alert email sent to: $settings{CC1ADDR} $settings{CC2ADDR} $settings{ALERTADDR}" >> /var/smoothwall/apcupsd/events
exit 0
END

}elsif (-f "/var/smoothwall/apcupsd/scripts/mainsback")
	{
	unlink("/var/smoothwall/apcupsd/scripts/mainsback");
	}

if ($settings{'ENABLEALERTS'} eq 'on' and $settings{MSGPOWEROUT} eq 'on') {
open (FILE, ">/var/smoothwall/apcupsd/scripts/powerout");
print FILE <<END;
#!/bin/sh
#
# Powerout alert script
#
#
HOSTNAME=$hostsettings{HOSTNAME}
MSG="\$HOSTNAME: Utility Power Failure!"
/sbin/apcaccess status $netsettings{'GREEN_ADDRESS'} > /var/log/apcupsd
#
(
        echo "\$MSG"
        echo " "
        cat /var/log/apcupsd
)| /sbin/smtp -f $settings{FROMADDR} -h $settings{MAILSVR} -s "\$MSG" $settings{CC1ADDR} $settings{ALERTADDR}

(
	echo "\$MSG"
	echo " "
	grep TIMELEFT /var/log/apcupsd
	grep STATUS /var/log/apcupsd
	grep BCHARGE /var/log/apcupsd
)| /sbin/smtp -f $settings{FROMADDR} -h $settings{MAILSVR} -s "\$MSG" $settings{CC2ADDR}

echo `date +%Y-%m-%d%t%T%t%z` " Powerout Alert email sent to: $settings{CC1ADDR} $settings{CC2ADDR} $settings{ALERTADDR}" >> /var/smoothwall/apcupsd/events
exit 0
END

}elsif (-f "/var/smoothwall/apcupsd/scripts/powerout")
	{
	unlink("/var/smoothwall/apcupsd/scripts/powerout");
	}

if ($settings{'ENABLEALERTS'} eq 'on' and $settings{MSGREMOTEDOWN} eq 'on') {
open (FILE, ">/var/smoothwall/apcupsd/scripts/remotedown");
print FILE <<END;
#!/bin/sh
#
# Remotedown alert script
#
#
HOSTNAME=$hostsettings{HOSTNAME}
MSG="\$HOSTNAME: Remote Shutdown. Beginning Shutdown Sequence."
/sbin/apcaccess status $netsettings{'GREEN_ADDRESS'} > /var/log/apcupsd
#
(
        echo "\$MSG"
        echo " "
        cat /var/log/apcupsd
)| /sbin/smtp -f $settings{FROMADDR} -h $settings{MAILSVR} -s "\$MSG" $settings{CC1ADDR} $settings{ALERTADDR}

(
	echo "\$MSG"
	echo " "
	grep TIMELEFT /var/log/apcupsd
	grep STATUS /var/log/apcupsd
	grep BCHARGE /var/log/apcupsd
)| /sbin/smtp -f $settings{FROMADDR} -h $settings{MAILSVR} -s "\$MSG" $settings{CC2ADDR}

echo `date +%Y-%m-%d%t%T%t%z` " Remotedown Alert email sent to: $settings{CC1ADDR} $settings{CC2ADDR} $settings{ALERTADDR}" >> /var/smoothwall/apcupsd/events
exit 0
END

}elsif (-f "/var/smoothwall/apcupsd/scripts/remotedown")
	{
	unlink("/var/smoothwall/apcupsd/scripts/remotedown");
	}

if ($settings{'ENABLEALERTS'} eq 'on' and $settings{MSGRUNLIMIT} eq 'on') {
open (FILE, ">/var/smoothwall/apcupsd/scripts/runlimit");
print FILE <<END;
#!/bin/sh
#
# Runlimit alert script
#
#
HOSTNAME=$hostsettings{HOSTNAME}
MSG="\$HOSTNAME: Remaining battery runtime below limit on UPS. Doing shutdown."
/sbin/apcaccess status $netsettings{'GREEN_ADDRESS'} > /var/log/apcupsd
#
(
        echo "\$MSG"
        echo " "
        cat /var/log/apcupsd
)| /sbin/smtp -f $settings{FROMADDR} -h $settings{MAILSVR} -s "\$MSG" $settings{CC1ADDR} $settings{ALERTADDR}

(
	echo "\$MSG"
	echo " "
	grep TIMELEFT /var/log/apcupsd
	grep STATUS /var/log/apcupsd
	grep BCHARGE /var/log/apcupsd
)| /sbin/smtp -f $settings{FROMADDR} -h $settings{MAILSVR} -s "\$MSG" $settings{CC2ADDR}

echo `date +%Y-%m-%d%t%T%t%z` " Runlimit Alert email sent to: $settings{CC1ADDR} $settings{CC2ADDR} $settings{ALERTADDR}" >> /var/smoothwall/apcupsd/events
exit 0
END

}elsif (-f "/var/smoothwall/apcupsd/scripts/runlimit")
	{
	unlink("/var/smoothwall/apcupsd/scripts/runlimit");
	}

if ($settings{'ENABLEALERTS'} eq 'on' and $settings{MSGSTARTSELFTEST} eq 'on') {
open (FILE, ">/var/smoothwall/apcupsd/scripts/startselftest");
print FILE <<END;
#!/bin/sh
#
# Startselftest alert script
#
#
HOSTNAME=$hostsettings{HOSTNAME}
MSG="\$HOSTNAME: UPS Self Test started."
/sbin/apcaccess status $netsettings{'GREEN_ADDRESS'} > /var/log/apcupsd
#
(
        echo "\$MSG"
        echo " "
        cat /var/log/apcupsd
)| /sbin/smtp -f $settings{FROMADDR} -h $settings{MAILSVR} -s "\$MSG" $settings{CC1ADDR} $settings{ALERTADDR}

(
	echo "\$MSG"
	echo " "
	grep TIMELEFT /var/log/apcupsd
	grep STATUS /var/log/apcupsd
	grep BCHARGE /var/log/apcupsd
)| /sbin/smtp -f $settings{FROMADDR} -h $settings{MAILSVR} -s "\$MSG" $settings{CC2ADDR}

echo `date +%Y-%m-%d%t%T%t%z` " Startselftest Alert email sent to: $settings{CC1ADDR} $settings{CC2ADDR} $settings{ALERTADDR}" >> /var/smoothwall/apcupsd/events
exit 0
END

}elsif (-f "/var/smoothwall/apcupsd/scripts/startselftest")
	{
	unlink("/var/smoothwall/apcupsd/scripts/startselftest");
	}

if ($settings{'ENABLEALERTS'} eq 'on' and $settings{MSGTIMEOUT} eq 'on') {
open (FILE, ">/var/smoothwall/apcupsd/scripts/timeout");
print FILE <<END;
#!/bin/sh
#
# Timeout alert script
#
#
HOSTNAME=$hostsettings{HOSTNAME}
MSG="\$HOSTNAME: Battery time limit exceeded on UPS. Doing shutdown."
/sbin/apcaccess status $netsettings{'GREEN_ADDRESS'} > /var/log/apcupsd
#
(
        echo "\$MSG"
        echo " "
        cat /var/log/apcupsd
)| /sbin/smtp -f $settings{FROMADDR} -h $settings{MAILSVR} -s "\$MSG" $settings{CC1ADDR} $settings{ALERTADDR}

(
	echo "\$MSG"
	echo " "
	grep TIMELEFT /var/log/apcupsd
	grep STATUS /var/log/apcupsd
	grep BCHARGE /var/log/apcupsd
)| /sbin/smtp -f $settings{FROMADDR} -h $settings{MAILSVR} -s "\$MSG" $settings{CC2ADDR}

echo `date +%Y-%m-%d%t%T%t%z` " Timeout Alert email sent to: $settings{CC1ADDR} $settings{CC2ADDR} $settings{ALERTADDR}" >> /var/smoothwall/apcupsd/events
exit 0
END

}elsif (-f "/var/smoothwall/apcupsd/scripts/timeout")
	{
	unlink("/var/smoothwall/apcupsd/scripts/timeout");
	}

if ($settings{'ENABLEALERTS'} eq 'on' and $settings{OPMODE} eq 'testing') {
open (FILE, ">/var/smoothwall/apcupsd/scripts/apccontrol");
print FILE <<END;
#!/bin/sh
#
# Copyright (C) 1999-2002 Riccardo Facchetti <riccardo@master.oasi.gpa.it>
#
#  for apcupsd release 3.14.10 (13 September 2011)
#
# platforms/apccontrol.  Generated from apccontrol.in by configure.
#
prefix=/etc/apcupsd
exec_prefix=\${prefix}

APCPID=/var/run/apcupsd.pid
APCUPSD=/sbin/apcupsd
SHUTDOWN=/sbin/shutdown
SCRIPTSHELL=/
SCRIPTDIR=/var/smoothwall/apcupsd/scripts
WALL=wall
#
#
if [ -f \${SCRIPTDIR}/\${1} -a -x \${SCRIPTDIR}/\${1} ]
then
    \${SCRIPTDIR}/\${1} \${2} \${3} \${4}
    # exit code 99 means he does not want us to do default action
    if [ \$? = 99 ] ; then
        exit 0
    fi
fi
#
#
case "\$1" in
#    killpower)
#        echo "Apccontrol doing: \${APCUPSD} --killpower on UPS \${2}"
#        sleep 10
#        \${APCUPSD} --killpower
#    echo "Apccontrol has done: \${APCUPSD} --killpower on UPS \${2}" | \${WALL}
#    ;;
    commfailure)
        echo "Warning communications lost with UPS \${2}" | \${WALL}
    ;;
    commok)
        echo "Communications restored with UPS \${2}" | \${WALL}
    ;;
#
# powerout, onbattery, offbattery, mainsback events occur
#   in that order.
#
    powerout)
    ;;
    onbattery)
        echo "Power failure on UPS \${2}. Running on batteries." | \${WALL}
    ;;
    offbattery)
        echo "Power has returned on UPS \${2}..." | \${WALL}
    ;;
    mainsback)
        if [ -f /etc/apcupsd/powerfail ] ; then
           printf "Continuing with shutdown."  | \${WALL}
        fi
    ;;
    failing)
        echo "Battery power exhaused on UPS \${2}. Doing shutdown." | \${WALL}
   ;;
    timeout)
        echo "Battery time limit exceeded on UPS \${2}. Doing shutdown." | \${WALL}
    ;;
    loadlimit)
        echo "Remaining battery charge below limit on UPS \${2}. Doing shutdown." | \${WALL}
    ;;
    runlimit)
        echo "Remaining battery runtime below limit on UPS \${2}. Doing shutdown." | \${WALL}
    ;;
#    doreboot)
#        echo "UPS \${2} initiating Reboot Sequence" | \${WALL}
#        \${SHUTDOWN} -r now "apcupsd UPS \${2} initiated reboot"
#    ;;
#    doshutdown)
#        echo "UPS \${2} initiated Shutdown Sequence" | \${WALL}
#        \${SHUTDOWN} -h now "apcupsd UPS \${2} initiated shutdown"
#    ;;
    annoyme)
        echo "Power problems with UPS \${2}. Please logoff." | \${WALL}
    ;;
    emergency)
        echo "Emergency Shutdown. Possible battery failure on UPS \${2}." | \${WALL}
    ;;
    changeme)
        echo "Emergency! Batteries have failed on UPS \${2}. Change them NOW" | \${WALL}
    ;;
    remotedown)
        echo "Remote Shutdown. Beginning Shutdown Sequence." | \${WALL}
    ;;
    startselftest)
    ;;
    endselftest)
    ;;
    battdetach)
    ;;
    battattach)
    ;;
    *)  echo "Usage: \${0##*/} command"
        echo "       warning: this script is intended to be launched by"
        echo "       apcupsd and should never be launched by users."
        exit 1
    ;;
esac
END

}

if ($settings{OPMODE} eq 'full') {

open (FILE, ">/var/smoothwall/apcupsd/scripts/apccontrol");
print FILE <<END;
#!/bin/sh
#
# Copyright (C) 1999-2002 Riccardo Facchetti <riccardo@master.oasi.gpa.it>
#
#  for apcupsd release 3.14.10 (13 September 2011)
#
# platforms/apccontrol.  Generated from apccontrol.in by configure.
#
prefix=/etc/apcupsd
exec_prefix=\${prefix}

APCPID=/var/run/apcupsd.pid
APCUPSD=/sbin/apcupsd
SHUTDOWN=/sbin/shutdown
SCRIPTSHELL=/bin/sh
SCRIPTDIR=/var/smoothwall/apcupsd/scripts
WALL=wall
#
#
if [ -f \${SCRIPTDIR}/\${1} -a -x \${SCRIPTDIR}/\${1} ]
then
    \${SCRIPTDIR}/\${1} \${2} \${3} \${4}
    # exit code 99 means he does not want us to do default action
    if [ \$? = 99 ] ; then
        exit 0
    fi
fi
#
#
case "\$1" in
    killpower)
        echo "Apccontrol doing: \${APCUPSD} --killpower on UPS \${2}"
        sleep 10
        \${APCUPSD} --killpower
    echo "Apccontrol has done: \${APCUPSD} --killpower on UPS \${2}" | \${WALL}
    ;;
    commfailure)
        echo "Warning communications lost with UPS \${2}" | \${WALL}
    ;;
    commok)
        echo "Communications restored with UPS \${2}" | \${WALL}
    ;;
#
# powerout, onbattery, offbattery, mainsback events occur
#   in that order.
#
    powerout)
    ;;
    onbattery)
        echo "Power failure on UPS \${2}. Running on batteries." | \${WALL}
    ;;
    offbattery)
        echo "Power has returned on UPS \${2}..." | \${WALL}
    ;;
    mainsback)
        if [ -f /etc/apcupsd/powerfail ] ; then
           printf "Continuing with shutdown."  | \${WALL}
        fi
    ;;
    failing)
        echo "Battery power exhaused on UPS \${2}. Doing shutdown." | \${WALL}
   ;;
    timeout)
        echo "Battery time limit exceeded on UPS \${2}. Doing shutdown." | \${WALL}
    ;;
    loadlimit)
        echo "Remaining battery charge below limit on UPS \${2}. Doing shutdown." | \${WALL}
    ;;
    runlimit)
        echo "Remaining battery runtime below limit on UPS \${2}. Doing shutdown." | \${WALL}
    ;;
    doreboot)
        echo "UPS \${2} initiating Reboot Sequence" | \${WALL}
        \${SHUTDOWN} -r now "apcupsd UPS \${2} initiated reboot"
    ;;
    doshutdown)
        echo "UPS \${2} initiated Shutdown Sequence" | \${WALL}
        \${SHUTDOWN} -h now "apcupsd UPS \${2} initiated shutdown"
    ;;
    annoyme)
        echo "Power problems with UPS \${2}. Please logoff." | \${WALL}
    ;;
    emergency)
        echo "Emergency Shutdown. Possible battery failure on UPS \${2}." | \${WALL}
    ;;
    changeme)
        echo "Emergency! Batteries have failed on UPS \${2}. Change them NOW" | \${WALL}
    ;;
    remotedown)
        echo "Remote Shutdown. Beginning Shutdown Sequence." | \${WALL}
    ;;
    startselftest)
    ;;
    endselftest)
    ;;
    battdetach)
    ;;
    battattach)
    ;;
    *)  echo "Usage: \${0##*/} command"
        echo "       warning: this script is intended to be launched by"
        echo "       apcupsd and should never be launched by users."
        exit 1
    ;;
esac
END

}

system("chmod -R 0755 /etc/apcupsd/scripts/");
