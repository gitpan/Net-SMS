################################################################################
# Copyright (c) 2001 Simplewire. All rights reserved. 
#
# Net::SMS.pm, version 2.40
#
# Simplewire, Inc. grants to Licensee, a non-exclusive, non-transferable,
# royalty-free and limited license to use Licensed Software internally for
# the purposes of evaluation only. No license is granted to Licensee
# for any other purpose. Licensee may not sell, rent, loan or otherwise
# encumber or transfer Licensed Software in whole or in part,
# to any third party.
#
# For more information on this license, please view the License.txt file
# included with your download or visit www.simplewire.com
#
################################################################################

#---------------------------------------------------------------------
# User documentation within and more is in POD format is at end of
# this file.  Search for =head
#---------------------------------------------------------------------

package Net::SMS;

#---------------------------------------------------------------------
# Version Info
#---------------------------------------------------------------------
$Net::SMS::VERSION = '2.40';
require 5.002;

#---------------------------------------------------------------------
# Other module use
#---------------------------------------------------------------------
use strict;
use Unicode::String qw(utf8 latin1 utf16);
use XML::DOM;
use LWP::UserAgent;
use HTTP::Request;
use HTTP::Response;

######################################################################
# Net::SMS->new();
#
######################################################################

sub new
{

    my $that  = shift;
    my $class = ref($that) || $that;
    local $_;
    my %args;

	#-----------------------------------------------------------------
	# Define default package vars
	#-----------------------------------------------------------------

	# Placeholder
	my $self = {	NOTHING		=> 'nothing'	};

    bless($self, $class);

	$self->Reset;

    return $self;
}


sub Reset
{

	# pop value
    my $self = shift();

	# check to make sure that this function is being called on an object
    die "You must instantiate an object to use this function" if !(ref($self));


    #-----------------------------------------------------------------
	# Define default package vars
    #-----------------------------------------------------------------
	$self->{	DEBUG				}	= 0;

	# constants
	$self->{	RT_SENDPAGE			}	= 'sendpage';
	$self->{	RT_CHECKSTATUS		}	= 'checkstatus';
	$self->{	RT_CARRIERLIST		}	= 'servicelist';
	$self->{	OF_SELECTBOX		}	= 'selectbox';
	$self->{	OF_ALL				}	= 'all';
	$self->{	OT_PRODUCTION		}	= 'production';
	$self->{	OT_DEVELOPMENT		}	= 'development';
	$self->{	PROXY_TYPE_HTTP		}	= '1';
#	$self->{	PROXY_TYPE_HTTPS	}	= '2';
#	$self->{	PROXY_TYPE_SOCKS4	}	= '3';
#	$self->{	PROXY_TYPE_SOCKS5	}	= '4';

	$self->{	m_CarrierList		}	= [];
	$self->{	m_ClientStatusCode	}	= -1;
	$self->{	m_ClientStatusDesc	}	= '';
	$self->{	m_ConnectionTimeout	}	= 30;
	$self->{	m_ErrorCode			}	= '';
	$self->{	m_ErrorDesc			}	= 'No transaction with the Simplewire network has occured.';
	$self->{	m_MsgCallback		}	= undef;
	$self->{	m_MsgCarrierID		}	= undef;
	$self->{	m_MsgFrom			}	= undef;
	$self->{	m_MsgImage			}	= undef;
	$self->{	m_MsgImageFilename	}	= undef;
	$self->{	m_MsgPin			}	= undef;
	$self->{	m_MsgRingtone		}	= undef;
	$self->{	m_MsgStatusCode		}	= undef;
	$self->{	m_MsgStatusDesc		}	= undef;
	$self->{	m_MsgText			}	= undef;
	$self->{	m_MsgTicketID		}	= undef;
	$self->{	m_MsgUnicodeText	}	= undef;
	$self->{	m_OptCountryCode	}	= undef;
	$self->{	m_OptDataCoding		}	= undef;
	$self->{	m_OptDelimiter		}	= undef;
	$self->{	m_OptFields			}	= 'all';
	$self->{	m_OptNetworkCode	}	= undef;
	$self->{	m_OptPhone			}	= undef;
	$self->{	m_OptTimeout		}	= 30;
	$self->{	m_OptType			}	= 'production';
	$self->{	m_ProxyPassword		}	= '';
	$self->{	m_ProxyPort			}	= 80;
#	$self->{	m_ProxyRealm		}	= '';
	$self->{	m_ProxyServer		}	= undef;
#	$self->{	m_ProxyType			}	= PROXY_TYPE_HTTP;
	$self->{	m_ProxyUsername		}	= '';
	$self->{	m_RequestProtocol	}	= 'paging';
	$self->{	m_RequestType		}	= '';
	$self->{	m_RequestVersion	}	= '2.0';
	$self->{	m_RequestXML		}	= '';
	$self->{	m_ResponseProtocol	}	= 'paging';
	$self->{	m_ResponseType		}	= '';
	$self->{	m_ResponseVersion	}	= '2.0';
	$self->{	m_ResponseXML		}	= undef;
	$self->{	m_ServerBeginResponse}	= '<?xml version="1.0" ?>';
	$self->{	m_ServerDomain		}	= 'simplewire.com';
	$self->{	m_ServerEndResponse	}	= '</response>';
	$self->{	m_ServerName		}	= 'wmp-test';
	$self->{	m_ServerFile		}	= '/paging/rpc.xml';
	$self->{	m_ServerPort		}	= 80;
	$self->{	m_ServerProtocol	}	= 'http://';
	$self->{	m_SubscriberID		}	= '';
	$self->{	m_SubscriberPassword}	= '';
	$self->{	m_UserAgent			}	= 'Perl/SMS/2.4.0';
	$self->{	m_UserIP			}	= '';
	$self->{	m_XMLVersion		}	= '1.0';

}


sub carrierList
{
	# pop value
    my $self = shift();
	
	# check to make sure that this function is being called on an object
    die "You must instantiate an object to use this function" if !(ref($self));

    return @{ $self->{m_CarrierList} };
}


sub carrierListSend
{
	# pop value
    my $self = shift();
	
	# check to make sure that this function is being called on an object
    die "You must instantiate an object to use this function" if !(ref($self));

    return $self->send('servicelist');
}


sub connectionTimeout
{
	# pop value
    my $self = shift();
	
	# check to make sure that this function is being called on an object
    die "You must instantiate an object to use this function" if !(ref($self));

    if (@_ == 1) { $self->{m_ConnectionTimeout} = shift(); }

    return $self->{m_ConnectionTimeout} if defined($self->{m_ConnectionTimeout}) || return undef;

}


sub debugMode
{
	# pop value
    my $self = shift();
	
	# check to make sure that this function is being called on an object
    die "You must instantiate an object to use this function" if !(ref($self));

    if (@_ == 1) { $self->{DEBUG} = shift(); }

    return $self->{DEBUG} if defined($self->{DEBUG}) || return undef;

}


