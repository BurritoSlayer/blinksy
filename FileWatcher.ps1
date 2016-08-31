# https://social.technet.microsoft.com/Forums/scriptcenter/en-US/c75c7bbd-4e32-428a-b3dc-815d5c42fd36/powershell-check-folder-for-new-files
# http://superuser.com/questions/226828/how-to-monitor-a-folder-and-trigger-a-command-line-action-when-a-file-is-created

# folder path that the watcher is listening to
$dir = 'C:\Users\ntacey\Documents\blinksy\upload'

# look for all files
$filter = '*.*'

# folder path where log file will live
$logFile = 'C:\Users\ntacey\Documents\blinksy\log\blinksyLog.txt'

# Set file watcher
$watcher = New-Object IO.FileSystemWatcher $dir, $filter -Property @{
  IncludeSubdirectories = $true # all subdirectories of $folder will also get the file watcher
  NotifyFilter = [IO.NotifyFilters]'FileName, LastWrite'
}

$action = {
  $name = $Event.SourceEventArgs.Name
  $changeType = $Event.SourceEventArgs.ChangeType
  $timeGenerated =$Event.TimeGenerated
  "The file $name was $changeType at $timeGenerated" | Add-Content $logFile

  invoke-expression -Command .\AWSConn.ps1
}

$onCreated = Register-ObjectEvent $watcher Created -SourceIdentifier FileUploadCreated -Action $action

$onCreated = Register-ObjectEvent $watcher Changed -SourceIdentifier FileUploadChanged -Action $action

$onCreated = Register-ObjectEvent $watcher Renamed -SourceIdentifier FileUploadRenamed -Action $action

# To unregister Event
# Unregister-Event -SourceIdentifier FileCreated
