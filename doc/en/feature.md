# Functionality

This package prevents changing the ticket status by automatic e-mails. This can happen, for example, if an out-of-office message is returned after an e-mail is sent.

For this purpose, the e-mail header X-OTRS-FollowUp-State-Keep is set, if one of the  configured filters matches (see Configuration).
