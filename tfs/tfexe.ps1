$vsc = (Get-ChildItem env:).Name | Select-String -Pattern 'VS.*.0COMNTOOLS' | Select-Object -Last 1
if ($vsc) {
    $tfexe = Get-ChildItem env: | Where { $_ -and $_.Name -eq $vsc } | Foreach { "$($_.Value)..\IDE\TF.EXE" } | Resolve-Path
    New-Alias tf $tfexe
}