########################################################################
# Copyright (c) 2001 Simplewire. All rights reserved. This program is free
# software; you can redistribute it and/or modify it under the same terms
# as Perl itself.
#
# Net::SMS.pm, version 2.10
#
# Net::SMS is a global short text messaging service interface via the
# Internet.  It brings you the first and only way to send SMS messages
# through one easy interface.  Simplewire has defined an XML SMS standard
# and will make numerous tools available for developer's use so that SMS
# technology can be better utilized.
#
# Net::SMS 1.00 Release: 10/05/2000
# Net::SMS 2.00 Release: 03/23/2001
# Net::SMS 2.10 Release: 04/14/2001
# Net::SMS 2.12 Release: 04/16/2001
############################################################################

#---------------------------------------------------------------------
# User documentation within and more is in POD format is at end of
# this file.  Search for =head
#---------------------------------------------------------------------

package Net::SMS;

#---------------------------------------------------------------------
# Version Info
#---------------------------------------------------------------------
$Net::SMS::VERSION = '2.13';
require 5.002;

#---------------------------------------------------------------------
# Other module use
#---------------------------------------------------------------------
use strict;
use XML::DOM;
use Net::SMS::HTTP;

######################################################################
# Net::SMS->new();
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

        DEBUG                   => 0,
        RPC_SERVER_NAME         => 'rpc',
        RPC_SERVER_DOMAIN       => 'simplewire.com',
        RPC_SERVER_PORT         => 80,
        RPC_FLOOR               => 1,
        RPC_CEILING             => 20,
        RPC_PROTOCOL            => 'http://',
        RPC_PAGING_URL          => '/paging/rpc.xml',
        RPC_BEG_RESPONSE        => '<?xml version="1.0" ?>',
        RPC_END_RESPONSE        => '</response>',
        LAST_ERROR_CODE         => '',
        LAST_ERROR_DESCRIPTION  => '',
		XML_VERSION             => '1.0',
		REQUEST_TYPE            => '',
		REQUEST_VERSION         => '2.0',
        REQUEST_PROTOCOL        => 'paging',
        RESPONSE_TYPE           => '',
		RESPONSE_VERSION        => '2.0',
        RESPONSE_PROTOCOL       => 'paging',
		USER_AGENT 				=> 'Perl/SMS/2.1.3',
        USER_IP     			=> '',
        SUBSCRIBER_ID   		=> '',
        SUBSCRIBER_PASSWORD		=> '',
        TIMEOUT					=> '30',
        SERVICE_ID              => '',
        SERVICE_LIST            => [],
        SERVICE_INDEX           => 0,
        OPTION_METHOD           => 'synch',
        OPTION_TYPE             => 'production',
        OPTION_FIELDS           => 'all',
    };

    bless($self, $class);
    return $self;
}

sub carrierList {
    my $self = shift();
    die "You must instantiate an object to use this function" if !(ref($self));

    return @{ $self->{SERVICE_LIST} };
}

sub carrierListSend {
    my $self = shift();
    die "You must instantiate an object to use this function" if !(ref($self));

    return $self->send('servicelist');
}

sub errorCode {
    my $self = shift();
    die "You must instantiate an object to use this function" if !(ref($self));

    if (@_ == 1) { $self->{LAST_ERROR_CODE} = shift(); }

    return $self->{LAST_ERROR_CODE} if defined($self->{LAST_ERROR_CODE}) || return undef;

}

sub errorDesc {
    my $self = shift();
    die "You must instantiate an object to use this function" if !(ref($self));

    if (@_ == 1) { $self->{LAST_ERROR_DESCRIPTION} = shift(); }

    return $self->{LAST_ERROR_DESCRIPTION} if defined($self->{LAST_ERROR_DESCRIPTION}) || return undef;

}

sub isCarrierlist {
    my $self = shift();
    die "You must instantiate an object to use this function" if !(ref($self));

    return 1 if ($self->{REQUEST_TYPE} eq "servicelist");
    return 0;

}

sub isMsg {
    my $self = shift();
    die "You must instantiate an object to use this function" if !(ref($self));

    return 1 if ($self->{REQUEST_TYPE} eq "sendpage");
    return 0;

}

