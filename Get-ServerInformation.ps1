   #SQL
   function sql-check{

       $sql = Get-Service -Name *sql*
       if(-not $sql)
       {
           return "no sqlservices present"
       }
       else
       {
           return "SQl is installed"
       }
   }


    function Get-ServerInformation {
        #Build Object
        $Memory         = (systeminfo | Select-String 'Total Physical Memory:').ToString().Split(':')[1].Trim()
        $sql            = sql-check
        $ipaddress      =([System.Net.DNS]::GetHostAddresses($env:COMPUTERNAME)|Where-Object {$_.AddressFamily -eq "InterNetwork"}   |  select-object IPAddressToString)[0].IPAddressToString
        $disk = ([wmi]"\\$env:COMPUTERNAME\root\cimv2:Win32_logicalDisk.DeviceID='c:'")
        
        $Object = New-Object PSObject -Property @{
                "Hostname"                      = $env:COMPUTERNAME
                "Memory"                        = $Memory
                "Number of CPUs"                = $env:NUMBER_OF_PROCESSORS
                "Logon Server"                  = $env:LOGONSERVER
                "SQL installed"                 = $sql
                "IP Address"                    = $ipaddress
                "C drive/ Root Volume Size"     = [Math]::Round($disk.Size/1GB, 2)
                "C drive remaing space"         = [Math]::Round($disk.Freespace/1GB, 2)
            }
        return $Object
    }

        if($serverinfo.'SQL installed' -eq "no sqlservices present"){
            ##run sql install script
        }