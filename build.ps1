param ([string]$Argument)

[console]::BackgroundColor = 'Black'
Clear-Host

$root = "E:/Program Files/Steam/steamapps/common/GarrysMod"
$addons = "$root/garrysmod/addons"
$addons_test = "$addons/test"
$addons_private = "$addons/private"
$build = "./.build"

# gmad will be decided later!

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

function Show-Prompt {
  Write-Host 'What do you want to build?'
  Write-Host '[1] Dark Mode'
  Write-Host '[2] Fix Map'
  Write-Host '[3] Kill Feed'
  Write-Host '[4] Lua Menu'
  Write-Host '[5] Private Reserve'
  Write-Host '[6] SC Resistance Turrets'
  Write-Host '[7] SC Tools'
  Write-Host '[8] SC Weapons'
  $choice = Read-Host 'Choice'
  switch ($choice.ToUpper()) {
    "1" { return 'Dark Mode' }
    "2" { return 'Fix Map' }
    "3" { return 'Kill Feed' }
    "4" { return 'Lua Menu' }
    "5" { return 'Private Reserve' }
    "6" { return 'SC Resistance Turrets' }
    "7" { return 'SC Tools' }
    "8" { return 'SC Weapons' }
    default { return $null }
  }
}

function Copy-Recursive {
  param([string]$src, [string]$dst)
  if (-Not (Test-Path -Path $src)) {
    Write-Message "Source directory does not exist: $src" -Color Red -Header ERROR
    return
  }
  if (-Not (Test-Path -Path $dst)) {
    New-Item -Path $dst -ItemType Directory | Out-Null
  }
  Copy-Item -Recurse -Force -Path "$src\*" -Destination $dst | Out-Null
  Write-Message "Copied contents of '$src' to '$dst'"
}

function New-GMA {
  param([string]$dir, [string]$dst = $addons_test)
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

$gmad_64 = "$root/bin/win64/gmad.exe"
$gmad_32 = "$root/bin/gmad.exe"

$gmad = $gmad_32
if (Test-Path $gmad_64) {
  $gmad = $gmad_64
  Write-Message "This script will use 64bit version of gmad.exe"
} else {
  $gmad = $gmad_32
  Write-Message "This script will use 32bit version of gmad.exe"
}

if ([string]::IsNullOrEmpty($Argument)) {
  $target = Show-Prompt
} else {
  $target = Resolve-Target $Argument
}
Write-Host "target: $target"
if ($null -eq $target) {
  Write-Message 'Invalid choice or argument!' -Color Red -Header ERROR
  [void][System.Console]::ReadKey($false)
  exit 1
}

switch ($target) {
  'Dark Mode' {
    Copy-Recursive 'Dark Mode' "$addons/DarkMode"
  }
  'Fix Map' {
    New-GMA 'Fix Map'
  }
  'Kill Feed' {
    New-GMA 'Kill Feed' $addons_private
  }
  'Lua Menu' {
    Copy-Recursive 'Lua Menu' "$root/garrysmod"
  }
  'Private Reserve' {
    New-GMA 'Private Reserve' $addons_private
  }
  default {
    New-GMA $target
  }
}

Write-Host 'Press any key to continue...'
[void][System.Console]::ReadKey($false)
