Param (

    [io.DirectoryInfo]
    $ProjectPath = (property ProjectPath $BuildRoot),

    [string]
    $BuildOutput = (property BuildOutput 'C:\BuildOutput'),

    [string]
    $LineSeparation = (property LineSeparation ('-' * 78))
)

task Clean {
    $LineSeparation
    "`t`t`t CLEAN UP"
    $LineSeparation

    if (![io.path]::IsPathRooted($BuildOutput)) {
        $BuildOutput = Join-Path -Path $ProjectPath.FullName -ChildPath $BuildOutput
    }
    if (Test-Path $BuildOutput) {
        "Removing $BuildOutput\*"
        Get-ChildItem .\BuildOutput\ -Exclude modules, README.md | Remove-Item -Force -Recurse
    }

}

task CleanModule {
    if (![io.path]::IsPathRooted($BuildOutput)) {
        $BuildOutput = Join-Path -Path $ProjectPath.FullName -ChildPath $BuildOutput
    }
    "Removing $BuildOutput\*"
    Get-ChildItem .\BuildOutput\ | Remove-Item -Force -Recurse -Verbose -ErrorAction Stop
}