sub isMsgStatus {
    my $self = shift();
    die "You must instantiate an object to use this function" if !(ref($self));

    return 1 if ($self->{REQUEST_TYPE} eq "checkstatus");
    return 0;

}

sub msgCallback {
    my $self = shift();
    die "You must instantiate an object to use this function" if !(ref($self));

    if (@_ == 1) { $self->{CALLBACK} = shift(); }

    return $self->{CALLBACK} if defined($self->{CALLBACK}) || return undef;

}

sub msgCarrierID {
    my $self = shift();
    die "You must instantiate an object to use this function" if !(ref($self));

    if (@_ == 1) { $self->{SERVICE_ID} = shift(); }

    return $self->{SERVICE_ID} if defined($self->{SERVICE_ID}) || return undef;

}

sub msgFrom {
    my $self = shift();
    die "You must instantiate an object to use this function" if !(ref($self));

    if (@_ == 1) { $self->{FROM} = shift(); }

    return $self->{FROM} if defined($self->{FROM}) || return undef;

}

sub msgPin {
    my $self = shift();
    die "You must instantiate an object to use this function" if !(ref($self));

    if (@_ == 1) { $self->{PIN} = shift(); }

    return $self->{PIN} if defined($self->{PIN}) || return undef;

}

sub msgSend {
    my $self = shift();
    die "You must instantiate an object to use this function" if !(ref($self));

    return $self->send('sendpage');
}

sub msgSendEx {
    my $self = shift();
    die "You must instantiate an object to use this function" if !(ref($self));

    $self->msgCarrierId(shift());
    $self->msgPin(shift());
    $self->msgFrom(shift());
    $self->msgCallback(shift());
    $self->msgText(shift());

    return $self->send('sendpage');
}

sub msgStatusCode {
    my $self = shift();
    die "You must instantiate an object to use this function" if !(ref($self));

    if (@_ == 1) { $self->{STATUS_CODE} = shift(); }

    return $self->{STATUS_CODE} if defined($self->{STATUS_CODE}) || return undef;

}

sub msgStatusDscr {
    my $self = shift();
    die "You must instantiate an object to use this function" if !(ref($self));

    if (@_ == 1) { $self->{STATUS_DESCRIPTION} = shift(); }

    return $self->{STATUS_DESCRIPTION} if defined($self->{STATUS_DESCRIPTION}) || return undef;

}

sub msgStatusSend {
    my $self = shift();
    die "You must instantiate an object to use this function" if !(ref($self));

    return $self->send('checkstatus');
}

sub msgText {
    my $self = shift();
    die "You must instantiate an object to use this function" if !(ref($self));

    if (@_ == 1) { $self->{TEXT} = shift(); }

    return $self->{TEXT} if defined($self->{TEXT}) || return undef;

}

sub msgTicketID {
    my $self = shift();
    die "You must instantiate an object to use this function" if !(ref($self));

    if (@_ == 1) { $self->{TICKET_ID} = shift(); }

    return $self->{TICKET_ID} if defined($self->{TICKET_ID}) || return undef;

}

sub optDelimiter {
    my $self = shift();
    die "You must instantiate an object to use this function" if !(ref($self));

    if (@_ == 1) { $self->{OPTION_DELIMITER} = shift(); }

    return $self->{OPTION_DELIMITER} if defined($self->{OPTION_DELIMITER}) || return undef;

}

sub optFields {

    my $self = shift();
    die "You must instantiate an object to use this function" if !(ref($self));

    if (@_ == 1) { $self->{OPTION_FIELDS} = shift(); }

    return $self->{OPTION_FIELDS} if defined($self->{OPTION_FIELDS}) || return undef;

}

sub optMethod {
    my $self = shift();
    die "You must instantiate an object to use this function" if !(ref($self));

    if (@_ == 1) { $self->{OPTION_METHOD} = shift(); }

    return $self->{OPTION_METHOD} if defined($self->{OPTION_METHOD}) || return undef;

}

sub optTimeout {
    my $self = shift();
    die "You must instantiate an object to use this function" if !(ref($self));

    if (@_ == 1) { $self->{OPTION_TIMEOUT} = shift(); }

    return $self->{OPTION_TIMEOUT} if defined($self->{OPTION_TIMEOUT}) || return undef;

}

