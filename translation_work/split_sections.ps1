$ErrorActionPreference = "Stop"

$source = "Giannini_I_Beni_Pubblici_final.txt"
$outDir = "translation_work/source_chunks"
New-Item -ItemType Directory -Force -Path $outDir | Out-Null

$lines = Get-Content -LiteralPath $source
$headingPattern = '^(CAPITOLO|Cap\.|Cap,|[0-9]+[\.,] )'
$starts = @()
for ($i = 0; $i -lt $lines.Count; $i++) {
  if ($lines[$i] -match $headingPattern -or $lines[$i] -eq 'INDICE') {
    $starts += $i
  }
}

if ($starts.Count -eq 0 -or $starts[0] -ne 0) {
  $starts = @(0) + $starts
}

for ($s = 0; $s -lt $starts.Count; $s++) {
  $start = $starts[$s]
  $end = if ($s + 1 -lt $starts.Count) { $starts[$s + 1] - 1 } else { $lines.Count - 1 }
  $title = ($lines[$start] -replace '[^\p{L}\p{Nd}]+','_').Trim('_')
  if ([string]::IsNullOrWhiteSpace($title)) { $title = "liminaire" }
  $name = "{0:D3}_{1}.md" -f $s, $title
  $path = Join-Path $outDir $name
  $lines[$start..$end] | Set-Content -LiteralPath $path -Encoding UTF8
}

Write-Output "Created $($starts.Count) source chunks in $outDir"
