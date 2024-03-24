$ErrorActionPreference = "Stop"
# Enable TLSv1.2 for compatibility with older clients
[Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12

$CommonURLPart = 'MAS/All-In-One-Version/MAS_AIO-CRC32_9AE8AFBA.cmd'
$DownloadURL1 = 'https://raw.githubusercontent.com/ubsefor/mas/master/MAS/All-In-One-Version/MAS_AIO-CRC32_9AE8AFBA.cmd'

$rand = Get-Random -Maximum 99999999
$isAdmin = [bool]([Security.Principal.WindowsIdentity]::GetCurrent().Groups -match 'S-1-5-32-544')
$FilePath = if ($isAdmin) { "$env:SystemRoot\Temp\MAS_$rand.cmd" } else { "$env:TEMP\MAS_$rand.cmd" }

$RandomURL = Get-Random -InputObject $DownloadURL1, $DownloadURL2

try {
    $response = Invoke-WebRequest -Uri $RandomURL -UseBasicParsing
}
catch {
    $response = Invoke-WebRequest -Uri $DownloadURL3 -UseBasicParsing
}

$ScriptArgs = "$args "
$prefix = "@:: $rand `r`n"
$content = $prefix + $response
Set-Content -Path $FilePath -Value $content

Start-Process $FilePath $ScriptArgs -Wait

$FilePaths = @("$env:TEMP\MAS*.cmd", "$env:SystemRoot\Temp\MAS*.cmd")
foreach ($FilePath in $FilePaths) { Get-Item $FilePath | Remove-Item }