sub optType {

    my $self = shift();
    die "You must instantiate an object to use this function" if !(ref($self));

    if (@_ == 1) { $self->{OPTION_TYPE} = shift(); }

    return $self->{OPTION_TYPE} if defined($self->{OPTION_TYPE}) || return undef;

}

sub serverDomain {
    my $self = shift();
    die "You must instantiate an object to use this function" if !(ref($self));

    if (@_ == 1) { $self->{RPC_SERVER_DOMAIN} = shift(); }

    return $self->{RPC_SERVER_DOMAIN} if defined($self->{RPC_SERVER_DOMAIN}) || return undef;

}

sub serverName {
    my $self = shift();
    die "You must instantiate an object to use this function" if !(ref($self));

    if (@_ == 1) { $self->{RPC_SERVER_NAME} = shift(); }

    return $self->{RPC_SERVER_NAME} if defined($self->{RPC_SERVER_NAME}) || return undef;

}

sub subscriberID {
    my $self = shift();
    die "You must instantiate an object to use this function" if !(ref($self));

    my $var = shift();

    if (defined($var)) { $self->{SUBSCRIBER_ID} = $var; }

    return $self->{USER_IP};

}

sub success {
    my $self = shift();
    die "You must instantiate an object to use this function" if !(ref($self));

    # if the error_code is between 0 and 10 then its an okay response.
    if ($self->errorCode >= 0 and $self->errorCode <= 10 and $self->errorCode ne "") {
        return 1;
    }

    return 0;

}

sub synchronous {
    my $self = shift();
    die "You must instantiate an object to use this function" if !(ref($self));

    if (@_ == 1 && shift()) {
		$self->{OPTION_METHOD} = 'synch';
	} else {
        $self->{OPTION_METHOD} = 'asynch';
    }

    if (defined($self->{OPTION_METHOD})) {
        if ($self->{OPTION_METHOD} eq "synch") {
            return 1;
        } else {
            return 0;
        }
    } else {
        return undef;
    }
}

sub userIP {
    my $self = shift();
    die "You must instantiate an object to use this function" if !(ref($self));

    my $var = shift();

    if (defined($var)) { $self->{USER_IP} = $var; }

    return $self->{USER_IP};

}

sub userAgent {
    
    # Deprecated userAgent version 2.13
	my $self = shift();
    die "You must instantiate an object to use this function" if !(ref($self));

    return $self->{USER_AGENT};

}