sub errorCode
{
	# pop value
    my $self = shift();
	
	# check to make sure that this function is being called on an object
    die "You must instantiate an object to use this function" if !(ref($self));

    if (@_ == 1) { $self->{m_ErrorCode} = shift(); }

    return $self->{m_ErrorCode} if defined($self->{m_ErrorCode}) || return undef;

}


sub errorDesc
{
	# pop value
    my $self = shift();
	
	# check to make sure that this function is being called on an object
    die "You must instantiate an object to use this function" if !(ref($self));

    if (@_ == 1) { $self->{m_ErrorDesc} = shift(); }

    return $self->{m_ErrorDesc} if defined($self->{m_ErrorDesc}) || return undef;

}


sub isCarrierlist
{
	# pop value
    my $self = shift();
	
	# check to make sure that this function is being called on an object
    die "You must instantiate an object to use this function" if !(ref($self));

    return 1 if ($self->{m_RequestType} eq "servicelist");
    return 0;

}


sub isMsg
{
	# pop value
    my $self = shift();
	
	# check to make sure that this function is being called on an object
    die "You must instantiate an object to use this function" if !(ref($self));

    return 1 if ($self->{m_RequestType} eq "sendpage");
    return 0;

}


sub isMsgStatus
{
	# pop value
    my $self = shift();
	
	# check to make sure that this function is being called on an object
    die "You must instantiate an object to use this function" if !(ref($self));

    return 1 if ($self->{m_RequestType} eq "checkstatus");
    return 0;

}


sub msgCallback
{
	# pop value
    my $self = shift();
	
	# check to make sure that this function is being called on an object
    die "You must instantiate an object to use this function" if !(ref($self));

	# if parameter list has length == 1, then pop value and set call back.
    if (@_ == 1) { $self->{m_MsgCallback} = shift(); }

    return $self->{m_MsgCallback} if defined($self->{m_MsgCallback}) || return undef;

}


sub msgCarrierID
{
	# pop value
    my $self = shift();
	
	# check to make sure that this function is being called on an object
    die "You must instantiate an object to use this function" if !(ref($self));

    if (@_ == 1) { $self->{m_MsgCarrierID} = shift(); }

    return $self->{m_MsgCarrierID} if defined($self->{m_MsgCarrierID}) || return undef;

}


sub msgCLIIconFilename
{
	# pop value
    my $self = shift();
	
	# check to make sure that this function is being called on an object
    die "You must instantiate an object to use this function" if !(ref($self));

    if (@_ == 1)
	{
		my $file_path = shift();
		my $hexResult = '';
		my $buf;

		open(fh, "< $file_path") || die "Can't open file \"$file_path\"";
		binmode fh;

		while(read fh, $buf, 1)
		{
			$hexResult .= sprintf( "%2.2lX",  ord($buf) );
		}

		close(fh);

		$self->{m_MsgImageFilename} = $file_path;
		$self->{m_MsgImage}	= $hexResult;
		$self->{m_OptType}	=	'icon';
	}

    return $self->{m_MsgImageFilename} if defined($self->{m_MsgImageFilename}) || return undef;

}


sub msgFrom
{
	# pop value
    my $self = shift();
	
	# check to make sure that this function is being called on an object
    die "You must instantiate an object to use this function" if !(ref($self));

    if (@_ == 1) { $self->{m_MsgFrom} = shift(); }

    return $self->{m_MsgFrom} if defined($self->{m_MsgFrom}) || return undef;

}


sub msgOperatorLogoFilename
{
	# pop value
    my $self = shift();
	
	# check to make sure that this function is being called on an object
    die "You must instantiate an object to use this function" if !(ref($self));
	
    if (@_ == 1)
	{
		my $file_path = shift();
		my $hexResult = '';
		my $buf;

		open(fh, "< $file_path") || die "Can't open file \"$file_path\"";
		binmode fh;

		while(read fh, $buf, 1)
		{
			$hexResult .= sprintf( "%2.2lX",  ord($buf) );
		}

		close(fh);

		$self->{m_MsgImageFilename} = $file_path;
		$self->{m_MsgImage}	= $hexResult;
		$self->{m_OptType}	=	'logo';
	}

    return $self->{m_MsgImageFilename} if defined($self->{m_MsgImageFilename}) || return undef;

}


sub msgPictureFilename
{
	# pop value
    my $self = shift();
	
	# check to make sure that this function is being called on an object
    die "You must instantiate an object to use this function" if !(ref($self));

    if (@_ == 1)
	{
		my $file_path = shift();
		my $hexResult = '';
		my $buf;

		open(fh, "< $file_path") || die "Can't open file \"$file_path\"";
		binmode fh;

		while(read fh, $buf, 1)
		{
			$hexResult .= sprintf( "%2.2lX",  ord($buf) );
		}

		close(fh);

		$self->{m_MsgImageFilename} = $file_path;
		$self->{m_MsgImage}	= $hexResult;
		$self->{m_OptType}	=	'picturemessage';
	}

    return $self->{m_MsgImageFilename} if defined($self->{m_MsgImageFilename}) || return undef;

}


sub msgPin
{
	# pop value
    my $self = shift();
	
	# check to make sure that this function is being called on an object
    die "You must instantiate an object to use this function" if !(ref($self));

    if (@_ == 1) { $self->{m_MsgPin} = shift(); }

    return $self->{m_MsgPin} if defined($self->{m_MsgPin}) || return undef;

}


sub msgProfileName
{
	# pop value
    my $self = shift();

	# check to make sure that this function is being called on an object
    die "You must instantiate an object to use this function" if !(ref($self));

    if (@_ == 1)
	{
		$self->{m_MsgText} = shift();
		$self->{m_OptType} = 'profile';
	}

	return $self->{m_MsgText} if defined($self->{m_MsgText}) || return undef;
	
}


sub msgProfileRingtone
{
	# pop value
    my $self = shift();
	
	# check to make sure that this function is being called on an object
    die "You must instantiate an object to use this function" if !(ref($self));

    if (@_ == 1)
	{
		$self->{m_MsgRingtone} = shift();
		$self->{m_OptType}	=	'profile';
	}

    return $self->{m_MsgRingtone} if defined($self->{m_MsgRingtone}) || return undef;

}


sub msgProfileScreenSaverFilename
{
	# pop value
    my $self = shift();
	
	# check to make sure that this function is being called on an object
    die "You must instantiate an object to use this function" if !(ref($self));

    if (@_ == 1)
	{
		my $file_path = shift();
		my $hexResult = '';
		my $buf;

		open(fh, "< $file_path") || die "Can't open file \"$file_path\"";
		binmode fh;

		while(read fh, $buf, 1)
		{
			$hexResult .= sprintf( "%2.2lX",  ord($buf) );
		}

		close(fh);

		$self->{m_MsgImageFilename} = $file_path;
		$self->{m_MsgImage}	= $hexResult;
		$self->{m_OptType}	=	'profile';
	}

    return $self->{m_MsgImageFilename} if defined($self->{m_MsgImageFilename}) || return undef;

}


