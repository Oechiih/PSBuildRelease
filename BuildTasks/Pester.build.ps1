param (
    [parameter()]
    [io.DirectoryInfo]
    $ProjectPath = (property ProjectPath $BuildRoot),

    [parameter()]
    [string[]]
    $ExcludedTag = (property ExcludedTags 'alpha')
)

task Test {
    $pathsToCover = @()
    $filters = "$ProjectPath\Classes\*.ps1", "$ProjectPath\Private\*.ps1", "$ProjectPath\Public\*.ps1"

    foreach ($filter in $filters) {
        if (Test-Path $_) {
            $pathsToCover += $filter
        }
    }

    $pesterArgs = @{
        PassThru     = $true
        PesterOption = @{
            IncludeVSCodeMarker = $true
        }
        ExcludeTag   = $ExcludedTag
        CodeCoverage = $pathsToCover
    }

    if ($host.Version -gt [system.version]"6.0") {
        $pesterArgs["ExcludeTag"] += "DesktopOnly"
    } else {
        $pesterArgs["ExcludeTag"] += "CoreOnly"
    }

    [void] $pesterArgs.Add('OutputFormat', 'NUnitXml')
    [void] $pesterArgs.Add('OutputFile', "$ProjectPath\TEST-Results.xml")

    [void] $pesterArgs.Add('CodeCoverageOutputFileFormat', 'JaCoCo')
    [void] $pesterArgs.Add('CodeCoverageOutputFile', "$ProjectPath\Coverage-$($host.Version).xml")

    $result = Invoke-Pester @pesterArgs
    if ($result.FailedCount -gt 0) {
        Write-Error -Message 'One or more tests failed!'
    }
}

task RunbookTest {
    $pathsToCover = @("$ProjectPath\*.ps1")

    $pesterArgs = @{
        PassThru     = $true
        PesterOption = @{
            IncludeVSCodeMarker = $true
        }
        ExcludeTag   = @('alpha')
        CodeCoverage = $pathsToCover
    }

    if ($host.Version -gt [system.version]"6.0") {
        $pesterArgs["ExcludeTag"] += "DesktopOnly"
    } else {
        $pesterArgs["ExcludeTag"] += "CoreOnly"
    }

    [void] $pesterArgs.Add('OutputFormat', 'NUnitXml')
    [void] $pesterArgs.Add('OutputFile', "$ProjectPath\TEST-Results.xml")

    [void] $pesterArgs.Add('CodeCoverageOutputFileFormat', 'JaCoCo')
    [void] $pesterArgs.Add('CodeCoverageOutputFile', "$ProjectPath\Coverage-$($host.Version).xml")

    $result = Invoke-Pester @pesterArgs
    if ($result.FailedCount -gt 0) {
        Write-Error -Message 'One or more tests failed!'
    }
}