sub xml {
    my $self = shift();
    die "You must instantiate an object to use this function" if !(ref($self));

    #-----------------------------------------------------------------
    # Common heading for all requests
    #-----------------------------------------------------------------
    my $xml =<<ENDXML;
<?xml version="1.0" ?>
<request version="$self->{REQUEST_VERSION}" protocol="$self->{REQUEST_PROTOCOL}" type="$self->{REQUEST_TYPE}">
    <user agent="$self->{USER_AGENT}" ip="$self->{USER_IP}"/>
    <subscriber id="$self->{SUBSCRIBER_ID}" password="$self->{SUBSCRIBER_PASSWORD}"/>
ENDXML


    #-----------------------------------------------------------------
    # If servicelist
    #-----------------------------------------------------------------
    if ($self->isCarrierlist) {
        # Check to see if any options were set for the servicelist
    	if (defined($self->optFields) or defined($self->optType)) {
    		$xml .= "    <option";

			# Set the fields option
			if (defined($self->optFields)) {
                $xml .= ' fields="' . $self->optFields . '"';
            }

            # Set the type option
            if (defined($self->optType)) {
                $xml .= ' type="' . $self->optType . '"';
            }

    		$xml .= "/>";
        }
    }

    #-----------------------------------------------------------------
    # If checkstatus
    #-----------------------------------------------------------------
    elsif ($self->isMsgStatus) {

		# Check to see if any options were set for the sendpage
    	if (defined($self->msgTicketID)) {
    		$xml .= "    <ticket";

			# Set the method option
			if (defined($self->msgTicketID)) {
                $xml .= ' id="' . encode_entity($self->msgTicketID) . '"';
            }

			$xml .= "/>\n";
        }

    }

    #-----------------------------------------------------------------
    # If sendpage
    #-----------------------------------------------------------------
    elsif ($self->isMsg) {

		# Check to see if any options were set for the sendpage
    	if (defined($self->optTimeout) or defined($self->optDelimiter)) {
    		$xml .= "    <option";

			# Set the method option
		    if (defined($self->optMethod)) {
				$xml .= ' method="' . $self->optMethod . '"';
	        }

            # Set the type option
		    if (defined($self->optType)) {
				$xml .= ' type="' . $self->optType . '"';
            }

			# Set the fields option
		    if (defined($self->optFields)) {
				$xml .= ' fields="' . $self->optFields . '"';
            }

			# Set the timeout option
            if (defined($self->optTimeout)) {
                $xml .= ' timeout="' . $self->optTimeout . '"';
            }

    		# Set the delimiter option
            if (defined($self->optDelimiter)) {
                $xml .= ' delimiter="' . encode_entity($self->optDelimiter) . '"';
            }

			$xml .= "/>\n";
        }

        # Check to see if any page items were set for the sendpage

    	if (defined($self->msgCarrierID) or defined($self->msgPin) or defined($self->msgFrom) or defined($self->msgCallback) or defined($self->msgText)) {
    		$xml .= "    <page";


			if (defined($self->msgCarrierID)) {
                $xml .= ' serviceid="' . encode_entity($self->msgCarrierID) . '"';
            }

            if (defined($self->msgPin)) {
                $xml .= ' pin="' . encode_entity($self->msgPin) . '"';
            }

            if (defined($self->msgFrom)) {
                $xml .= ' from="' . encode_entity($self->msgFrom) . '"';
            }

            if (defined($self->msgCallback)) {
                $xml .= ' callback="' . encode_entity($self->msgCallback) . '"';
            }

            if (defined($self->msgText)) {
                $xml .= ' text="' . encode_entity($self->msgText) . '"';
            }

			$xml .= "/>\n";
        }

    }

	#-----------------------------------------------------------------
    # End XML all the same
    #-----------------------------------------------------------------
    $xml .= '</request>';

    return $xml;
}

sub xmlParse {
    my $self = shift();
    die "You must instantiate an object to use this function" if !(ref($self));

    return $self->xmlParseEx($self->xml());
}

