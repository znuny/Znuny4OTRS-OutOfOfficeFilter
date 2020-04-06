# Configuration

## __Znuny4OTRSOutOfOfficeFilter###Filter__
Defines filters to set the e-mail header X-OTRS-FollowUp-State-Keep. These can be extended with further headers (key). The parameter (content) is interpreted as a regular expression.

### Default settings of the filter

#### 1st filter
```
X-Auto-Response-Suppress = All
X-MS Exchange Inbox Rules Loop = 1
```
#### 2nd filter
```
Auto-Submitted = Vacation
```

#### 3rd filter
```
Auto-Submitted = auto-replied;\sowner-email=
```

#### 4th filter
```
Auto-Submitted = auto-replied
Subject = Vacation
```
