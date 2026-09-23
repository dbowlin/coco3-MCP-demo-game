# Rebuild disks/BONEWALK.DSK using ToolShed decb.
# Uses a temp cwd so paths have no drive-letter colon (decb Windows quirk).
$ErrorActionPreference = "Stop"
$root = Resolve-Path (Join-Path $PSScriptRoot "..")
$decbCandidates = @(
  "D:\MCP\LOCAL_RUN\toolshed\decb.exe",
  (Get-Command decb -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Source)
)
$decb = $decbCandidates | Where-Object { $_ -and (Test-Path $_) } | Select-Object -First 1
if (-not $decb) { throw "decb.exe not found (ToolShed)" }

python (Join-Path $root "tools\mk_fastput_bin.py")

$work = Join-Path $env:TEMP "bonewalk_dsk_build"
New-Item -ItemType Directory -Force -Path $work | Out-Null
Push-Location $work
try {
  Copy-Item (Join-Path $root "src\BONEWALK.BAS") .\BONEWALK.BAS -Force
  Copy-Item (Join-Path $root "bin\FASTPUT.BIN") .\FASTPUT.BIN -Force
  & $decb dskini -3 bonewalk.dsk
  if ($LASTEXITCODE -ne 0) { throw "dskini failed" }
  & $decb copy -t BONEWALK.BAS "bonewalk.dsk,BONEWALK.BAS"
  if ($LASTEXITCODE -ne 0) { throw "copy BAS failed" }
  & $decb copy -2 -b FASTPUT.BIN "bonewalk.dsk,FASTPUT.BIN"
  if ($LASTEXITCODE -ne 0) { throw "copy BIN failed (need -2 -b for ML)" }
  & $decb dir bonewalk.dsk
  New-Item -ItemType Directory -Force -Path (Join-Path $root "disks") | Out-Null
  Copy-Item bonewalk.dsk (Join-Path $root "disks\BONEWALK.DSK") -Force
} finally {
  Pop-Location
}
Write-Host "Wrote $($root)\disks\BONEWALK.DSK"
