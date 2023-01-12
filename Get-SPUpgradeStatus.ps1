  function Get-InternalValue($obj, $propertyName)  
  {  
       if ($obj)  
       {  
           $type = $obj.GetType()  
           $property = $type.GetProperties([Reflection.BindingFlags] "Static,NonPublic,Instance,Public") | ? { $_.Name -eq $propertyName }       
           if ($property)  
           {  
                $property.GetValue($obj, $null);  
            }  
       }  
  }  
  [System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint") | Out-Null  
  $farm = [Microsoft.SharePoint.Administration.SPFarm]::Local  
  $type = ('Microsoft.SharePoint.Administration.SPPersistedTypeCollection`1') -as "Type"  
  $type = $type.MakeGenericType( ("Microsoft.SharePoint.Upgrade.SPUpgradeSession" –as "Type") )  
  $upgradeSessions = [Activator]::CreateInstance($type, $farm)  
  $summary =@{Label="Server";Expression= { (Get-InternalValue $_ "Server").ToString() } } , `  
            @{Label="StartTime";Expression= { (Get-InternalValue $_ "StartTime").ToString() } }, `  
            @{Label="LastUpdateTime";Expression= { (Get-InternalValue $_ "LastUpdateTime").ToString() } }, `  
            @{Label="Errors";Expression= { (Get-InternalValue $_ "ErrorCount").ToString() } }, `  
            @{Label="Warnings";Expression= { (Get-InternalValue $_ "WarningCount").ToString() } }, `
            @{Label="SessionStatus";Expression= { (Get-InternalValue $_ "Status").ToString() } }  
  $details = @{Label="SessionId";Expression= { $_.Id } }, `  
            @{Label="Server";Expression= { (Get-InternalValue $_ "Server").ToString() } } , `  
            @{Label="StartTime";Expression= { (Get-InternalValue $_ "StartTime").ToString() } }, `  
            @{Label="LastUpdateTime";Expression= { (Get-InternalValue $_ "LastUpdateTime").ToString() } }, `  
            @{Label="Errors";Expression= { (Get-InternalValue $_ "ErrorCount").ToString() } }, `  
            @{Label="Warnings";Expression= { (Get-InternalValue $_ "WarningCount").ToString() } }, `  
            @{Label="LogFilePath";Expression= { (Get-InternalValue $_ "LogFilePath").ToString() } }, `  
            @{Label="ElapsedTime";Expression= { (Get-InternalValue $_ "ElapsedTime").ToString() } }, `  
            @{Label="Remedy";Expression= { (Get-InternalValue $_ "Remedy").ToString() } }
$upgradeSessions   | select -Last 20 | Format-Table $summary
#$upgradeSessions | select -Last 20 | Format-List $details