sub xmlParseEx {
    my $self = shift();
    die "You must instantiate an object to use this function" if !(ref($self));


    if (@_ ne "1") { die "You must pass XML for this functiont to parse"; }

    $self->{XML_RESPONSE} = shift();

    my $parser = new XML::DOM::Parser;

    # Begin parsing XML post so we can process this transaction
	my $doc = $parser->parsestring ($self->{XML_RESPONSE});

    # Check for <response> element
    my $response = $doc->getElementsByTagName ("response");

    if ($response->getLength() != 1) {
        $doc->dispose();
        $self->raise_error(101);
        return;
    }

    # At this point, the document should be validated
    $response = $doc->getDocumentElement();


    ##################################################################
    # Parse required <response> attributes
    ##################################################################

	#-----------------------------------------------------------------
	# Parse <response> version attribute
        #-----------------------------------------------------------------
	my $response_version = $response->getAttributeNode("version");

    if (!defined($response_version)) {
        $doc->dispose();
        $self->raise_error(103);
        return;
    }

    $self->{RESPONSE_VERSION} = $response_version->getValue();


    #-----------------------------------------------------------------
	# Parse <response> protocol attribute
    #-----------------------------------------------------------------
	my $response_protocol = $response->getAttributeNode("protocol");

    if (!defined($response_protocol)) {
        $doc->dispose();
        $self->raise_error(104);
        return;
    }

    $self->{RESPONSE_PROTOCOL} = $response_protocol->getValue();


    #-----------------------------------------------------------------
	# Parse <response> type attribute
    #-----------------------------------------------------------------
	my $response_type = $response->getAttributeNode("type");

    if (!defined($response_type)) {
        $doc->dispose();
        $self->raise_error(105);
        return;
    }

    my $type = $response_type->getValue();

    if ($type eq "sendpage") {
        $self->{RESPONSE_TYPE} = "sendpage";
    } elsif ($type eq "checkstatus") {
		$self->{RESPONSE_TYPE} = "checkstatus";
    } elsif ($type eq "servicelist") {
		$self->{RESPONSE_TYPE} = "servicelist";
    } else {
        $self->raise_error(106);
        return;
    }

    ##################################################################
    # Parse Errors
    ##################################################################

    my $errors = $doc->getElementsByTagName("error");

    if ($errors->getLength() > 0) {

		my $error = $errors->item(0);

        # Now get attributes for the error element

        #-----------------------------------------------------------------
		# Parse <error> code attribute
        #-----------------------------------------------------------------
		my $error_code = $error->getAttributeNode("code");

	    if (defined($error_code)) {
        	$self->errorCode($error_code->getValue());
	    }

        #-----------------------------------------------------------------
	    # Parse <error> description attribute
	    #-----------------------------------------------------------------
		my $error_dscr = $error->getAttributeNode("description");

	    if (defined($error_dscr)) {
        	$self->errorDesc($error_dscr->getValue());
	    }
	}


    ##################################################################
    # Parse Status
    ##################################################################

    my $stats = $doc->getElementsByTagName("status");

    if ($stats->getLength() > 0) {

		my $status = $stats->item(0);

        # Now get attributes for the error element

            #----------------------------------------------------------------

	    # Parse <status> code attribute
	    #-----------------------------------------------------------------
		my $status_code = $status->getAttributeNode("code");

	    if (defined($status_code)) {
        	$self->status_code($status_code->getValue());
	    }

            #-----------------------------------------------------------------
       	    # Parse <status> description attribute
	    #-----------------------------------------------------------------
		my $status_dscr = $status->getAttributeNode("description");

	    if (defined($status_dscr)) {
        	$self->status_description($status_dscr->getValue());
	    }
	}

    ##################################################################
    # Ticket
    ##################################################################

    my $tickets = $doc->getElementsByTagName("ticket");

    if ($tickets->getLength() > 0) {

		my $ticket = $tickets->item(0);

        # Now get attributes for the error element

        #-----------------------------------------------------------------
		# Parse <ticket> id attribute
	    #-----------------------------------------------------------------
		my $ticket_id = $ticket->getAttributeNode("id");

	    if (defined($ticket_id)) {
        	$self->msgTicketID($ticket_id->getValue());
	    }
	}


    ##################################################################
    # Parse service list return!
    ##################################################################

    my $services = $doc->getElementsByTagName("service");

    # If Services Greater Than 1 Then Reset Service List
    if ($services->getLength() > 0) {
		$self->{SERVICE_LIST} = [];
    }

    for (my $index = 0; $index < $services->getLength(); $index++) {

		my $service = $services->item($index);

        # Construct a hash to put all the services into
        my $s = {};

		my $id = $service->getAttributeNode("id");

	    if (defined($id)) {
        	$s->{ID} = $id->getValue();
	    }

        my $title = $service->getAttributeNode("title");

	    if (defined($title)) {
        	$s->{Title} = $title->getValue();
	    }

        my $subtitle = $service->getAttributeNode("subtitle");

	    if (defined($subtitle)) {
        	$s->{SubTitle} = $subtitle->getValue();
	    }

        my $contenttype = $service->getAttributeNode("contenttype");

	    if (defined($contenttype)) {
        	$s->{ContentType} = $contenttype->getValue();
	    }

        my $pinrequired = $service->getAttributeNode("pinrequired");

	    if (defined($pinrequired)) {
        	$s->{PinRequired} = $pinrequired->getValue();
	    }

        my $pinminlength = $service->getAttributeNode("pinminlength");

	    if (defined($pinminlength)) {
        	$s->{PinMinLength} = $pinminlength->getValue();
	    }

        my $pinmaxlength = $service->getAttributeNode("pinmaxlength");

	    if (defined($pinmaxlength)) {
        	$s->{PinMaxLength} = $pinmaxlength->getValue();
	    }

        my $textrequired = $service->getAttributeNode("textrequired");

	    if (defined($textrequired)) {
        	$s->{TextRequired} = $textrequired->getValue();
	    }

        my $textminlength = $service->getAttributeNode("textminlength");

	    if (defined($textminlength)) {
        	$s->{TextMinLength} = $textminlength->getValue();
	    }

        my $textmaxlength = $service->getAttributeNode("textmaxlength");

	    if (defined($textmaxlength)) {
        	$s->{TextMaxLength} = $textmaxlength->getValue();
	    }

        my $fromrequired = $service->getAttributeNode("fromrequired");

	    if (defined($fromrequired)) {
        	$s->{FromRequired} = $fromrequired->getValue();
	    }

        my $fromminlength = $service->getAttributeNode("fromminlength");

	    if (defined($fromminlength)) {
        	$s->{FromMinLength} = $fromminlength->getValue();
	    }

        my $frommaxlength = $service->getAttributeNode("frommaxlength");

	    if (defined($frommaxlength)) {
        	$s->{FromMaxLength} = $frommaxlength->getValue();
	    }

        my $callbackrequired = $service->getAttributeNode("callbackrequired");

	    if (defined($callbackrequired)) {
        	$s->{CallbackRequired} = $callbackrequired->getValue();
	    }

        my $callbacksupported = $service->getAttributeNode("callbacksupported");

	    if (defined($callbacksupported)) {
        	$s->{CallbackSupported} = $callbacksupported->getValue();
	    }

        my $callbackminlength = $service->getAttributeNode("callbackminlength");

	    if (defined($callbackminlength)) {
        	$s->{CallbackMinLength} = $callbackminlength->getValue();
	    }

        my $callbackmaxlength = $service->getAttributeNode("callbackmaxlength");

	    if (defined($callbackmaxlength)) {
        	$s->{CallbackMaxLength} = $callbackmaxlength->getValue();
	    }

		# New Carrier Recognition Functions
		my $country_code = $service->getAttributeNode("countrycode");

        if (defined($country_code)) {
        	$s->{CountryCode} = $country_code->getValue();
        }

		my $country_name = $service->getAttributeNode("countryname");

        if (defined($country_name)) {
        	$s->{CountryName} = $country_name->getValue();
        }

		my $country_reg = $service->getAttributeNode("countryregion");

		if (defined($country_reg)) {
        	$s->{CountryRegion} = $country_reg->getValue();
    	}

		##############################################################
        # Now push hash onto service_list array
        ##############################################################
		push @{ $self->{SERVICE_LIST} }, $s;
	}
}

