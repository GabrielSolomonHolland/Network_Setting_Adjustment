$ErrorActionPreference = 'silentlycontinue' #don't stop for errors

# Turn off metered connection
Set-ItemProperty -Path "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\NetworkList\DefaultMediaCost" -name "4G" -value "1"

# Always use cell data
#Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\WcmSvc\CellularFailover" -name "AllowFailover" -value "1" #inconsistently works
reg import .\reg_never_use_cell.reg

# Disable selective suspend for cell network adapters, disable adapters for non-cell adapters
$nics = Get-NetAdapter
foreach($nic in $nics) 
{
    if($nic.name -match "cellular")
    {
        #Disable-NetAdapterPowerManagement -Name $nic.name -SelectiveSuspend -Confirm: $false
        #Disable-NetAdapterPowerManagement -Name $nic.name -DeviceSleepOnDisconnect -Confirm: $false
    }
    else
    {
        enable-netadapter -name $nic.name -confirm:$false
        #disable-netadapter -name $nic.name -confirm:$false
    }

}

# Disable allowing computer to turn off device to save power
# https://social.technet.microsoft.com/Forums/en-US/eb42064a-8ee2-4a63-867b-4ab416684c8e/how-do-i-disable-quotallow-the-computer-to-turn-off-this-device-to-save-powerquot-for-nic-power
# https://www.jonathanmedd.net/2014/02/testing-for-the-presence-of-a-registry-key-and-value.html/
# https://community.spiceworks.com/topic/2329461-scripting-disable-allow-the-computer-to-turn-off-this-device-to-save-power
for($i=0; $i -le 25;$i++){
    $val = "00" + $i

    $path = 'HKLM:\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\' + $val
    if(Test-Path $path){
        #$value = Get-ItemProperty -path $path | Select-Object -ExpandProperty 'driverDesc'
        $key = Get-ItemProperty -path $path
        if ($key.DriverDesc -match 'mobile broadband'){
            $PnPCapabilities = $key.PnPCapabilities -bOR "0"
            Set-ItemProperty -Path $path -name "PnPCapabilities" -value $PnPCapabilities -Type "DWORD"
        }
    }
}

exit