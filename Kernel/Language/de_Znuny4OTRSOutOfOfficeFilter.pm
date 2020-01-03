# --
# Copyright (C) 2012-2020 Znuny GmbH, http://znuny.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::de_Znuny4OTRSOutOfOfficeFilter;

use strict;
use warnings;

use utf8;

sub Data {
    my $Self = shift;

    $Self->{Translation}->{'Registers a PostMaster filter module to set the KeepStateHeader.'} = 'Registriert ein PostMaster-Filtermodul, um den KeepStateHeader zu setzen.';
    $Self->{Translation}->{'Defines filters to set the KeepStateHeader.'} = 'Definiert Filter um den KeepStateHeader zu setzen.';

    return 1;
}

1;
