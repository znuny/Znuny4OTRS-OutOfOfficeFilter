# --
# Copyright (C) 2012-2020 Znuny GmbH, http://znuny.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package var::packagesetup::Znuny4OTRSOutOfOfficeFilter;    ## no critic

use strict;
use warnings;

use utf8;

our @ObjectDependencies = (
    'Kernel::System::ZnunyHelper',
);

use Kernel::System::VariableCheck qw(:all);

=head1 NAME

var::packagesetup::Znuny4OTRSOutOfOfficeFilter - code to execute during package installation

=head1 SYNOPSIS

All code to execute during package installation

=head1 PUBLIC INTERFACE

=head2 new()

create an object

    my $CodeObject    = $Kernel::OM->Get('var::packagesetup::Znuny4OTRSOutOfOfficeFilter');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    my $Self = {};
    bless( $Self, $Type );

    my $ZnunyHelperObject = $Kernel::OM->Get('Kernel::System::ZnunyHelper');

    $ZnunyHelperObject->_RebuildConfig();

    return $Self;
}

=head2 CodeInstall()

run the code install part

    my $Result = $CodeObject->CodeInstall();

=cut

sub CodeInstall {
    my ( $Self, %Param ) = @_;

    my $Success = $Self->_PostmasterXHeaderAdd();

    return 1;
}

=head2 CodeReinstall()

run the code reinstall part

    my $Result = $CodeObject->CodeReinstall();

=cut

sub CodeReinstall {
    my ( $Self, %Param ) = @_;

    $Self->CodeInstall();

    return 1;
}

=head2 CodeUpgrade()

run the code upgrade part

    my $Result = $CodeObject->CodeUpgrade();

=cut

sub CodeUpgrade {
    my ( $Self, %Param ) = @_;

    $Self->CodeInstall();

    return 1;
}

=head2 CodeUninstall()

run the code uninstall part

    my $Result = $CodeObject->CodeUninstall();

=cut

sub CodeUninstall {
    my ( $Self, %Param ) = @_;

    my $Success = $Self->_PostmasterXHeaderRemove();

    return 1;
}

=head2 _PostmasterXHeaderAdd()

Adds PostmasterXHeader.

    my $Success = $Object->_PostmasterXHeaderAdd();

Returns:

    my $Success = 1;

=cut

sub _PostmasterXHeaderAdd {
    my ( $Self, %Param ) = @_;

    my $ZnunyHelperObject = $Kernel::OM->Get('Kernel::System::ZnunyHelper');

    my @PostmasterXHeaders = $Self->_GetPostmasterXHeader();

    my $Success = $ZnunyHelperObject->_PostmasterXHeaderAdd(
        Header => \@PostmasterXHeaders
    );

    return 1;
}

=head2 _PostmasterXHeaderRemove()

Removes PostmasterXHeader.

    my $Success = $Object->_PostmasterXHeaderRemove();

Returns:

    my $Success = 1;

=cut

sub _PostmasterXHeaderRemove {
    my ( $Self, %Param ) = @_;

    my $ZnunyHelperObject = $Kernel::OM->Get('Kernel::System::ZnunyHelper');

    my @PostmasterXHeaders = $Self->_GetPostmasterXHeader();

    my $Success = $ZnunyHelperObject->_PostmasterXHeaderRemove(
        Header => \@PostmasterXHeaders
    );

    return 1;
}

=head2 _GetPostmasterXHeader()

returns new PostmasterXHeader.

    my @PostmasterXHeaders = $Self->_GetPostmasterXHeader();

Returns:

    my @PostmasterXHeaders = [];

=cut

sub _GetPostmasterXHeader {
    my ( $Self, %Param ) = @_;

    my @PostmasterXHeaders = (
        'X-Auto-Response-Suppress',
        'X-MS-Exchange-Inbox-Rules-Loop',
    );

    return @PostmasterXHeaders;
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
