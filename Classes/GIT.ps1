class GIT {
<#
        SR [06-01-2023]: 
            This class contains methods for automating git CLI commands.
        params: 
            $auto --> is used in methods to escape user interactions during perfoming GIT actions
        example:
            1. 
                $obj = [git]::new($true, $false)
            2. 
                $params = @{_auto=$true; _verbodse=$false} | % {$_.values} #--> pass named parameters
                $obj = [git]::new($params)
     #>

    # Property to control user interactions
    [bool] $auto
    [bool] $verbose
    [string] $main_branch_name = ( git symbolic-ref refs/remotes/origin/HEAD ).split('/')[-1]
    [scriptblock] $writeVerboseFunction

    # Constructors
    GIT() {
        $this.auto = $true
        $this.verbose = $true
        $this.SetVerbose()
    }
    # for named parameters
    GIT( [hashtable]$params) {
        
        $this.auto = $null -eq $params['_auto'] ? $true : $params['_auto']
        $this.verbose = $null -eq $params['_verbose'] ? $true : $params['_verbose']
        $this.SetVerbose()
    }

    [void] SetVerbose() {
        if ($this.verbose) {
            $this.writeVerboseFunction = { 
                param($message)
                Write-Host -ForegroundColor Yellow "VERBOSE:" $message
            } 
        }
        else {
            $this.writeVerboseFunction = { 
                #if wriverbose -eq $false, use outer $verbosePreference 
                param($message)
                Write-Verbose $message
            } 
        }
        & $this.writeVerboseFunction ">>> GIT Class Inited <<<"
    }
    
    #---------------- Git Automating --------------------
    [void] ShowBranches() { $this.ShowBranches($false) } #def overload for no params call
    [void] ShowBranches([bool]$detailed) { 
        if ($detailed) {
            git br -vv | ForEach-Object { cw ($_ -replace "\[or.*?\]", "") }
        }
        else {
            Write-Host ">>> Branches: "; Write-Host("-" * 50)
            git branch | ForEach-Object { Write-Host $_ }        
            Write-Host("-" * 50)
        }
    }
    [void] SwitchBranch() { $this.SwitchBranch("") }
    [void] SwitchBranch([string]$branchName) {
        #   Switching Branch
        & $this.writeVerboseFunction ">>> SwitchBranch <<<"
        
        $this.ShowBranches()        
        if ($branchName -eq "") {
            git checkout (Read-Host -Prompt ">>> Enter branch name: ")
            break
        }
        git checkout $branchName        
        $this.ShowBranches()
    }
    [void] NewBranch() { $this.NewBranch("") }
    [void] NewBranch([string]$branchName) {
        & $this.writeVerboseFunction ">>> NewBranch <<<"
        if (
            (Read-Host -Prompt ">>> You are branching from: | $(git branch --show-current) |. 'Q' to Cancel, [Y] to continue") `
                -in @("Q", "N", "end")
        ) { break }
    
        if ($branchName -eq "") {
            #       ask for BrName
            $branchName = Read-Host -Prompt "Input name of new branch... ( 'Q' to cancel ) --> "
            if ($branchName -eq "Q") { break }
        }        
    
        git checkout -b $branchName
    
    }
    [void] ShowChanges() { 
        Write-Host ">>> Files Changed: "; Write-Host("-" * 50)
        (git changes) | ForEach-Object { Write-Host $_ }
    }    
    [void] Commit() { $this.Commit("") }
    [void] Commit([string]$commitMessage) {
        try {            
            #   Show changes
            $currBr = git branch --show-current 
            & $this.writeVerboseFunction (  ">>> Committing on Branch -- " + $( $currBr ) + " --" + " <<<"    )
     
         
            if (!$this.auto) {
                & $this.writeVerboseFunction ">>> Inspect files changed on VS Code Source Control Tab if needed..."
                if ((Read-Host -Prompt "Proceed Committing? [Y] / N ") -in @("N", "Q", "end")  ) { break }
     
            }        
            #   staging
            git add -A
            & $this.writeVerboseFunction ">>> Files Staged..."
     
            #   Committing
            $commMessage = ""
            if ($commitMessage -eq "") {
                Write-Host "Insert Commit Message ('Q' to cancel, [Enter] to open new line, 'end' to finish input) --> "
                while (1) { $newline = read-host ; if ($newline -eq "end") { break }; $commMessage += "$newline `n"; }
                $commMessage = $commMessage.Trim()
             
                if ($commMessage -eq "Q") { break }
            }
            else {
                $commMessage = $commitMessage
            }
         
            git commit -a -m $commMessage
            & $this.writeVerboseFunction ">>> Committed successfully"
        }
        catch {
            Write-Error "An error occurred: $($_.Exception.Message)"
        }
    }   
    [void] SyncBranch() { $this.SyncBranch($true) }
    [void] SyncBranch([bool]$auto) {
        #   Synching current brach
        & $this.writeVerboseFunction ">>> SyncBranch <<<"
    
        if (!$auto) {
            if ((Read-Host -Prompt "Sync with Remote? [Y] / N") -eq "N") { break }
    
        }        $currBranch = git branch --show-current
        
        git pull origin $currBranch
        git push origin $currBranch
        & $this.writeVerboseFunction ">>> SyncBranch: Successfull <<<"

    }
    [void] MergeToMain() {
        #   Merge of current branch to Master --> can be done by priviliged users only
        $currBranch = git branch --show-current
        & $this.writeVerboseFunction ">>> SyncBranch {$currBranch --> main} <<<"
    
        <#  --------------- some logic for checking if current user is a provoliged one ---------------  #>
    
        git merge main ($currBranch)
    }    
    [void] MergeFromMain() {
        #	Merge from Master to current branch --> to FF other developers' changes
        & $this.writeVerboseFunction ">>> MergeFromMain <<<"
    
        $currBranch = git branch --show-current
        
        git merge main   
        & this.writeVerboseFunction ">>> Branch merged to Main: $currBranch <<<"
    }
}