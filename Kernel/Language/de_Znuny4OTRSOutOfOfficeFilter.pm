# --
# Copyright (C) 2012-2019 Znuny GmbH, http://znuny.com/
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

    $Self->{Translation}->{'Registers a PostMaster filter module that todo.'} = 'Registers a PostMaster filter module that todo.';
    $Self->{Translation}->{'todo'} = 'todo';

    return 1;
}

1;
