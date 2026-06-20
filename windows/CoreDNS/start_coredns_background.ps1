$CoreDNSDir = "C:\Users\tudor\Software\CoreDNS"
$CoreDNSExe = Join-Path $CoreDNSDir "coredns.exe"
$Corefile = Join-Path $CoreDNSDir "Corefile"

$Timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"

$OutLog = "C:\Users\tudor\Documents\CoreDNS_log_$Timestamp.log"
$ErrLog = "C:\Users\tudor\Documents\CoreDNS_error_$Timestamp.log"

Start-Process `
    -FilePath $CoreDNSExe `
    -ArgumentList "-conf `"$Corefile`"" `
    -WorkingDirectory $CoreDNSDir `
    -RedirectStandardOutput $OutLog `
    -RedirectStandardError $ErrLog `
    -WindowStyle Hidden