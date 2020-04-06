# Funktionalität

Dieses Paket verhindert, dass automatische Antworten auf Tickets den Ticketstatus verändern. Dies kann z.B. passieren, wenn nach dem Versand einer E-Mail eine automatische Abwesenheitsmeldung zurückgeschickt wird.

Dazu wird der E-Mail-Header X-OTRS-FollowUp-State-Keep gesetzt, sofern einer der konfigurierten Filter passt (siehe Konfiguration).
