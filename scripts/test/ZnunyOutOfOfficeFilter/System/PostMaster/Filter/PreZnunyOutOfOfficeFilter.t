# --
# Copyright (C) 2012 Znuny GmbH, https://znuny.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));
use Kernel::System::PostMaster;
use Kernel::System::VariableCheck qw(:all);

$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);

my $ConfigObject        = $Kernel::OM->Get('Kernel::Config');
my $HelperObject        = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my $UnitTestEmailObject = $Kernel::OM->Get('Kernel::System::UnitTest::Email');
my $TicketObject        = $Kernel::OM->Get('Kernel::System::Ticket');

# The additional headers of this package are only scanned by the PostMaster if they are
# part of PostmasterX-Header. This is done by the package setup, which might not have run yet.
my @PostmasterXHeaders     = @{ $ConfigObject->Get('PostmasterX-Header') };
my %PostmasterXHeaderAdded = map { $_ => 1 } @PostmasterXHeaders;

HEADER:
for my $Header ( 'X-Auto-Response-Suppress', 'X-MS-Exchange-Inbox-Rules-Loop' ) {
    next HEADER if $PostmasterXHeaderAdded{$Header};
    push @PostmasterXHeaders, $Header;
}

$HelperObject->ConfigSettingChange(
    Valid => 1,
    Key   => 'PostmasterX-Header',
    Value => \@PostmasterXHeaders,
);

my $InitialState = 'closed successful';

my $TicketID = $HelperObject->TicketCreate(
    State => $InitialState,
);

my %Ticket = $TicketObject->TicketGet(
    TicketID => $TicketID,
    UserID   => 1,
);

my $Subject = $TicketObject->TicketSubjectBuild(
    TicketNumber => $Ticket{TicketNumber},
    Subject      => '',
);

my @Tests = (
    {
        Name => 'X-Auto-Response-Suppress and X-MS-Exchange-Inbox-Rules-L',
        Data => {
            Email => <<EOF,
From: Znuny <info\@znuny.de>
To: Znuny <info\@znuny.de>
Subject: $Subject X-Auto-Response-Suppress and X-MS-Exchange-Inbox-Rules-Loop
X-Auto-Response-Suppress: All
X-MS-Exchange-Inbox-Rules-Loop: 123

Znuny-OutOfOfficeFilter Content
EOF
        },
        ExpectedResult => {
            State          => 'closed successful',
            CheckMailState => 2,
        },
    },
    {
        Name => 'Auto-Submitted Vacation',
        Data => {
            Email => <<EOF,
From: Znuny <info\@znuny.de>
To: Znuny <info\@znuny.de>
Subject: $Subject Auto-Submitted - Vacation
Auto-Submitted: Vacation

Znuny-OutOfOfficeFilter Content
EOF
        },
        ExpectedResult => {
            State          => 'closed successful',
            CheckMailState => 2,
        },
    },
    {
        Name => 'Auto-Submitted auto-replied;\sowner-email=',
        Data => {
            Email => <<EOF,
From: Znuny <info\@znuny.de>
To: Znuny <info\@znuny.de>
Subject: $Subject
Auto-Submitted: auto-replied; owner-email=

Znuny-OutOfOfficeFilter Content
EOF
        },
        ExpectedResult => {
            State          => 'closed successful',
            CheckMailState => 2,
        },
    },
    {
        Name => 'Auto-Submitted auto-replied - Subject Vacation',
        Data => {
            Email => <<EOF,
From: Znuny <info\@znuny.de>
To: Znuny <info\@znuny.de>
Subject: $Subject Vacation
Auto-Submitted: auto-replied

Znuny-OutOfOfficeFilter Content
EOF
        },
        ExpectedResult => {
            State          => 'closed successful',
            CheckMailState => 2,
        },
    },
    {
        Name => 'Reopen via FollowUp',
        Data => {
            Email => <<EOF,
From: Znuny <info\@znuny.de>
To: Znuny <info\@znuny.de>
Subject: $Subject

Znuny-OutOfOfficeFilter Content
EOF
        },
        ExpectedResult => {
            State          => 'open',
            CheckMailState => 2,
        },
    },
);

for my $Test (@Tests) {

    $UnitTestEmailObject->MailBackendSetup();
    $UnitTestEmailObject->MailCleanup();

    $Self->True(
        $Test->{Name},
        "Start Test: $Test->{Name}",
    );

    # Every test needs the same starting point because a previous follow-up might have
    # changed the state of the ticket.
    my $StateSet = $TicketObject->TicketStateSet(
        TicketID => $TicketID,
        State    => $InitialState,
        UserID   => 1,
    );

    $Self->True(
        $StateSet,
        "$Test->{Name} - Ticket state reset to '$InitialState'",
    );

    my $CommunicationLogObject = $Kernel::OM->Create(
        'Kernel::System::CommunicationLog',
        ObjectParams => {
            Transport => 'Email',
            Direction => 'Incoming',
        },
    );
    $CommunicationLogObject->ObjectLogStart( ObjectLogType => 'Message' );

    my $PostMasterObject = Kernel::System::PostMaster->new(
        CommunicationLogObject => $CommunicationLogObject,
        Email                  => \$Test->{Data}->{Email},
    );

    my @Result = $PostMasterObject->Run();

    my $FollowUpTicketID = $Result[1];

    # new/clear ticket object
    $Kernel::OM->ObjectsDiscard( Objects => ['Kernel::System::Ticket'] );
    $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

    my %Ticket = $TicketObject->TicketGet(
        TicketID => $FollowUpTicketID,
    );

    $Self->Is(
        $Result[0],
        $Test->{ExpectedResult}->{CheckMailState},
        "$Test->{Name} Run() - CheckMailState",
    );
    $Self->Is(
        $Ticket{State},
        $Test->{ExpectedResult}->{State},
        "$Test->{Name} Run() - State after FollowUp",
    );

}

1;