######################################################################
#
# PRIVATE FUNCTIONS
#
######################################################################

sub escape {
    shift() if ref($_[0]);
    my $toencode = shift();
    return undef unless defined($toencode);
    $toencode=~s/([^a-zA-Z0-9_.-])/uc sprintf("%%%02x",ord($1))/eg;
    return $toencode;
}

sub encode_entity {
    shift() if ref($_[0]);
    my $toencode = shift();
    return undef unless defined($toencode);
    $toencode =~ s/&/&amp;/g;
    $toencode =~ s/>/&gt;/g;
    $toencode =~ s/</&lt;/g;
    $toencode =~ s/"/&quot;/g;
    return $toencode;
}

sub raise_error {

    my $self = shift();
    my $error = shift();

    $self->errorCode($error);

    # SWITCH
    $_ = $error;
    SWITCH: {

		(/101/) && do {
            $self->errorDesc("Error while parsing response.  Request was sent off.");
	    	last SWITCH;
		};

		(/103/) && do {
            $self->errorDesc("The required version attribute of the response element was not found in the response.");
	    	last SWITCH;
		};

        (/104/) && do {
            $self->errorDesc("The required protocol attribute of the response element was not found in the response.");
	    	last SWITCH;
		};

        (/105/) && do {
            $self->errorDesc("The required type attribute of the response element was not found in the response.");
	    	last SWITCH;
		};

		(/106/) && do {
            $self->errorDesc("The client tool does not know how to handle the type of response.");
	    	last SWITCH;
		};

        (/107/) && do {
            $self->errorDesc("A connection could not be made with the Simplewire network.");
	    	last SWITCH;
		};
    }

}

