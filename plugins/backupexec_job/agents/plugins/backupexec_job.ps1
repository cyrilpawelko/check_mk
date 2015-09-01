# Check_mk plugin for Backup Exec 2010 jobs. Tested with Backup Exec 2010 R3 and Windows 2012
# Job must have run once to be inventoried
# Cyril Pawelko - cyril@pawelko.net http://www.pawelko.net

function Invoke-SQL {
    param(
        [string] $sqlCommand = ""
      )
# BE Database should be on localhost
    $dataSource = ".\BKUPEXEC"
    $database = "BEDB"
    $connectionString = "Data Source=$dataSource; " +
            "Integrated Security=SSPI; " +
            "Initial Catalog=$database"

    $connection = new-object system.data.SqlClient.SQLConnection($connectionString)
    $command = new-object system.data.sqlclient.sqlcommand($sqlCommand,$connection)
    $connection.Open()
	trap
	{
		write-host "Error connecting to database $database on $dataSource";
		exit
	}

    $adapter = New-Object System.Data.sqlclient.sqlDataAdapter $command
    $dataset = New-Object System.Data.DataSet
    $adapter.Fill($dataSet) | Out-Null

    $connection.Close()
    $dataSet.Tables
}

function Remove-Diacritics([string]$String) # from http://poshcode.org/1054
{
    $objD = $String.Normalize([Text.NormalizationForm]::FormD)
    $sb = New-Object Text.StringBuilder
 
    for ($i = 0; $i -lt $objD.Length; $i++) {
        $c = [Globalization.CharUnicodeInfo]::GetUnicodeCategory($objD[$i])
        if($c -ne [Globalization.UnicodeCategory]::NonSpacingMark) {
          [void]$sb.Append($objD[$i])
        }
      }
 
    return("$sb".Normalize([Text.NormalizationForm]::FormC))
}

function CMKName
{param ($Text)
 [System.Text.RegularExpressions.Regex]::Replace($Text,"[^0-9a-zA-Z.]","_")
}


write-host "<<<backupexec_job>>>"

# Retrieve Jobs from vwJobs
#JOB TYPE:         300 (Backup Copy)
#JOB TYPE:         200 (Backup)

$Jobs = Invoke-SQL "select JobID,JobName,TaskTypeID,NextDueDate from vwJobs where TaskTypeID=200 or TaskTypeID=300 or TaskTypeID=700"

foreach ($job in $Jobs) {
  $jobName = CMKName(Remove-Diacritics($job.JobName))
  $jobId = $job.JobID
  $jobHistory = Invoke-SQL "select TOP 1 JobName,FinalJobStatus,EndTime,ElapsedTimeSeconds,TotalDataSizeBytes,TotalRateMbMin,DDupRatio FROM vwJobHistorySummary2 WHERE (JobId = '$jobId' AND IsJobActive=0 ) ORDER BY ActualStartTime DESC"
  # If no history, go to next job
  If ( $jobHistory.Rows.Count -eq 0 ) { continue }
  # Just enumerate jobHistory single row
	foreach ( $jobHistoryResult in $jobHistory) {
}
  write-host job $jobname $jobHistoryResult.FinalJobStatus $jobHistoryResult.Endtime $jobHistoryResult.ElapsedTimeSeconds $jobHistoryResult.TotalDataSizeBytes $jobHistoryResult.TotalRateMbMin $jobHistoryResult.DDupRatio
}
