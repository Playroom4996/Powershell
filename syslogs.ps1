# Define recipient email address
$recipientEmail = "your.email@example.com"

# Define an array of Event IDs to filter
$eventIDs = @(4740, 4672, 4625, 4704, 11707, 11724)

# Get events from the Security log
$securityEvents = Get-WinEvent -LogName Security -FilterHashtable @{ ID = $eventIDs } -ErrorAction SilentlyContinue

# Get events from the Application log
$applicationEvents = Get-WinEvent -LogName Application -FilterHashtable @{ ID = $eventIDs } -ErrorAction SilentlyContinue

# Combine the events from both logs
$allEvents = $securityEvents + $applicationEvents

# Initialize an empty string to store event details for email
$emailBody = ""

# Output the events and construct email body
foreach ($event in $allEvents) {
    $eventData = @{
        'EventID' = $event.Id
        'Timestamp' = $event.TimeCreated
        'Provider' = $event.ProviderName
        'Message' = $event.Message
    }
    $emailBody += ($eventData | Out-String)
}

# Check if there are any events found
if ($emailBody -ne "") {
    # Send email
    $subject = "Event Log Report"
    $smtpServer = "smtp.example.com"  # Specify your SMTP server
    $from = "your.email@example.com"
    $body = "Events found in the logs:`n`n$emailBody"
    Send-MailMessage -SmtpServer $smtpServer -From $from -To $recipientEmail -Subject $subject -Body $body
}
