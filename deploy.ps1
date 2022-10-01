function Copy-Filtered {
    param (
        [string] $Source,
        [string] $Target,
        [string[]] $Filter
    )
    $ResolvedSource = Resolve-Path $Source
    $NormalizedSource = $ResolvedSource.Path.TrimEnd([IO.Path]::DirectorySeparatorChar) + [IO.Path]::DirectorySeparatorChar
    Get-ChildItem $Source -Include $Filter -Recurse | ForEach-Object {
        $RelativeItemSource = $_.FullName.Replace($NormalizedSource, '')
        $ItemTarget = Join-Path $Target $RelativeItemSource
        $ItemTargetDir = Split-Path $ItemTarget
        if (!(Test-Path $ItemTargetDir)) {
            [void](New-Item $ItemTargetDir -Type Directory)
        }
        Copy-Item $_.FullName $ItemTarget
    }
}

$deployExts = @( "*.lua"; "*.xml"; "*.toc"; "*.blp" );
$target = "E:\World of Warcraft\_classic_\Interface\AddOns\XIVMod";

if (Test-Path $target) {
    Remove-Item $target -Recurse -Force;
}

if (-not (Test-Path $target)) {
    New-Item $target -ItemType Directory
}

Copy-Filtered -Source .\XIVMod -Target $target -Filter $deployExts