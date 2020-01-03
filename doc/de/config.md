# Konfiguration

## Filter
`Znuny4OTRSOutOfOfficeFilter###Filter`
Definiert Filter um den KeepStateHeader zu setzen. Diese können mit weiteren Headern (Schlüssel) erweitert werden, der Parameter (Key) wird als RegEx interpretiert.


Standard-Einstellung des Filters.

**1 Filter**  
``X-Auto-Response-Suppress       = All``  
``X-MS-Exchange-Inbox-Rules-Loop = 1``

**2 Filter**  
``Auto-Submitted = Vacation``

**3 Filter**  
``Auto-Submitted = auto-replied;\sowner-email=``

**4 Filter**  
``Auto-Submitted = auto-replied``  
``Subject        = Vacation``