############################################################################
# Copyright (c) 2000 SimpleWire. All rights reserved. This program is free
# software; you can redistribute it and/or modify it under the same terms
# as Perl itself.
#
# Net::Pager::Common.pm, version 2.00
#
# Root object for Net::Pager::Request and Net::Pager::Response
#
# NOTE:  This module currently is just a wrapper to Net::Pager::Common
# However, more functionality specific to SMS will be coming soon.
#
# SimpleWire
# 743 Beaubien St
# Suite 300
# Detroit, MI 48226
# 313.961.4407
#
# Net::Pager::Common 2.00 Release: 08/28/2000
# Coded By: Joe Lauer <joelauer@simplewire.com>
#
############################################################################


package Net::Pager::Common;

#---------------------------------------------------------------------
# Version Info
#---------------------------------------------------------------------
$Net::Pager::Common::VERSION = '2.00';
require 5.002;


#---------------------------------------------------------------------
# Other module use
#---------------------------------------------------------------------
use strict;
use XML::DOM;

use Net::Pager::Common;

######################################################################
# All objects that this object derives from
######################################################################
@Net::SMS::Common::ISA = qw(Net::Pager::Common);

######################################################################
#
# PUBLIC FUNCTIONS
#
######################################################################


######################################################################
# new function that response and request inherit
#
######################################################################

sub new {
    
	my $that  = shift;
    my $class = ref($that) || $that;
    local $_;
    my %args;

    #-----------------------------------------------------------------
	# Define default package vars
    #-----------------------------------------------------------------
    my $self = {

		XML_VERSION             => '1.0',
		REQUEST_TYPE            => '',
		REQUEST_VERSION         => '2.0',
        REQUEST_PROTOCOL        => 'paging',
        RESPONSE_TYPE            => '',
		RESPONSE_VERSION         => '2.0',
        RESPONSE_PROTOCOL        => 'paging',
		USER_AGENT 				=> 'Perl/Net-SMS/1.00',
        USER_IP     			=> '',
        SUBSCRIBER_ID   		=> '',
        SUBSCRIBER_PASSWORD 	=> '',
        TIMEOUT                 => '30',
        SERVICE_LIST            => [],
        SERVICE_INDEX           => 0,

        LAST_ERROR_CODE         => '',
        LAST_ERROR_DESCRIPTION  => '',

    };

    bless($self, $class);
    return $self;
}


1;
__END__;