sub send {
    
	my $self = shift();
    die "You must instantiate an object to use this function" if !(ref($self));

	$self->{REQUEST_TYPE} = shift();
    my $txt = "";
    my %vars = (
		"xml" => $self->xml()
	);

    ##################################################################
    # Create Net::SMS::HTTP Object
    ##################################################################
    my $http = new Net::SMS::HTTP;

    ##################################################################
    # Begin loop for redundancy
    ##################################################################
    my $index = "";
    my $response = undef;

	do {
		do {
	    	##########################################################
            # Create the url to retrieve
            ##########################################################
            my $server_name = $self->{RPC_SERVER_NAME} . $index . "." . $self->{RPC_SERVER_DOMAIN};
			my $full_file = $self->{RPC_PROTOCOL} . $server_name . $self->{RPC_PAGING_URL};

            ##########################################################
            # Request and get response
            ##########################################################
            $http->reset();
            $http->prepare_post(\%vars);
            $response = $http->request($full_file);

            ##########################################################
            # Increment the server number
            ##########################################################
            if ($index eq "") {
				$index = $self->{RPC_FLOOR};
			} else {
				$index++;
			}

		} while ( (defined($response) && $response != 200) && ($index <= $self->{RPC_CEILING}) );

        if (defined($http)) {
			$txt = $http->response();
        } else {
            $txt = "";
        }

	} until ( (defined($txt) && $txt =~ /$self->{RPC_END_RESPONSE}/) || (defined($index) && $index >= $self->{RPC_CEILING}) );

    if (defined($txt) && $txt eq "") {
    	$self->raise_error(107);
        return 0;
	} else {
    	# Cleanup text
    	if (defined($txt)) {
			$txt =~ s/^.*<\?xml/<\?xml/gs;

            #print $txt . "\n";

        	$self->xmlParseEx($txt);
        	return 1;
        } else {
        	$self->raise_error(107);
            return 0;
        }
    }
}

1;
__END__;


######################## User Documentation ##########################


## To format the following user documentation into a more readable
## format, use one of these programs: pod2man; pod2html; pod2text.

=head1 NAME

Net::SMS - Send SMS messages to ANY device.

=head1 SYNOPSIS

Net::SMS is a global short text messaging service interface via the
Internet. It brings you the first and only way to send SMS messages
through one easy interface. SimpleWire has defined an XML SMS standard
and will make numerous tools available for developer's use so that SMS
technology can be better utilized. Currently, this interface supports
more than just SMS enabled devices and can send messages to ANY
protocol.

NOTE that SMS 2.00 is not backwards compatible with 1.00! Don't upgrade
if your scripts are important!!

=head1 QUICK START

use Net::SMS;

# Create a new SMS object
my $sms = Net::SMS->new();

# Setup the SMS message parameters
$sms->msgCarrierID(7);
$sms->msgPin("4152224444");
$sms->msgFrom("Demo");
$sms->msgCallback("3124445555");
$sms->msgText("Hello World from Simplewire!");

# Send the SMS message off
$sms->msgSend();

# Check out what happened
if ($sms->success) {
    print "Message was successfully sent via Simplewire!\n";
} else {
    print "Message was not successfully sent via Simplewire!\n";
    print "Error Code: " . $sms->errorCode . "\n";
    print "Error Description: " . $sms->errorDesc . "\n";
}

=head1 PREREQUISITES

The following packages are required in order to run or even install
Net::SMS.

   * LWP::UserAgent >= 5.47
   * XML::DOM (libxml-enno) >= 1.02

=head1 DESCRIPTION

Net::SMS is the Perl interface to Simplewire's expanding messaging
network. The module interacts with Simlewire's Remote Procedure Calls.
The Remote Procedure Calls provide an XML API and the protocol is open to
all developers. For futher support or questions, you should visit
SimpleWire's website at I<www.simplewire.com>. There you will find
support and documentation including the white paper explaining the
SimpleWire XML API.

=head1 SMS OVERVIEW

SMS stands for short-text messaging service. The current version
of this module takes a minimalist approach to SMS, but upcoming
versions plan to take full advantage of SMS.

A SMS message will require a minimum of 3 to 5 properties to be set within
a request object.  The first property, a I<PIN>, is the Pager
Identification Number.  This is typically the phone number of the device
you are trying to message.  This number does not include a 1 before the area
code and typically looks like 3135551212.  The second property, a I<Service ID>, is
a proprietary service number assigned by Simplewire.  The Carrier ID tells
Simplewire where to route your message.  For example, a Service ID of 7
sends a message to AT&T.  The third property, the I<From> field, is typically
an optional field that is simply the sender's name.  An example would
be "Jack".  The fourth property, the I<Callback> field, is typically
an optional field that is simply the sender's callback number.  An example would
be "3125551212".   The fifth and last property is the I<Text> field.  This is
not optional and is the alphanumeric message you wish to send.  This just
explains the basic properties, but be aware that MANY more properties and
functions exist within the Net::SMS object.

