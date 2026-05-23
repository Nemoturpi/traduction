$ErrorActionPreference = "Stop"

$chunkDir = "translation_work/translated_chunks"
$outDir = "translation_work/output"
$outFile = Join-Path $outDir "document_fr.md"
New-Item -ItemType Directory -Force -Path $outDir | Out-Null

$files = Get-ChildItem -LiteralPath $chunkDir -Filter "*.md" | Sort-Object Name
$content = foreach ($file in $files) {
  Get-Content -LiteralPath $file.FullName
  ""
}

$content | Set-Content -LiteralPath $outFile -Encoding UTF8
Write-Output "Assembled $($files.Count) translated chunks into $outFile"
