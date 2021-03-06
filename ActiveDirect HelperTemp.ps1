#Date: May 17, 2018
#Author: Ethan Jiang
#Purpose: An Active Directory helper. It can display computers, users, and locked out
#users. Useful for checking names or information without having to search every time.

#Import relevant modules
import-module activedirectory

#opening dialogue function
function openingDialog{

Write-Host ""
Write-Host "What do you want to do?"
Write-Host ""

Write-Host "Type " -nonewline
Write-Host "findcomp" -foregroundcolor yellow -nonewline
Write-Host " to find a computer"

Write-Host "Type " -nonewline
Write-Host "finduser" -foregroundcolor cyan -nonewline
Write-Host " to find a user"

Write-Host "Type " -nonewline
Write-Host "lock" -foregroundcolor green -nonewline
Write-Host " to show locked users"

Write-Host ""
}

#"boolean" value to determine whether to keep running
$run = "Y"

#Main loop
While($run -eq "Y" -or $run -eq "y"){

openingDialog

$input = read-host "Type your selection"

#findcomp command - takes in user and loc and calls get-adcomputer to find comps
if($input -eq "findcomp"){

    Write-Host ""
    Write-Host "Enter " -nonewline
    Write-Host "username" -foregroundcolor yellow -nonewline
    Write-Host ": " -nonewline
    $compname = read-host
    Write-Host "Enter " -nonewline
    Write-Host "location suffix" -foregroundcolor yellow -nonewline
    Write-Host ": " -nonewline
    $loc = read-host
    Write-Host ""
    Write-Host "----------------------------------------"
    get-adcomputer $compname-$loc
    Write-Host ""
    Write-Host "Find logged on user? (Y or y for yes): " -nonewline
    $response = read-host
    
    #calls wmic to find username
    if($response -eq "Y" -or $response -eq "y"){
        Write-Host ""
        Write-Host "----------------------------------------"
        Write-Host ""
        Write-Host "WMIC command copied."
        #don't have access to Win32_computersystem :( must do it via WMIC
        "/node: ""$compname-$loc"" /user: ""Admin"" /password: ""AdminPass"" computersystem get username" | clip.exe
        Write-Host ""
    }
    
    Write-Host "Check all locations? (Y or y for yes): " -nonewline
    $response = read-host
    
    #if not accurate, finds all comps with compname
    if($response -eq "Y" -or $response -eq "y"){
        Write-Host ""
        Write-Host "----------------------------------------"
        get-adcomputer -filter ('Name -like "{0}*"' -f $compname)
        Write-Host "----------------------------------------"
    }
    
  #finduser command, takes in username and finds all users with that name
} elseif($input -eq "finduser"){

    Write-Host ""
    Write-Host "Enter " -nonewline
    Write-Host "username" -foregroundcolor cyan -nonewline
    Write-Host ": " -nonewline
    $username = read-host
    Write-Host ""
    Write-Host "----------------------------------------"
    Write-Host ""
    get-aduser -filter ('Name -like "{0}*"' -f $username)
    
  #lock command, simply shows all locked out users
} elseif($input -eq "lock"){

    Write-Host ""
    Write-Host "Displaying " -nonewline
    Write-Host "locked" -foregroundcolor green -nonewline
    Write-Host " accounts: "
    Write-Host ""
    Write-Host "----------------------------------------"
    Write-Host ""
    search-adaccount -lockedout
    
  #invalid entry, prompted to start again
} else{

    Write-Host ""
    Write-Host "Invalid entry!" -ForegroundColor red
    Write-Host ""
    
}#start again prompt, done after every executed command.

    Write-Host "Enter Y or y to restart. Anything else will exit."
    $run = read-host "Enter your selection"
    clear
}