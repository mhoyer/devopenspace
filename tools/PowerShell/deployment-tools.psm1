function Exec
{
    [CmdletBinding()]
    param(
        [Parameter(Position=0, Mandatory=1)][scriptblock] $Command,
        [Parameter(Position=1, Mandatory=0)][string] $ErrorMessage = ("Error executing command {0}, exit code {1}." -f $Command, $LastExitCode)
    )
    & $Command
    if ($LastExitCode -ne 0) {
        throw ("Exec: " + $ErrorMessage)
    }
}

function ConvertTo-UserName()
{
  param (
    [System.Security.Principal.WellKnownSidType] $SID = $(throw "SID is missing")
  )
  
  $account = New-Object System.Security.Principal.SecurityIdentifier($SID, $null)
  return $account.Translate([System.Security.Principal.NTAccount]).Value
}

function Set-Permissions {
  param (
    [string] $RootPath = $(throw "RootPath is missing"),
    [Hashtable] $Permissions = $(throw "Permissions are missing")
  )

  $Permissions.GetEnumerator() | Sort-Object Name | ForEach-Object {
    $path = [System.IO.Path]::Combine($RootPath, $_.Key)

    if (!(Test-Path -Path $path))
    {
      New-Item $path -Type directory | Out-Null
    }

    Write-Host "Permissions for $path"
    
    $acl = New-Object System.Security.AccessControl.DirectorySecurity
    
    $_.Value.GetEnumerator() | ForEach-Object {
      $rights = $_.Key
      
      $_.Value | ForEach-Object {
        $identity = $_
        Write-Host "$identity -> $rights"
        
        $ctor = $identity, `
          [System.Security.AccessControl.FileSystemRights]$rights, `
          [System.Security.AccessControl.InheritanceFlags]"ContainerInherit, ObjectInherit", `
          [System.Security.AccessControl.PropagationFlags]"None", `
          [System.Security.AccessControl.AccessControlType]"Allow"
        
        $ace = New-Object System.Security.AccessControl.FileSystemAccessRule $ctor
        
        $acl.AddAccessRule($ace)
      }
    }

    Set-Acl $path $acl
  }
  
  # Remove inherited permissions from root.
  $inherited = Get-Acl $RootPath
  $inherited.SetAccessRuleProtection($true, $false)
  Set-Acl $RootPath $inherited
}

Export-ModuleMember -Function *