sub msgRingtone
{
	# pop value
    my $self = shift();
	
	# check to make sure that this function is being called on an object
    die "You must instantiate an object to use this function" if !(ref($self));

    if (@_ == 1)
	{
		$self->{m_MsgRingtone} = shift();
		$self->{m_OptType}	=	'ringtone';
	}

    return $self->{m_MsgRingtone} if defined($self->{m_MsgRingtone}) || return undef;

}


sub msgSend
{
	# pop value
    my $self = shift();
	
	# check to make sure that this function is being called on an object
    die "You must instantiate an object to use this function" if !(ref($self));

    return $self->send('sendpage');
}


sub msgSendEx
{
	# pop value
    my $self = shift();
	
	# check to make sure that this function is being called on an object
    die "You must instantiate an object to use this function" if !(ref($self));

    $self->msgCarrierId(shift());
    $self->msgPin(shift());
    $self->msgFrom(shift());
    $self->msgCallback(shift());
    $self->msgText(shift());

    return $self->send('sendpage');
}


sub msgStatusCode
{
	# pop value
    my $self = shift();
	
	# check to make sure that this function is being called on an object
    die "You must instantiate an object to use this function" if !(ref($self));

    if (@_ == 1) { $self->{m_MsgStatusCode} = shift(); }

    return $self->{m_MsgStatusCode} if defined($self->{m_MsgStatusCode}) || return undef;

}


sub msgStatusDesc
{
	# pop value
    my $self = shift();
	
	# check to make sure that this function is being called on an object
    die "You must instantiate an object to use this function" if !(ref($self));

    if (@_ == 1) { $self->{m_MsgStatusDesc} = shift(); }

    return $self->{m_MsgStatusDesc} if defined($self->{m_MsgStatusDesc}) || return undef;

}


sub msgStatusSend
{
	# pop value
    my $self = shift();
	
	# check to make sure that this function is being called on an object
    die "You must instantiate an object to use this function" if !(ref($self));

    return $self->send('checkstatus');
}


sub msgText
{
	# pop value
    my $self = shift();

	# check to make sure that this function is being called on an object
    die "You must instantiate an object to use this function" if !(ref($self));

    if (@_ == 1) { $self->{m_MsgText} = shift(); }

	return $self->{m_MsgText} if defined($self->{m_MsgText}) || return undef;
	
}


sub msgTicketID
{
	# pop value
    my $self = shift();
	
	# check to make sure that this function is being called on an object
    die "You must instantiate an object to use this function" if !(ref($self));

    if (@_ == 1) { $self->{m_MsgTicketID} = shift(); }

    return $self->{m_MsgTicketID} if defined($self->{m_MsgTicketID}) || return undef;

}


sub optCountryCode
{
	# pop value
    my $self = shift();

	# check to make sure that this function is being called on an object
    die "You must instantiate an object to use this function" if !(ref($self));

    if (@_ == 1) { $self->{m_OptCountryCode} = shift(); }

    return $self->{m_OptCountryCode} if defined($self->{m_OptCountryCode}) || return undef;

}


sub optDataCoding
{
	# pop value
    my $self = shift();
	
	# check to make sure that this function is being called on an object
    die "You must instantiate an object to use this function" if !(ref($self));

    if (@_ == 1) { $self->{m_OptDataCoding} = shift(); }

    return $self->{m_OptDataCoding} if defined($self->{m_OptDataCoding}) || return undef;

}


sub optDelimiter
{
	# pop value
    my $self = shift();

	# check to make sure that this function is being called on an object
    die "You must instantiate an object to use this function" if !(ref($self));

    if (@_ == 1) { $self->{m_OptDelimiter} = shift(); }

    return $self->{m_OptDelimiter} if defined($self->{m_OptDelimiter}) || return undef;

}


sub optFields
{
	# pop value
    my $self = shift();
	
	# check to make sure that this function is being called on an object
    die "You must instantiate an object to use this function" if !(ref($self));

    if (@_ == 1) { $self->{m_OptFields} = shift(); }

    return $self->{m_OptFields} if defined($self->{m_OptFields}) || return undef;

}


sub optNetworkCode
{
	# pop value
    my $self = shift();

	# check to make sure that this function is being called on an object
    die "You must instantiate an object to use this function" if !(ref($self));

    if (@_ == 1) { $self->{m_OptNetworkCode} = shift(); }

    return $self->{m_OptNetworkCode} if defined($self->{m_OptNetworkCode}) || return undef;

}


sub optPhone
{
	# pop value
    my $self = shift();
	
	# check to make sure that this function is being called on an object
    die "You must instantiate an object to use this function" if !(ref($self));

    if (@_ == 1) { $self->{m_OptPhone} = shift(); }

    return $self->{m_OptPhone} if defined($self->{m_OptPhone}) || return undef;

}


sub optTimeout
{
	# pop value
    my $self = shift();
	
	# check to make sure that this function is being called on an object
    die "You must instantiate an object to use this function" if !(ref($self));

    if (@_ == 1) { $self->{m_OptTimeout} = shift(); }

    return $self->{m_OptTimeout} if defined($self->{m_OptTimeout}) || return undef;

}


sub optType
{
	# pop value
    my $self = shift();
	
	# check to make sure that this function is being called on an object
    die "You must instantiate an object to use this function" if !(ref($self));

    if (@_ == 1) { $self->{m_OptType} = shift(); }

    return $self->{m_OptType} if defined($self->{m_OptType}) || return undef;

}


sub requestXML
{
	# pop value
    my $self = shift();
	
	# check to make sure that this function is being called on an object
    die "You must instantiate an object to use this function" if !(ref($self));

    if (@_ == 1) { $self->{m_RequestXML} = shift(); }

    return $self->{m_RequestXML} if defined($self->{m_RequestXML}) || return undef;

}


sub responseXML
{
	# pop value
    my $self = shift();
	
	# check to make sure that this function is being called on an object
    die "You must instantiate an object to use this function" if !(ref($self));

    if (@_ == 1) { $self->{m_ResponseXML} = shift(); }

    return $self->{m_ResponseXML} if defined($self->{m_ResponseXML}) || return undef;

}


sub serverDomain
{
	# pop value
    my $self = shift();
	
	# check to make sure that this function is being called on an object
    die "You must instantiate an object to use this function" if !(ref($self));

    if (@_ == 1) { $self->{m_ServerDomain} = shift(); }

    return $self->{m_ServerDomain} if defined($self->{m_ServerDomain}) || return undef;

}


sub serverName
{
	# pop value
    my $self = shift();
	
	# check to make sure that this function is being called on an object
    die "You must instantiate an object to use this function" if !(ref($self));

    if (@_ == 1) { $self->{m_ServerName} = shift(); }

    return $self->{m_ServerName} if defined($self->{m_ServerName}) || return undef;

}


sub serverPort
{
	# pop value
    my $self = shift();
	
	# check to make sure that this function is being called on an object
    die "You must instantiate an object to use this function" if !(ref($self));

    if (@_ == 1) { $self->{m_ServerPort} = shift(); }

    return $self->{m_ServerPort} if defined($self->{m_ServerPort}) || return undef;

}


