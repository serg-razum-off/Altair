# Define the SearchResult class
class SearchResult {
    [datetime]$Date
    [string]$BranchName
    [string]$CommitHash
    [string]$FileName
    [int]$LineNumber
    [string]$LineContent
}
# Define the Search-GitCommits function
function Search-GitCommits {
    <#
    $regexPattern="#.SR.*"
    $branchName = "kggl_videogames"

    $results = Search-GitCommits -BranchName $branchName -RegexPattern $regexPattern
    ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$

    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$BranchName,
        [Parameter(Mandatory = $true)]
        [string]$RegexPattern
    )

    $topFolder = $PWD.path
    # Step 2: grab all Commits of the Branch
    $commits = git log --format="%h" $BranchName

    # Step 3: loop through the text of Commits and search for the RegEx pattern
    # $results = New-Object System.Collections.ArrayList
    foreach ($commit in $commits) {
        $date = git show --format="%ci" -s $commit
        $files = git show --pretty="" --name-only $commit
        foreach ($file in $files) {
            $lines = git show "$commit`:$file"
            
                $lineNumber = 0
                foreach ($line in $lines) {
                    $lineNumber++
                    if ($line -match $regexPattern) {
                        # Step 4: create a SearchResult object and add it to the array
                        $searchResult = [SearchResult]@{
                            Date = [datetime]::ParseExact($date.Trim(), "yyyy-MM-dd HH:mm:ss zzz", $null)
                            BranchName = $branchName
                            CommitHash = $commit
                            FileName = $file
                            LineNumber = $lineNumber
                            LineContent = $line
                        }
                        # [void]$results.Add($searchResult)
                        $searchResult >> ($topFolder + '\gitLogAnalysis.txt')
                        "--"*10 >> ($topFolder + '\gitLogAnalysis.txt')
                        # Write-Host ($topFolder + '\gitLogAnalysis.txt')
                    }
                }
                
        }  
    }

    # Step 5: return the results
    # return $results
}
