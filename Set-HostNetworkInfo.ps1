vboxmanage showvminfo debian9 | findstr /i "NIC"

#built-in adapters
 $nics = Get-NetAdapter -Name * | Where-Object PnPDeviceID -CLike "*VEN_8086&DEV_1539*" | sort-object -Property PnPDeviceID 
 $count=1
 foreach ($nic in $nics)
 {
    switch ($count)
        {
            1 {Rename-NetAdapter -Name $nic.Name -NewName "1-STB-Ingress"}
            2 {Rename-NetAdapter -Name $nic.Name -NewName "2-Internet-Egress"}
            3 {Rename-NetAdapter -Name $nic.Name -NewName "3-Mgmt-CmdCtrl"}
            4 {Rename-NetAdapter -Name $nic.Name -NewName "4-Unused"}
        }
    $count++
 }
 Get-NetAdapter -Name * | Where-Object PnPDeviceID -CLike "*VEN_8086&DEV_1539*" | sort-object -Property PnPDeviceID  | Format-table Name, ifDesc, MacAddress, PnPDeviceID, PromiscuousMode, DeviceName

#wifi
$nics = Get-NetAdapter -Name * | Where-Object PnPDeviceID -CLike "*VID_13D3&PID_3273*" | sort-object -Property PnPDeviceID 
 $count=1
 foreach ($nic in $nics)
 {
    switch ($count)
        {
            1 {Rename-NetAdapter -Name $nic.Name -NewName "0-WiFi-Adapter"}
        }
    $count++
 }
 Get-NetAdapter -Name * | where PnPDeviceID -CLike "*VID_13D3&PID_3273*" | sort-object -Property PnPDeviceID  | Format-table Name, ifDesc, MacAddress, PnPDeviceID, PromiscuousMode, DeviceName

#virtualbox adapters
$nics = Get-NetAdapter -Name * | where ifDesc -CLike "*VirtualBox*" | sort-object -Property PnPDeviceID 
 $count=1
 foreach ($nic in $nics)
    {
        Rename-NetAdapter -Name $nic.Name -NewName "VirtualBox-$count" 
        $count++
    }
 Get-NetAdapter -Name * | where ifDesc -CLike "*VirtualBox*" | sort-object -Property PnPDeviceID  | Format-table Name, ifDesc, MacAddress, PnPDeviceID, PromiscuousMode, DeviceName