sub subscriberID
{
	# pop value
    my $self = shift();
	
	# check to make sure that this function is being called on an object
    die "You must instantiate an object to use this function" if !(ref($self));

    my $var = shift();

    if (defined($var)) { $self->{m_SubscriberID} = $var; }

    return $self->{m_SubscriberID};

}


sub subscriberPassword
{
	# pop value
    my $self = shift();
	
	# check to make sure that this function is being called on an object
    die "You must instantiate an object to use this function" if !(ref($self));

    my $var = shift();

    if (defined($var)) { $self->{m_SubscriberPassword} = $var; }

    return $self->{m_SubscriberPassword};

}


sub success
{
	# pop value
    my $self = shift();
	
	# check to make sure that this function is being called on an object
    die "You must instantiate an object to use this function" if !(ref($self));

    # if the error_code is between 0 and 10 then its an okay response.
    if ($self->errorCode >= 0 and $self->errorCode <= 10 and $self->errorCode ne "")
	{
        return 1;
    }

    return 0;

}


sub synchronous
{
	# Deprecated. Does nothing. Here for backward compatibility.

	# pop value
    my $self = shift();

	# check to make sure that this function is being called on an object
    die "You must instantiate an object to use this function" if !(ref($self));
}


sub userIP
{
	# pop value
    my $self = shift();
	
	# check to make sure that this function is being called on an object
    die "You must instantiate an object to use this function" if !(ref($self));

    my $var = shift();

    if (defined($var)) { $self->{m_UserIP} = $var; }

    return $self->{m_UserIP};

}


sub userAgent
{
    
    # Deprecated userAgent version 2.13

	# pop value
    my $self = shift();
	
	# check to make sure that this function is being called on an object
    die "You must instantiate an object to use this function" if !(ref($self));

    return '';

}


sub	proxyServer
{
	# pop value
    my $self = shift();
	
	# check to make sure that this function is being called on an object
    die "You must instantiate an object to use this function" if !(ref($self));

    if (@_ == 1) { $self->{m_ProxyServer} = shift(); }
	
    return $self->{m_ProxyServer} if defined($self->{m_ProxyServer}) || return undef;
}


sub	proxyPort
{
	# pop value
    my $self = shift();
	
	# check to make sure that this function is being called on an object
    die "You must instantiate an object to use this function" if !(ref($self));

    if (@_ == 1) { $self->{m_ProxyPort} = shift(); }

    return $self->{m_ProxyPort} if defined($self->{m_ProxyPort}) || return undef;
}


sub	proxyUserName
{
	# This is a pass-through function to proxyUsername

	# pop value
    my $self = shift();
	
	# check to make sure that this function is being called on an object
    die "You must instantiate an object to use this function" if !(ref($self));

    if (@_ == 1) { $self->proxyUsername( shift() ); }

    return $self->proxyUsername if defined($self->proxyUsername) || return undef;
}


sub	proxyUsername
{
	# pop value
    my $self = shift();

	# check to make sure that this function is being called on an object
    die "You must instantiate an object to use this function" if !(ref($self));

    if (@_ == 1) { $self->{m_ProxyUsername} = shift(); }

    return $self->{m_ProxyUsername} if defined($self->{m_ProxyUsername}) || return undef;
}


sub	proxyPassword
{
	# pop value
    my $self = shift();
	
	# check to make sure that this function is being called on an object
    die "You must instantiate an object to use this function" if !(ref($self));

    if (@_ == 1) { $self->{m_ProxyPassword} = shift(); }

    return $self->{m_ProxyPassword} if defined($self->{m_ProxyPassword}) || return undef;
}


sub toXML
{
	# pop value
    my $self = shift();

	# check to make sure that this function is being called on an object
    die "You must instantiate an object to use this function" if !(ref($self));

    #-----------------------------------------------------------------
    # Common heading for all requests
    #-----------------------------------------------------------------

    my $xml =<<ENDXML;
<?xml version="$self->{m_XMLVersion}"?>
<request version="$self->{m_RequestVersion}" protocol="$self->{m_RequestProtocol}" type="$self->{m_RequestType}">
    <user agent="$self->{m_UserAgent}" ip="$self->{m_UserIP}"/>
    <subscriber id="$self->{m_SubscriberID}" password="$self->{m_SubscriberPassword}"/>
ENDXML

    #-----------------------------------------------------------------
    # If sendpage
    #-----------------------------------------------------------------
    if ($self->isMsg)
	{

		# Check to see if any options were set for the sendpage
    	if (defined($self->optCountryCode) or defined($self->optDataCoding) or
			defined($self->optDelimiter) or defined($self->optNetworkCode) or
			defined($self->optPhone) or defined($self->optType) )
		{
    		$xml .= "    <option";

			# Set the country code option
		    if (defined($self->optCountryCode))
			{
				$xml .= ' countrycode="' . html_encode( $self->optCountryCode ) . '"';
            }

    		# Set the data coding option
            if (defined($self->optDataCoding))
			{
                $xml .= ' datacoding="' . html_encode( $self->optDataCoding ) . '"';
            }

    		# Set the delimiter option
            if (defined($self->optDelimiter))
			{
                $xml .= ' delimiter="' . html_encode($self->optDelimiter) . '"';
            }

			# Set the network code option
		    if (defined($self->optNetworkCode))
			{
				$xml .= ' networkcode="' . html_encode( $self->optNetworkCode ) . '"';
            }

			# Set the phone type option
		    if (defined($self->optPhone))
			{
				$xml .= ' phone="' . html_encode( $self->optPhone ) . '"';
            }

			# Set the timeout option
            if (defined($self->optTimeout))
			{
                $xml .= ' timeout="' . $self->optTimeout . '"';
            }

            # Set the type option
		    if (defined($self->optType))
			{
				$xml .= ' type="' . html_encode( $self->optType ) . '"';
            }

			$xml .= "/>\n";
        }

        # Check to see if any page items were set for the sendpage

    	if (defined($self->msgCarrierID) or defined($self->msgPin) or
			defined($self->msgFrom) or defined($self->msgCallback) or
			defined($self->msgText) or defined($self->msgRingtone) or
			defined($self->{m_MsgImage}) )
		{
    		$xml .= "    <page";


			if (defined( $self->msgCarrierID))
			{
                $xml .= ' serviceid="' . html_encode( $self->msgCarrierID ) . '"';
            }

            if (defined($self->msgPin))
			{
                $xml .= ' pin="' . html_encode( $self->msgPin ) . '"';
            }

            if (defined($self->msgFrom))
			{
                $xml .= ' from="' . unicode_encode( $self->msgFrom ) . '"';
            }

            if (defined($self->msgCallback))
			{
                $xml .= ' callback="' . html_encode( $self->msgCallback ) . '"';
            }

			if (defined($self->msgText))
			{
				$xml .= ' text="' . unicode_encode( $self->msgText ) . '"';
			}

			if (defined($self->msgRingtone))
			{
				$xml .= ' ringtone="' . html_encode( $self->msgRingtone ) . '"';
			}

			if (defined($self->{m_MsgImage}))
			{
				$xml .= ' image="' . $self->{m_MsgImage} . '"';
			}

			$xml .= "/>\n";
        }

    }

    #-----------------------------------------------------------------
    # If checkstatus
    #-----------------------------------------------------------------
	elsif ($self->isMsgStatus)
	{

		# Check to see if any options were set for the sendpage
    	if (defined($self->msgTicketID))
		{
    		$xml .= "    <ticket";

			# Set the method option
			if (defined($self->msgTicketID))
			{
                $xml .= ' id="' . html_encode($self->msgTicketID) . '"';
            }

			$xml .= "/>\n";
        }

    }

    #-----------------------------------------------------------------
    # If servicelist
    #-----------------------------------------------------------------
	elsif ($self->isCarrierlist)
	{
        # Check to see if any options were set for the servicelist
    	if (defined($self->optFields) or defined($self->optType))
		{
    		$xml .= "    <option";

			# Set the fields option
			if (defined($self->optFields))
			{
                $xml .= ' fields="' . html_encode( $self->optFields ) . '"';
            }

            # Set the type option
            if (defined($self->optType))
			{
                $xml .= ' type="' . html_encode( $self->optType ) . '"';
            }

    		$xml .= "/>";
        }
    }


	#-----------------------------------------------------------------
    # End XML all the same
    #-----------------------------------------------------------------
    $xml .= '</request>';

	$self->{m_RequestXML} = $xml;

	if( $self->{DEBUG} )
	{
		print 'REQUEST XML ==' . "\n" . $self->{m_RequestXML} . "\n";
	}

    return $xml;
}


