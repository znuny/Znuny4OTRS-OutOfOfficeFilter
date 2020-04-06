# Konfiguration

## __Znuny4OTRSOutOfOfficeFilter###Filter__
Definiert Filter, um den E-Mail-Header X-OTRS-FollowUp-State-Keep zu setzen. Diese können mit weiteren Headern (Schlüssel) erweitert werden. Der Parameter (Inhalt) wird als regulärer Ausdruck interpretiert.

### Standard-Einstellungen des Filters

#### 1. Filter
```
X-Auto-Response-Suppress       = All
X-MS-Exchange-Inbox-Rules-Loop = 1
```
#### 2. Filter
```
Auto-Submitted = Vacation
```

#### 3. Filter
```
Auto-Submitted = auto-replied;\sowner-email=
```

#### 4. Filter
```
Auto-Submitted = auto-replied
Subject        = Vacation
```
