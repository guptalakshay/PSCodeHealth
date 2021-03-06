# Separate tests file to force Pester to cleanup its Mock table and avoid this error :
# Internal error detected:  Mock for '63f5f595-6121-429f-bf3f-8633bbaf7057' in module 'PSCodeHealth' was called, but does not exist in the mock table. At C:\Program Files\WindowsPowerShell\Modules\Pester\4.0.3\Functions\Mock.ps1:940 char:9
$ModuleName = 'PSCodeHealth'
Import-Module "$PSScriptRoot\..\..\..\$ModuleName\$($ModuleName).psd1" -Force

Describe 'Invoke-PSCodeHealth (again)' {

    $InitialLocation = $PWD.ProviderPath
    AfterEach {
        Set-Location $InitialLocation
    }

    InModuleScope $ModuleName {

        $Mocks = ConvertFrom-Json (Get-Content -Path "$($PSScriptRoot)\..\..\TestData\MockObjects.json" -Raw )
        Copy-Item -Path (Get-ChildItem -Path "$($PSScriptRoot)\..\..\TestData\" -Filter '*.psm1').FullName -Destination TestDrive:\
            
        Context 'Get-PowerShellFile returns 2 files and TestsPath parameter is specified' {

            $Result = Invoke-PSCodeHealth -Path $TestDrive -TestsPath $TestDrive

            It 'Should return an object with the expected property "ReportTitle"' {
                $Result.ReportTitle | Should Be (Get-Item -Path $TestDrive).Name
            }
            It 'Should return an object with the expected property "ReportDate"' {
                $Result.ReportDate | Should Match '^\d{4}\-\d{2}\-\d{2}\s\d{2}'
            }
            It 'Should return an object with the expected property "AnalyzedPath"' {
                $Result.AnalyzedPath | Should Be $TestDrive.ToString()
            }
            It 'Should return an object with the expected property "Files"' {
                $Result.Files | Should Be 2
            }
            It 'Should return an object with the expected property "Functions"' {
                $Result.Functions | Should Be 4
            }
            It 'Should return an object with the expected property "LinesOfCodeTotal"' {
                $Result.LinesOfCodeTotal | Should Be 40
            }
            It 'Should return an object with the expected property "LinesOfCodeAverage"' {
                $Result.LinesOfCodeAverage | Should Be 10
            }
            It 'Should return an object with the expected property "ScriptAnalyzerFindingsTotal"' {
                $Result.ScriptAnalyzerFindingsTotal | Should Be 1
            }
            It 'Should return an object with the expected property "ScriptAnalyzerErrors"' {
                $Result.ScriptAnalyzerErrors | Should Be 0
            }
            It 'Should return an object with the expected property "ScriptAnalyzerWarnings"' {
                $Result.ScriptAnalyzerWarnings | Should Be 1
            }
            It 'Should return an object with the expected property "ScriptAnalyzerInformation"' {
                $Result.ScriptAnalyzerInformation | Should Be 0
            }
            It 'Should return an object with the expected property "ScriptAnalyzerFindingsAverage"' {
                $Result.ScriptAnalyzerFindingsAverage | Should Be 0.25
            }
            It 'Should return an object with the expected property "FunctionsWithoutHelp"' {
                $Result.FunctionsWithoutHelp | Should Be 1
            }
            It 'Should return an object with the expected property "NumberOfTests"' {
                $Result.NumberOfTests | Should Be 0
            }
            It 'Should return an object with the expected property "NumberOfFailedTests"' {
                $Result.NumberOfFailedTests | Should Be 0
            }
            It 'Should return an object with the expected property "NumberOfPassedTests"' {
                $Result.NumberOfPassedTests | Should Be 0
            }
            It 'Should return an object with the expected property "TestsPassRate"' {
                $Result.TestsPassRate | Should Be 0
            }
            It 'Should return an object with the expected property "TestCoverage"' {
                $Result.TestCoverage | Should Be 0
            }
            It 'Should return an object with the expected property "CommandsMissedTotal"' {
                $Result.CommandsMissedTotal | Should Be 3
            }
            It 'Should return an object with the expected property "ComplexityAverage"' {
                $Result.ComplexityAverage | Should Be 1
            }
            It 'Should return an object with the expected property "ComplexityHighest"' {
                $Result.ComplexityHighest | Should Be 1
            }
            It 'Should return an object with the expected property "NestingDepthAverage"' {
                $Result.NestingDepthAverage | Should Be 0.75
            }
            It 'Should return an object with the expected property "NestingDepthHighest"' {
                $Result.NestingDepthHighest | Should Be 1
            }
            It 'Should return 2 objects in the property "FunctionHealthRecords"' {
                $Result.FunctionHealthRecords.Count | Should Be 4
            }
            It 'Should return only [PSCodeHealth.Function.HealthRecord] objects in the property "FunctionHealthRecords"' {
                $ResultTypeNames = ($Result.FunctionHealthRecords | Get-Member).TypeName
                Foreach ( $TypeName in $ResultTypeNames ) {
                    $TypeName | Should Be 'PSCodeHealth.Function.HealthRecord'
                }
            }
        }
        Context 'The value for the Path parameter is a file' {

            $Result = Invoke-PSCodeHealth -Path "$TestDrive\2PublicFunctions.psm1"

            It 'Should return an object of the type [PSCodeHealth.Overall.HealthReport]' {
                $Result | Should BeOfType [PSCustomObject]
                ($Result | Get-Member).TypeName[0] | Should Be 'PSCodeHealth.Overall.HealthReport'
            }
            It 'Should return an object with the expected property "ReportTitle"' {
                $Result.ReportTitle | Should Be '2PublicFunctions.psm1'
            }
            It 'Should return an object with the expected property "ReportDate"' {
                $Result.ReportDate | Should Match '^\d{4}\-\d{2}\-\d{2}\s\d{2}'
            }
            It 'Should return an object with the expected property "AnalyzedPath"' {
                $Result.AnalyzedPath | Should Be "$TestDrive\2PublicFunctions.psm1"
            }
            It 'Should return an object with the expected property "Files"' {
                $Result.Files | Should Be 1
            }
            It 'Should return an object with the expected property "Functions"' {
                $Result.Functions | Should Be 2
            }
            It 'Should return an object with the expected property "LinesOfCodeTotal"' {
                $Result.LinesOfCodeTotal | Should Be 31
            }
            It 'Should return an object with the expected property "LinesOfCodeAverage"' {
                $Result.LinesOfCodeAverage | Should Be 15.5
            }
            It 'Should return an object with the expected property "ScriptAnalyzerFindingsTotal"' {
                $Result.ScriptAnalyzerFindingsTotal | Should Be 1
            }
            It 'Should return an object with the expected property "ScriptAnalyzerErrors"' {
                $Result.ScriptAnalyzerErrors | Should Be 0
            }
            It 'Should return an object with the expected property "ScriptAnalyzerWarnings"' {
                $Result.ScriptAnalyzerWarnings | Should Be 1
            }
            It 'Should return an object with the expected property "ScriptAnalyzerInformation"' {
                $Result.ScriptAnalyzerInformation | Should Be 0
            }
            It 'Should return an object with the expected property "ScriptAnalyzerFindingsAverage"' {
                $Result.ScriptAnalyzerFindingsAverage | Should Be 0.5
            }
            It 'Should return an object with the expected property "FunctionsWithoutHelp"' {
                $Result.FunctionsWithoutHelp | Should Be 0
            }
            It 'Should return an object with the expected property "NumberOfTests"' {
                $Result.NumberOfTests | Should Be 0
            }
            It 'Should return an object with the expected property "NumberOfFailedTests"' {
                $Result.NumberOfFailedTests | Should Be 0
            }
            It 'Should return an object with the expected property "NumberOfPassedTests"' {
                $Result.NumberOfPassedTests | Should Be 0
            }
            It 'Should return an object with the expected property "TestsPassRate"' {
                $Result.TestsPassRate | Should Be 0
            }
            It 'Should return an object with the expected property "TestCoverage"' {
                $Result.TestCoverage | Should Be 0
            }
            It 'Should return an object with the expected property "CommandsMissedTotal"' {
                $Result.CommandsMissedTotal | Should Be 1
            }
            It 'Should return an object with the expected property "ComplexityAverage"' {
                $Result.ComplexityAverage | Should Be 1
            }
            It 'Should return an object with the expected property "ComplexityHighest"' {
                $Result.ComplexityHighest | Should Be 1
            }
            It 'Should return an object with the expected property "NestingDepthAverage"' {
                $Result.NestingDepthAverage | Should Be 1
            }
            It 'Should return an object with the expected property "NestingDepthHighest"' {
                $Result.NestingDepthHighest | Should Be 1
            }
            It 'Should return 2 objects in the property "FunctionHealthRecords"' {
                $Result.FunctionHealthRecords.Count | Should Be 2
            }
            It 'Should return only [PSCodeHealth.Function.HealthRecord] objects in the property "FunctionHealthRecords"' {
                $ResultTypeNames = ($Result.FunctionHealthRecords | Get-Member).TypeName
                Foreach ( $TypeName in $ResultTypeNames ) {
                    $TypeName | Should Be 'PSCodeHealth.Function.HealthRecord'
                }
            }
        }
        Context 'No value is specified for the Path parameter' {

            Mock Get-PowerShellFile { } -ParameterFilter { $Path  -eq $TestDrive }

            It 'Should default to the current directory if we are in a FileSystem PowerShell drive' {
                Set-Location $TestDrive
                $Null = Invoke-PSCodeHealth -Recurse
                Assert-MockCalled -CommandName Get-PowerShellFile -Scope It -ParameterFilter { $Path  -eq $TestDrive }
            }
            It 'Should throw if we are in a PowerShell drive other than the FileSystem provider' {
                { Set-Location HKLM:\ ; Invoke-PSCodeHealth } |
                Should Throw 'The current location is from the Registry provider, please provide a value for the Path parameter or change to a FileSystem location.'
            }
        }
        Context 'The Recurse and the Exclude parameters are used' {

            Mock Get-PowerShellFile { } -ParameterFilter { $Recurse -and $Exclude -eq "Exclude*" }

            It 'Should pass the value of the Exclude parameter to Get-PowerShellFile if the Exclude parameter is specified' {
                Set-Location $TestDrive
                $Null = Invoke-PSCodeHealth -Recurse -Exclude "Exclude*"
                Assert-MockCalled -CommandName Get-PowerShellFile -Scope It -ParameterFilter { $Recurse -and $Exclude -eq "Exclude*" }
            }
            It 'Should throw if we are in a PowerShell drive other than the FileSystem provider' {
                { Set-Location HKLM:\ ; Invoke-PSCodeHealth -Recurse -Exclude "Exclude*" } |
                Should Throw 'The current location is from the Registry provider, please provide a value for the Path parameter or change to a FileSystem location.'
            }
        }
        Context 'The TestsResult parameter is specified' {

            $PesterResult = $Mocks.'Invoke-Pester'.'NumberOfTests' | Where-Object { $_ }
            $Result = Invoke-PSCodeHealth -Path "$TestDrive\2PublicFunctions.psm1" -TestsResult $PesterResult

            It 'Should return an object with the expected property "LinesOfCodeTotal"' {
                $Result.LinesOfCodeTotal | Should Be 31
            }
            It 'Should return an object with the expected property "LinesOfCodeAverage"' {
                $Result.LinesOfCodeAverage | Should Be 15.5
            }
            It 'Should return an object with the expected property "ScriptAnalyzerFindingsTotal"' {
                $Result.ScriptAnalyzerFindingsTotal | Should Be 1
            }
            It 'Should return an object with the expected property "ScriptAnalyzerErrors"' {
                $Result.ScriptAnalyzerErrors | Should Be 0
            }
            It 'Should return an object with the expected property "ScriptAnalyzerWarnings"' {
                $Result.ScriptAnalyzerWarnings | Should Be 1
            }
            It 'Should return an object with the expected property "ScriptAnalyzerInformation"' {
                $Result.ScriptAnalyzerInformation | Should Be 0
            }
            It 'Should return an object with the expected property "ScriptAnalyzerFindingsAverage"' {
                $Result.ScriptAnalyzerFindingsAverage | Should Be 0.5
            }
            It 'Should return an object with the expected property "FunctionsWithoutHelp"' {
                $Result.FunctionsWithoutHelp | Should Be 0
            }
            It 'Should return an object with the expected property "NumberOfTests"' {
                $Result.NumberOfTests | Should Be 51
            }
            It 'Should return an object with the expected property "NumberOfFailedTests"' {
                $Result.NumberOfFailedTests | Should Be 7
            }
            It 'Should return an object with the expected property "NumberOfPassedTests"' {
                $Result.NumberOfPassedTests | Should Be 44
            }
            It 'Should return an object with the expected property "TestsPassRate"' {
                $Result.TestsPassRate | Should Be 86.27
            }
            It 'Should return an object with the expected property "TestCoverage"' {
                $Result.TestCoverage | Should Be 81.48
            }
            It 'Should return an object with the expected property "CommandsMissedTotal"' {
                $Result.CommandsMissedTotal | Should Be 5
            }
            It 'Should return an object with the expected property "ComplexityAverage"' {
                $Result.ComplexityAverage | Should Be 1
            }
            It 'Should return an object with the expected property "ComplexityHighest"' {
                $Result.ComplexityHighest | Should Be 1
            }
            It 'Should return an object with the expected property "NestingDepthAverage"' {
                $Result.NestingDepthAverage | Should Be 1
            }
            It 'Should return an object with the expected property "NestingDepthHighest"' {
                $Result.NestingDepthHighest | Should Be 1
            }
            It 'Should return 2 objects in the property "FunctionHealthRecords"' {
                $Result.FunctionHealthRecords.Count | Should Be 2
            }
        }
        Context 'The HtmlReportPath parameter is specified but not PassThru' {

            $HealthReportParams = @{
                Path = "$TestDrive\2PublicFunctions.psm1"
                HtmlReportPath = "$TestDrive\Report.html"
            }
            $Result = Invoke-PSCodeHealth @HealthReportParams

            It 'Should output nothing to the pipeline' {
                $Result | Should BeNullOrEmpty
            }
            It 'Should create the HTML file at the path specified via the HtmlReportPath parameter' {
                Test-Path -Path "$TestDrive\Report.html" -PathType Leaf | Should Be $True
            }
            It 'Should create a HTML file bigger than the HTML template' {
                (Get-Item -Path "$TestDrive\Report.html").Length | Should BeGreaterThan 23495
            }
        }
        Context 'The HtmlReportPath and PassThru parameters are both specified' {

            $HealthReportParams = @{
                Path = "$TestDrive\2PublicFunctions.psm1"
                HtmlReportPath = "$TestDrive\Report2.html"
                PassThru = $True
            }
            $Result = Invoke-PSCodeHealth @HealthReportParams

            It 'Should return an object of the type [PSCodeHealth.Overall.HealthReport]' {
                $Result | Should BeOfType [PSCustomObject]
                ($Result | Get-Member).TypeName[0] | Should Be 'PSCodeHealth.Overall.HealthReport'
            }
            It 'Should create the HTML file at the path specified via the HtmlReportPath parameter' {
                Test-Path -Path "$TestDrive\Report2.html" -PathType Leaf | Should Be $True
            }
            It 'Should create a HTML file bigger than the HTML template' {
                (Get-Item -Path "$TestDrive\Report2.html").Length | Should BeGreaterThan 23495
            }
        }
        Context 'The PassThru parameter is specified but not HtmlReportPath' {

            $HealthReportParams = @{
                Path = "$TestDrive\2PublicFunctions.psm1"
                HtmlReportPath = $Null
                PassThru = $True
            }

            It 'Should throw a "ParameterArgumentValidationError" exception' {
                { Invoke-PSCodeHealth @HealthReportParams } |
                Should Throw "Cannot validate argument on parameter 'HtmlReportPath'."
            }
        }
        Context 'The file specified via the CustomSettingsPath parameter does not exist' {

            $HealthReportParams = @{
                Path = "$TestDrive\2PublicFunctions.psm1"
                HtmlReportPath = "$TestDrive\Report3.html"
                CustomSettingsPath = "$TestDrive\DoesNotExist"
            }

            It 'Should throw a "ParameterArgumentValidationError" exception' {
                { Invoke-PSCodeHealth @HealthReportParams } |
                Should Throw "Cannot validate argument on parameter 'CustomSettingsPath'."
            }
        }
    }
}