sub xmlParse
{
	# pop value
    my $self = shift();
	
	# check to make sure that this function is being called on an object
    die "You must instantiate an object to use this function" if !(ref($self));

    return $self->xmlParseEx($self->toXML());
}


sub xmlParseEx
{
	# pop value
    my $self = shift();
	
	# check to make sure that this function is being called on an object
    die "You must instantiate an object to use this function" if !(ref($self));


    if (@_ ne "1") { die "You must pass XML for this functiont to parse"; }

    $self->{ m_ResponseXML } = shift();

	if( $self->{DEBUG})
	{
		print 'RESPONSE XML == ' . "\n" . $self->{ m_ResponseXML } . "\n";
	}

    my $parser = new XML::DOM::Parser;

    # Begin parsing XML post so we can process this transaction
	my $doc = $parser->parsestring ($self->{ m_ResponseXML });

    # Check for <response> element
    my $response = $doc->getElementsByTagName ("response");

    if ($response->getLength() != 1)
	{
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

    if (!defined($response_version))
	{
        $doc->dispose();
        $self->raise_error(102);
        return;
    }

    $self->{m_ResponseVersion} = $response_version->getValue();


    #-----------------------------------------------------------------
	# Parse <response> protocol attribute
    #-----------------------------------------------------------------
	my $response_protocol = $response->getAttributeNode("protocol");

    if (!defined($response_protocol))
	{
        $doc->dispose();
        $self->raise_error(103);
        return;
    }

    $self->{m_ResponseProtocol} = $response_protocol->getValue();


    #-----------------------------------------------------------------
	# Parse <response> type attribute
    #-----------------------------------------------------------------
	my $response_type = $response->getAttributeNode("type");

    if (!defined($response_type))
	{
        $doc->dispose();
        $self->raise_error(104);
        return;
    }

    my $type = $response_type->getValue();
	
    if ($type eq "sendpage")
	{
        $self->{m_ResponseType} = "sendpage";
    }
	elsif ($type eq "checkstatus")
	{
		$self->{m_ResponseType} = "checkstatus";
    }
	elsif ($type eq "servicelist")
	{
		$self->{m_ResponseType} = "servicelist";
    }
	else
	{
		# Do nothing here, so error code and desc can be retrieved.
    }

    ##################################################################
    # Parse Errors
    ##################################################################

    my $errors = $doc->getElementsByTagName("error");

    if ($errors->getLength() > 0)
	{
		my $error = $errors->item(0);

        # Now get attributes for the error element

        #-----------------------------------------------------------------
		# Parse <error> code attribute
        #-----------------------------------------------------------------
		my $error_code = $error->getAttributeNode("code");

	    if (defined($error_code))
		{
        	$self->errorCode($error_code->getValue());
	    }

        #-----------------------------------------------------------------
	    # Parse <error> description attribute
	    #-----------------------------------------------------------------
		my $error_desc = $error->getAttributeNode("description");

	    if (defined($error_desc))
		{
        	$self->errorDesc($error_desc->getValue());
	    }
	}


    ##################################################################
    # Parse Status
    ##################################################################

    my $stats = $doc->getElementsByTagName("status");

    if ($stats->getLength() > 0)
	{

		my $status = $stats->item(0);

        # Now get attributes for the status element

            #----------------------------------------------------------------

	    # Parse <status> code attribute
	    #-----------------------------------------------------------------
		my $status_code = $status->getAttributeNode("code");

	    if (defined($status_code))
		{
        	$self->msgStatusCode($status_code->getValue());
	    }

		#-----------------------------------------------------------------
		# Parse <status> description attribute
		#-----------------------------------------------------------------
		my $status_desc = $status->getAttributeNode("description");

	    if (defined($status_desc))
		{
        	$self->msgStatusDesc($status_desc->getValue());
	    }
	}

    ##################################################################
    # Ticket
    ##################################################################

    my $tickets = $doc->getElementsByTagName("ticket");

    if ($tickets->getLength() > 0)
	{

		my $ticket = $tickets->item(0);

        # Now get attributes for the error element

        #-----------------------------------------------------------------
		# Parse <ticket> id attribute
	    #-----------------------------------------------------------------
		my $ticket_id = $ticket->getAttributeNode("id");

	    if (defined($ticket_id))
		{
        	$self->msgTicketID($ticket_id->getValue());
	    }
	}


    ##################################################################
    # Parse service list return!
    ##################################################################

    my $services = $doc->getElementsByTagName("service");

    # If Services Greater Than 1 Then Reset Service List
    if ($services->getLength() > 0)
	{
		$self->{m_CarrierList} = [];
    }

    for (my $index = 0; $index < $services->getLength(); $index++)
	{
		my $service = $services->item($index);

        # Construct a hash to put all the services into
        my $s = {};

		my $id = $service->getAttributeNode("id");

	    if (defined($id))
		{
        	$s->{ID} = $id->getValue();
	    }

        my $title = $service->getAttributeNode("title");

	    if (defined($title))
		{
        	$s->{Title} = $title->getValue();
	    }

        my $subtitle = $service->getAttributeNode("subtitle");

	    if (defined($subtitle))
		{
        	$s->{SubTitle} = $subtitle->getValue();
	    }

        my $contenttype = $service->getAttributeNode("contenttype");

	    if (defined($contenttype))
		{
        	$s->{ContentType} = $contenttype->getValue();
	    }

        my $pinrequired = $service->getAttributeNode("pinrequired");

	    if (defined($pinrequired))
		{
        	$s->{PinRequired} = $pinrequired->getValue();
	    }

        my $pinminlength = $service->getAttributeNode("pinminlength");

	    if (defined($pinminlength))
		{
        	$s->{PinMinLength} = $pinminlength->getValue();
	    }

        my $pinmaxlength = $service->getAttributeNode("pinmaxlength");

	    if (defined($pinmaxlength))
		{
        	$s->{PinMaxLength} = $pinmaxlength->getValue();
	    }

        my $textrequired = $service->getAttributeNode("textrequired");

	    if (defined($textrequired))
		{
        	$s->{TextRequired} = $textrequired->getValue();
	    }

        my $textminlength = $service->getAttributeNode("textminlength");

	    if (defined($textminlength))
		{
        	$s->{TextMinLength} = $textminlength->getValue();
	    }

        my $textmaxlength = $service->getAttributeNode("textmaxlength");

	    if (defined($textmaxlength))
		{
        	$s->{TextMaxLength} = $textmaxlength->getValue();
	    }

        my $fromrequired = $service->getAttributeNode("fromrequired");

	    if (defined($fromrequired))
		{
        	$s->{FromRequired} = $fromrequired->getValue();
	    }

        my $fromminlength = $service->getAttributeNode("fromminlength");

	    if (defined($fromminlength))
		{
        	$s->{FromMinLength} = $fromminlength->getValue();
	    }

        my $frommaxlength = $service->getAttributeNode("frommaxlength");

	    if (defined($frommaxlength))
		{
        	$s->{FromMaxLength} = $frommaxlength->getValue();
	    }

        my $callbackrequired = $service->getAttributeNode("callbackrequired");

	    if (defined($callbackrequired))
		{
        	$s->{CallbackRequired} = $callbackrequired->getValue();
	    }

        my $callbacksupported = $service->getAttributeNode("callbacksupported");

	    if (defined($callbacksupported))
		{
        	$s->{CallbackSupported} = $callbacksupported->getValue();
	    }

        my $callbackminlength = $service->getAttributeNode("callbackminlength");

	    if (defined($callbackminlength))
		{
        	$s->{CallbackMinLength} = $callbackminlength->getValue();
	    }

        my $callbackmaxlength = $service->getAttributeNode("callbackmaxlength");

	    if (defined($callbackmaxlength))
		{
        	$s->{CallbackMaxLength} = $callbackmaxlength->getValue();
	    }

        my $type = $service->getAttributeNode("type");

	    if (defined($type))
		{
        	$s->{Type} = $type->getValue();
	    }
		
        my $smartmsg = $service->getAttributeNode("smartmsg");

	    if (defined($smartmsg))
		{
        	$s->{SmartMsg} = $smartmsg->getValue();
	    }
		

		# New Carrier Recognition Functions
		my $country_code = $service->getAttributeNode("countrycode");

        if (defined($country_code))
		{
        	$s->{CountryCode} = $country_code->getValue();
        }

		my $country_name = $service->getAttributeNode("countryname");

        if (defined($country_name))
		{
        	$s->{CountryName} = $country_name->getValue();
        }

		my $country_reg = $service->getAttributeNode("countryregion");

		if (defined($country_reg))
		{
        	$s->{CountryRegion} = $country_reg->getValue();
    	}

		##############################################################
        # Now push hash onto service_list array
        ##############################################################
		push @{ $self->{m_CarrierList} }, $s;
	}

	if($self->{DEBUG})
	{
		print 'XMLParseEx @exit:' . "\n";
		print "Client Status Code: $self->{m_ClientStatusCode}\n";
		print "Client Status Desc: $self->{m_ClientStatusDesc}\n";
		print "ErrorCode == " . $self->errorCode . "\n";
		print "ErrorDesc == " . $self->errorDesc . "\n\n";
	}

}

######################################################################
#
# PRIVATE FUNCTIONS
#
######################################################################

sub escape
{
    shift() if ref($_[0]);
    my $toencode = shift();
    return undef unless defined($toencode);
    $toencode=~s/([^a-zA-Z0-9_.-])/uc sprintf("%%%02x",ord($1))/eg;
    return $toencode;
}


sub html_encode
{
    shift() if ref($_[0]);
    my $toencode = shift();
    return undef unless defined($toencode);

    $toencode =~ s/</&lt;/g;
    $toencode =~ s/>/&gt;/g;
    $toencode =~ s/&/&amp;/g;
    $toencode =~ s/"/&quot;/g;
    $toencode =~ s/'/&apos;/g;

    return $toencode;
}


sub unicode_encode
{
    shift() if ref($_[0]);
    my $toencode = shift();
    return undef unless defined($toencode);

	Unicode::String->stringify_as("utf8");
	my $unicode_str = Unicode::String->new();
	my $text_str = "";
	my $pack_str = "";


	# encode Perl UTF-8 string into latin1 Unicode::String
	#  - currently only Basic Latin and Latin 1 Supplement
	#    are supported here due to issues with Unicode::String .
	$unicode_str->latin1( $toencode );

	# Convert to hex format ("U+XXXX U+XXXX ")
	$text_str = $unicode_str->hex;

	# Now, the interesting part.
	# We must search for the (now hex-encoded)
	#	Simplewire Unicode escape sequence.
	my $pattern = 'U\+005[C|c] U\+0058 U\+00([0-9A-Fa-f])([0-9A-Fa-f]) U\+00([0-9A-Fa-f])([0-9A-Fa-f]) U\+00([0-9A-Fa-f])([0-9A-Fa-f]) U\+00([0-9A-Fa-f])([0-9A-Fa-f])';


	# Replace Simplewire escapes with entities (beginning of string)
	$_ = $text_str;
	if( /^$pattern/ )
	{
		$pack_str = pack "H8", "$1$2$3$4$5$6$7$8";
		$text_str =~ s/^$pattern/\&#x$pack_str/;
	}

	# Replace Simplewire escapes with entities (middle of string)
	$_ = $text_str;
	while( / $pattern/ )
	{
		$pack_str = pack "H8", "$1$2$3$4$5$6$7$8";
		$text_str =~ s/ $pattern/\;\&#x$pack_str/;
		$_ = $text_str;
	}


	# Replace "U+"  with "&#x"	(beginning of string)
	$text_str =~ s/^U\+/&#x/ ;

	# Replace " U+" with ";&#x"	(middle of string)
	$text_str =~ s/ U\+/;&#x/g ;


	# Append ";" to end of string to close last entity.
	# This last ";" at the end of the string isn't necessary in most parsers.
	# However, it is included anyways to ensure full compatibility.
	if( $text_str ne "" )
	{
		$text_str .= ';';
	}

    return $text_str;
}


sub handle_http_error
{
	my $self = shift();
	my $http_error = shift();

	my $errorLookup = 
	{
		#HTTP       Simplewire
		#ERROR      ERROR
		#---------------------
		400		=>	251,
		401		=>	252,
		402		=>	253,
		403		=>	254,
		404		=>	255,
		405		=>	256,
		406		=>	257,
		407		=>	258,
		408		=>	259,
		409		=>	260,
		410		=>	261,
		411		=>	262,
		412		=>	263,
		413		=>	264,
		414		=>	265,
		415		=>	266,

		500		=>	267,
		501		=>	268,
		502		=>	269,
		503		=>	270,
		504		=>	271,
		505		=>	272,
	};

	# check if it was anything but success codes
	if( $http_error >= 200 && $http_error < 300 )
	{
		# return that no error was found
		$self->raise_error( 0 );
		return 0;
	}

	# Check if valid http error number
	if(  defined( $errorLookup->{$http_error} )  )
	{
		# valid http error number, so set Simplewire error
		$self->raise_error( $errorLookup->{$http_error} );
		return 1;
	}
	
	# At this point, we know that the error is not a success code
	# Nor is it an http error on our list of http errors, so return 0
	# 	- no http error.
	return 0;
}

sub raise_error
{

    my $self = shift();
    my $error = shift();

    $self->errorCode($error);
	
	my $errorLookup = 
	{
		# Processing Error Codes
		0		=>	"Success.",
		1		=>	"Processing request.",
		2		=>	"Successfully queued.",

		# Client/Internet Error Codes
		101		=>	"Error while parsing response.  Request was sent off.",
		102		=>	"The required version attribute of the response element was not found in the response.",
		103		=>	"The required protocol attribute of the response element was not found in the response.",
		104		=>	"The required type attribute of the response element was not found in the response.",
		105		=>	"The client tool does not know how to handle the type of response.",
		106		=>	"A connection could not be established with the Simplewire network.",
		107		=>	"Internet The connection timed out.",
		108		=>	"Internet An internal error occured while connecting.",
		109		=>	"Internet Trying to use an invalid URL.",
		110		=>	"Internet The host name could not be resolved.",
		111		=>	"Internet The specified protocol is not supported.",
		112		=>	"Internet An error occured while authenticating.",
		113		=>	"Internet An error occured while logging on.",
		114		=>	"Internet An invalid operation was attempted.",
		115		=>	"Internet The request is pending.",
		116		=>	"Internet An error occured while processing the proxy request.",
		117		=>	"Internet SOCKS server returned an invalid version.",
		118		=>	"Internet SOCKS error while connecting.",
		119		=>	"Internet SOCKS authentication error.",
		120		=>	"Internet SOCKS general error.",
		121		=>	"Internet Proxy authentication error.",
		122		=>	"Internet The proxy host name could not be resolved.",
		123		=>	"Internet An error occured while transfering data.",

		# HTTP Errors
		250		=>	"HTTP Error.",
		251		=>	"HTTP Bad request.",					# 400
		252		=>	"HTTP Unauthorized.",					# 401
		253		=>	"HTTP Payment required.",				# 402
		254		=>	"HTTP Forbidden.",						# 403
		255		=>	"HTTP Not found.",						# 404
		256		=>	"HTTP Method not allowed.",				# 405
		257		=>	"HTTP Not acceptable.",					# 406
		258		=>	"HTTP Proxy authentication required.",	# 407
		259		=>	"HTTP Request timeout.",				# 408
		260		=>	"HTTP Conflict.",						# 409
		261		=>	"HTTP Gone.",							# 410
		262		=>	"HTTP Length required.",				# 411
		263		=>	"HTTP Precondition failed.",			# 412
		264		=>	"HTTP Request Entity too large.",		# 413
		265		=>	"HTTP Request-URI too long.",			# 414
		266		=>	"HTTP Unsupported media type.",			# 415
		267		=>	"HTTP Internal server error.",			# 500
		268		=>	"HTTP Not implemented.",				# 501
		269		=>	"HTTP Bad gateway.",					# 502
		270		=>	"HTTP Service unavailable.",			# 503
		271		=>	"HTTP Gateway timeout.",				# 504
		272		=>	"HTTP Version not supported.",			# 505

		# Validation Error Codes
		301		=>	"Only 1 top-level request element is allowed.",
		302		=>	"The XML document could not be validated.",
		303		=>	"The required version attribute of the request element was not found in the request.",
		304		=>	"The required protocol attribute of the request element was not found in the request.",
		305		=>	"The required type attribute of the request element was not found in the request.",
		306		=>	"The XML parameter for rpc.html cannot be empty.",
		307		=>	"The request was an ill-formed XML document.",
		310		=>	"If the force option is going to be set, it can only be set to a 1 or 0.",
		311		=>	"If the method option is going to be set, it can only be set to 'synch' or 'asynch'.",
		320		=>	"The paging protocol does not know how to handle this type of request.  Please check the type in the request element.",
		321		=>	"Invalid request version.",
		322		=>	"Invalid request protocol.",
		330		=>	"A request of type 'sendpage' requires at least one <page> element to be submitted.",
		331		=>	"The Simplewire alias was invalid.",
		332		=>	"The Simplewire alias has not yet been validated.",
		340		=>	"A serviceid attribute must exist within the <page> element.",
		341		=>	"The serviceid does not exist.",
		342		=>	"A serviceid is required and it cannot be an empty attribute.",
		343		=>	"The service associated with this serviceid has been discontinued.",
		344		=>	"The service associated with this serviceid is currently in development stages.",
		350		=>	"A PIN is required.",
		351		=>	"The PIN is not long enough.",
		352		=>	"The PIN is too long.",
		353		=>	"Message text is required.",
		354		=>	"The total message text is not long enough.",
		355		=>	"The total message text is too long.",
		356		=>	"The from field is required.",
		357		=>	"The from field is not long enough.",
		358		=>	"The from field is too long.",
		359		=>	"A callback number is required.",
		360		=>	"The callback number is not long enough.",
		361		=>	"The callback number is too long.",

		400		=>	"Service returned a general error while sending the page.",
		401		=>	"Service returned a general error while sending the page.",
		410		=>	"Invalid Pager Identification Number (PIN).   The phone number, or PIN, is not a valid subscriber of this service.",

		700		=>	"At least one ticket element must be submitted for a checkstatus request.",
		701		=>	"The required id attribute of the ticket element was not found in the request.",
		710		=>	"Incorrectly formatted ticket id.",
		711		=>	"Ticket id does not exist for any transaction.",
		712		=>	"A ticket id cannot be an empty string.",

		800		=>	"At least one service element must be submitted for a servicelist request.",
		801		=>	"General error while retrieving the service list.",
		802		=>	"The required id attribute of the service element was not found in the request.",
		803		=>	"A service id cannot be an empty string.  A * will retrieve all the services.",

		1000	=>	"General error while handling request.",

		# Subscriber Error Codes
		2001	=>	"Invalid subscription authentication.",
		2002	=>	"The subscription has been de-activated.",
		2003	=>	"The subscription has been removed.",

		# Network Operator Error Codes
		3001	=>	"The access or terminal number was not found.",
		3010	=>	"The message recipient does not subscribe to the Sprint PCS Wireless Web Messaging Service on his or her phone.",
		3011	=>	"The recipient's phone number is not for a Sprint PCS Phone.",
		3012	=>	"The callback telephone number contains non-numeric characters.",
		3020	=>	"The intended recipient has not subscribed to the Web Page Messaging feature.",
	};


	# Check if valid error number
	if(  defined( $errorLookup->{$error} )  )
	{
		# valid error number, so set error description
		$self->errorDesc( $errorLookup->{$error} );
	}
	else
	{
		# invalid error number, so set general error
		$self->errorCode( 106 );
		$self->errorDesc( $errorLookup->{106} );
	}
	
}


sub prepare_post
{
	my $self = shift();
	my $varref = shift();

	my $body = "";
	# cycle through all key/value pairs and add to content
	while (my ($var,$value) = map { escape($_) } each %$varref)
	{
		if ($body)
		{
			$body .= "&$var=$value";
		}
		else
		{
			$body = "$var=$value";
		}

	}

	# return newly formed content
	return $body;
}



sub send
{
	# pop value
    my $self = shift();
	
	# check to make sure that this function is being called on an object
    die "You must instantiate an object to use this function" if !(ref($self));

	$self->{m_RequestType} = shift();
    my $txt = "";
    my %vars = (
		"xml" => $self->toXML()
	);


    ##################################################################
    # Create LWP::UserAgent Object
    ##################################################################
	my $http = new LWP::UserAgent;
	$http->timeout( $self->connectionTimeout );
	$http->agent( $self->{m_UserAgent} . ' ' . $http->agent );
	if( defined( $self->{m_ProxyServer} ) )
	{
		$http->proxy('http' ,
				$self->{m_ServerProtocol} . $self->proxyServer . ':' . $self->proxyPort . '/');
	}

	
    ##################################################################
    # Begin loop for redundancy
    ##################################################################
	my $httpErrorEvent = undef;
	
	# Create a request
	my $request = undef;
	
	my $response = undef;

	my $body = undef;
	
   	##########################################################
	# Create the url to retrieve
	##########################################################
	my $server_name = $self->serverName . "." . $self->serverDomain . ":" . $self->serverPort;
	my $full_file = $self->{m_ServerProtocol} . $server_name . $self->{m_ServerFile};

	##########################################################
	# Request and get response
	##########################################################


	$body = $self->prepare_post(\%vars);

	# Finish setting up request
	$request = new HTTP::Request( POST => $full_file);
	$request->content_type("application/x-www-form-urlencoded");
	$request->content($body);
	$request->header( 'Accept' => 'text/xml' );
	$request->proxy_authorization_basic(	$self->proxyUsername,
											$self->proxyPassword );


	# send off request and get response
	$response = $http->request($request);


	$self->{m_ClientStatusCode} = $response->code;
	$self->{m_ClientStatusDesc} = $response->message;

	if( $self->handle_http_error( $self->{m_ClientStatusCode} ) )
	{
		$httpErrorEvent = 1;
	}

	if ( $self->{DEBUG} && defined( $self->proxyServer ) && $response->is_success )
	{
		print "Successful Proxy\n";
	}
	elsif( $self->{DEBUG} && defined( $self->proxyServer ) )
	{
		print "Failed Proxy\n";
	}


	if ( defined($response) && defined($response->content) )
	{
		$txt = $response->content;
	}
	else
	{
		$txt = "";
	}


	if($self->{DEBUG})
	{
		#print "@ SEND\n";
		#print "Client Status Code: $self->{m_ClientStatusCode}\n";
		#print "Client Status Desc: $self->{m_ClientStatusDesc}\n";
		#print "m_ErrorCode == " . $self->errorCode . "\n";
		#print "m_ErrorDesc == " . $self->errorDesc . "\n";
	}


	# now, check for errors, special cases. Parse response.
	# Check for HTTP Error
	if ( defined($httpErrorEvent) )
	{
		# do nothing. Http error codes were already set.
		return 0;
	}
	elsif (defined($txt) && $txt eq "")
	{
    	$self->raise_error(106);
        return 0;
	}
	# Now parse the xml
	else
	{
    	# Cleanup text
    	if (defined($txt))
		{
			$txt =~ s/^.*<\?xml/<\?xml/gs;

        	$self->xmlParseEx($txt);
        	return 1;
        }
		else
		{
        	# Problem, set general error. Return fail.
			$self->raise_error(106);
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

Net::SMS - Sends wireless messages anywhere regardless of carrier.

=head1 SYNOPSIS

The Perl SMS SDK provides easy, high-level control of the Simplewire wireless
text-messaging platform. The Perl SMS SDK was designed to be
as developer-friendly as possible by hiding the intricacies of the XML format
required to communicate with the Simplewire WMP (Wireless Message Protocol)
servers. The Perl SMS SDK makes it possible to send an SMS message off with
as little as two lines of code.

This software is commercially supported. Go to www.simplewire.com
for more information.

=head1 INSTALLATION

Place the release file in the root directory. In the root directory, execute
the following commands, where "X.XX" represents the specific version being used.

[root]# tar -zxvf Net-SMS-X.XX.tar.gz

[root]# cd Net-SMS-X.XX

[Net-SMS-X.XX]# perl Makefile.PL

[Net-SMS-X.XX]# make

[Net-SMS-X.XX]# make install


=head1 QUICK START


use Net::SMS;

# Create New SMS object
my $r = Net::SMS->new();

# Subscriber properties
$r->subscriberID( '123-456-789-12345' );
$r->subscriberPassword( 'Password Goes Here' );

# Message properties
$r->msgPin( "+1 100 510 1234" );
$r->msgFrom( "Demo" );
$r->msgCallback( "+1 100 555 1212" );
$r->msgText( "Hello World from Simplewire!" );

# Send Message
print "Submitting message To Simplewire...\n";
$r->msgSend();

# Check For Errors
if ($r->success)
{
    print "Message was successfully sent via Simplewire!\n";
}
else
{
    print "Message was not successfully sent via Simplewire!\n";
    print "Error Code: " . $r->errorCode . "\n";
    print "Error Description: " . $r->errorDesc . "\n";
}

=head1 EXAMPLES

See the examples folder.

=head1 UNICODE

For Unicode characters in the range 0x00 to 0xFF, you can use the
Perl hexadecimal escape sequence.

Format: \x##

Backslash + Lowercase 'x' + Two Hex Digits

Example: $r->msgText( "Uppercase Z: \x5A" );


For Unicode characters in the range 0x0000 to 0xFFFF, Simplewire provides
its own escape sequence. This is only for use with the msgFrom and msgText
methods.

Format: \\X####

Backslash + Backslash + Uppercase 'X' + Four Hex Digits

Example: $r->msgText( "Smiley Face: \\X263A" );


Note: Both sequences can be used in the same string.
	Example: $r->msgText( "Degree Sign: \xB0   \n   Tilde: \\X007E" );


=head1 SEE ALSO

/Net-SMS-X.XX/examples/

/Net-SMS-X.XX/docs/sw-doc-manual-perl-2.4.0.pdf

www.simplewire.com on the web.

=head1 AUTHOR

Simplewire E<lt>support@simplewire.comE<gt>
www.simplewire.com

=head1 COPYRIGHT

Copyright (c) 2001 Simplewire. All rights reserved. This program is free
software; you can redistribute it and/or modify it under the same terms
as Perl itself.

