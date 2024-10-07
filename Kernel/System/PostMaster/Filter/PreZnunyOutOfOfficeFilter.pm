# --
# Copyright (C) 2012 Znuny GmbH, https://znuny.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::PostMaster::Filter::PreZnunyOutOfOfficeFilter;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::Config',
);

use Kernel::System::VariableCheck qw(:all);

sub new {
    my ( $Type, %Param ) = @_;

    my $Self = {};
    bless( $Self, $Type );

    $Self->{ParserObject} = $Param{ParserObject} || die "Got no ParserObject!";

    $Self->{Debug} = $Param{Debug} || 0;

    # Get communication log object.
    $Self->{CommunicationLogObject} = $Param{CommunicationLogObject} || die "Got no CommunicationLogObject!";

    # Default Settings
    $Self->{Config} = {};

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    my %Config = %{ $Self->{Config} };
    if ( IsHashRefWithData( $Param{JobConfig} ) ) {
        %Config = %{ $Param{JobConfig} };
    }

    # get KeepStateHeader
    my $KeepStateHeader = $ConfigObject->Get('KeepStateHeader') || 'X-OTRS-FollowUp-State-Keep';

    # get all possible filter
    my $FilterAttributes = $ConfigObject->Get('ZnunyOutOfOfficeFilter')->{Filter} || {};

    # use TempGetParam to lowercase all values
    my %TempGetParam = map { lc $_ => $Param{GetParam}->{$_} } keys %{ $Param{GetParam} };

    FILTER:
    for my $Filter ( @{$FilterAttributes} ) {

        my $MatchedAttribute;
        my $MatchedRegEx;
        for my $Attribute ( sort keys %{$Filter} ) {

            my $AttributeLC = lc($Attribute);
            my $RegEx       = lc( $Filter->{$Attribute} );

            # check if header exists
            next FILTER if !$TempGetParam{$AttributeLC};

            # if header is not true or  not 1, do check value
            if ( $RegEx ne 'true' && $RegEx ne 1 ) {

                # check header value via regex
                next FILTER if $TempGetParam{$AttributeLC} !~ m{$RegEx}i;
            }

            $MatchedAttribute = $AttributeLC;
            $MatchedRegEx     = $RegEx;
        }

        $Param{GetParam}->{$KeepStateHeader} = 1;

        $Self->{CommunicationLogObject}->ObjectLog(
            ObjectLogType => 'Message',
            Priority      => 'Debug',
            Key           => 'Kernel::System::PostMaster::Filter::PreZnunyOutOfOfficeFilter',
            Value => "KeepStateHeader $KeepStateHeader was set. Attribute: $MatchedAttribute | RegEx: $MatchedRegEx",
        );
    }

    # All filters have been checked.
    if ( @{$FilterAttributes} ) {
        $Self->{CommunicationLogObject}->ObjectLog(
            ObjectLogType => 'Message',
            Priority      => 'Debug',
            Key           => 'Kernel::System::PostMaster::Filter::PreZnunyOutOfOfficeFilter',
            Value         => "All filters have been checked.",
        );
    }

    return 1;
}

1;
