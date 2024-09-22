# Powershell script for creating Map Addons. For backup purpose.
[console]::BackgroundColor = 'Black'
Clear-Host

$root = "E:/Program Files/Steam/steamapps/common/GarrysMod"
$addons = "$root/garrysmod/addons/test"
$gmad = "$root/bin/win64/gmad.exe"
$build = "./.build"

############
# Function #
############
function Write-Message {
  param(
    [string]$Object,
    [string]$Color = 'Green',
    [string]$Header = 'INFO',
    [switch]$NoNewline = $false
  )
  Write-Host -NoNewline -ForegroundColor $Color "$Header "
  if ($NoNewline) {
    Write-Host $Object -NoNewline
  } else {
    Write-Host $Object
  }
}

function New-GMA {
  param([string]$dir, [string]$dst = $addons)
  $lower = ($dir -replace '[\s\t]', '_').ToLower() -replace '[^a-z0-9_]', ''
  if (-Not (Test-Path -Path $dst)) {
    New-Item -Path $dst -ItemType Directory | Out-Null
  }
  if (-Not (Test-Path -Path $build)) {
    New-Item -Path $build -ItemType Directory | Out-Null
  }
  $gmaName = "$build/$lower.gma"
  $cmd = "create -folder `"$dir`" -out `"$gmaName`""
  $proc = Start-Process -NoNewWindow -Wait -FilePath $gmad -ArgumentList $cmd -PassThru
  if ($proc.ExitCode -eq 0) {
    Copy-Item -Force -Path $gmaName -Destination $dst
    Write-Message "Copied '$gmaName' to '$dst'"
  } else {
    Write-Message 'Failed to compile GMA' -Color Red -Header ERROR
  }
}

########
# Body #
########
if (-Not (Test-Path -Path $root)) {
  Write-Message 'GMod is not installed.' -Color Red -Header ERROR
  [void][System.Console]::ReadKey($false)
  exit 1
}

$dirs = Get-ChildItem -Directory | Where-Object { $_.Name -notmatch '^\.' }
$maxWidth = ($dirs.Count).ToString().Length
Write-Host 'What do you want to build?'
Write-Host '[A] All Directories'
for ($i = 0; $i -lt $dirs.Count; $i++) {
  $fmt = ($i + 1).ToString().PadLeft($maxWidth)
  Write-Host ("[{0}] {1}" -f $fmt, $dirs[$i].Name)
}
$choice = Read-Host 'Choice'
#$choice = [int]$choice

if ($choice -match '^[aA]$') {
  Write-Host 'You selected: All Directories'
  foreach ($dir in $dirs) {
    New-GMA $dir.Name
  }
} elseif ($choice -match '^\d+$' -and [int]$choice -le $dirs.Count -and [int]$choice -gt 0) {
  $sel = $dirs[[int]$choice - 1].Name
  Write-Message "You selected: $sel"
  New-GMA $sel
} else {
  Write-Message 'Invalid selection. Please run the script again.' -Color Red -Header 'ERROR'
}

Write-Host 'Press any key to continue...'
[void][System.Console]::ReadKey($false)