=head1 Net::SMS OVERVIEW

See EXAMPLES section below to see working code.

The first step to using the Net::SMS module is to make sure
LWP:UserAgent and XML::DOM are fully and correctly installed.

Basically, you instantiate a new Net::SMS object via $sms = new Net::SMS
and this object handles communication with the simplewire servers.

=head1 EXAMPLES

All perl scripts or modules that use Net::SMS must include these lines
before the code attempts to access any functions in the Net::SMS package.

    use Net::SMS

After properly including these two modules above, your code is ready to
begin sending a message.  The following code will construct a basic Net::SMS
object and send off a message.

    use Net::SMS

    # Construct a new SMS object
    my $sms = Net::SMS->new();

    # Set the service id.  Check www.simplewire.com for a full listing
    # of the services that are supported.
    $sms->msgCarrierID(2);
    $sms->msgPin("1234567890");
    $sms->msgFrom("Jack Smith");
    $sms->msgCallback("9876543210");
    $sms->msgText("Hello World From Net::SMS");

    # Send the request off.
    $sms->msgSend();

    # Check out what happened.
    if ($sms->success) {
        print "Success!\n";
        print "Error Code: " . $sms->errorCode . "\n";
        print "Error Description: " . $sms->errorDesc . "\n";
        print "Your ticket number is: " . $sms->msgTicketID . "\n";
    } else {
        print "Error occurred!\n";
        print "Error Code: " . $sms->errorCode . "\n";
        print "Error Description: " . $sms->errorDesc . "\n";
    }


The second type of request supported in Net::SMS is a 'servicelist'.
This request will fetch the service list from Simplewire and the associated
service id's for each provider.  This is useful for populating a <select>
box for websites.  The following code will grab the list and set two
optional parameters so that only the information necessary for populating
a <select> box is retrieved from Simplewire.  The code will then print
out some of the results in two different ways.

    use Net::SMS;

    my $sms = Net::SMS->new();

    # Send the request now
    $sms->carrierListSend();
    my @services = $sms->carrierList();

    # Check out what happened.
    if ($sms->success) {
        print "Success!\n";
        print "Error Code: " . $sms->errorCode . "\n";
        print "Error Description: " . $sms->errorDesc . "\n";
    } else {
        print "Error occurred!\n";
        print "Error Code: " . $sms->errorCode . "\n";
        print "Error Description: " . $sms->errorDesc . "\n";
    }

    foreach $ser (@services) {
        print $ser->{ID} . "\n";
    }


The third type of request supported in Net::SMS is a 'checkstatus'.
This request will fetch the status of a previously sent message.  Every
'sendpage' request that passes most error checking will be assigned a ticket.
It is this ticket that needs to be sent thru during a 'checkstatus' request.
The following code example will check the status of a previously sent message.

    use Net::SMS;

    # Note that you will have had to do a sendpage and get a TICKET_ID
    # back for you to check with.

    my $sms = Net::SMS->new();


    # Set the ticket id to check.
    $sms->msgTicketID("XXXXX-3MTWX-28UM0-8H1L7");

    # Request it.
    $sms->msgStatusSend();

    # Check out what happened.
    if ($sms->success) {
        print "Success!\n";
        print "Error Code: " . $sms->errorCode . "\n";
        print "Error Description: " . $sms->errorDesc . "\n";
    } else {
        print "Error occurred!\n";
        print "Error Code: " . $sms->errorCode . "\n";
        print "Error Description: " . $sms->errorDesc . "\n";
    }


Support can also be obtained
by emailing techsupport@simplewire.com.

=head1 SEE ALSO

www.simplewire.com on the web.

=head1 AUTHOR

Simplewire E<lt>techsupport@simplewire.comE<gt>
www.simplewire.com

=head1 COPYRIGHT

Copyright (c) 2001 Simplewire. All rights reserved. This program is free
software; you can redistribute it and/or modify it under the same terms
as Perl itself.

