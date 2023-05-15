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
    $regexPattern="^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"
    $branchName = "kggl_videogames"

    $results = Search-GitCommits -RegexPattern $regexPattern
    ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$

    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$RegexPattern
        # [Parameter(Mandatory = $true)]
        # [string]$BranchName
    )

    #SR: designating folder that we're working in
    $topFolder = $PWD.path
    Write-Host ">> working in $topFolder..." 
    ">> working in $topFolder..." >> ($topFolder + '\SR_gitLogAnalysis.txt')

    # Step 2: grab all Commits of the Branch
    $commits = git log --format="%h" #$BranchName

    # Step 3: loop through the text of Commits and search for the RegEx pattern
    # $results = New-Object System.Collections.ArrayList
    foreach ($commit in $commits) {
        $date = git show --format="%ci" -s $commit
        $files = git show --pretty="" --name-only $commit
        foreach ($file in $files) {
            $lines = git show "$commit`:$file"
            
                for ($i = 0; $i -lt $lines.Count; $i++) {
                    $previousLine = if ($i -gt 0) { $lines[$i - 1] } else { $null }
                    $currentLine = $lines[$i]
                    $nextLine = if ($i -lt ($lines.Count - 1)) { $lines[$i + 1] } else { $null }
                    
                    if ($line -match $regexPattern) {
                        # Step 4: create a SearchResult object and add it to the array
                        $searchResult = [SearchResult]@{
                            Date = [datetime]::ParseExact($date.Trim(), "yyyy-MM-dd HH:mm:ss zzz", $null)
                            BranchName = $branchName
                            CommitHash = $commit
                            FileName = $file
                            LineNumber = $i
                            LineContent = "$previousLine \n $currentLine \n $nextLine"
                        }
                        # [void]$results.Add($searchResult)
                        $searchResult >> ($topFolder + '\SR_gitLogAnalysis.txt')
                        "--"*10 >> ($topFolder + '\SR_gitLogAnalysis.txt')
                    }
                }
                
        }  
    }

    # Step 5: return the results
    # return $results
}
