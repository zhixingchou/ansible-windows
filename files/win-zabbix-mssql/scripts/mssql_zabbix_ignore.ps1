# The function is to bring to the format understands zabbix
function convertto-encoding ([string]$from, [string]$to){
	begin{
		$encfrom = [system.text.encoding]::getencoding($from)
		$encto = [system.text.encoding]::getencoding($to)
	}
	process{
		$bytes = $encto.getbytes($_)
		$bytes = [system.text.encoding]::convert($encfrom, $encto, $bytes)
		$encto.getstring($bytes)
	}
}

# We define the variables for connecting to MS SQL. $uid и $pwd need to authenticate windows
$SQLServer = "127.0.0.1"
$uid = "zabbix" 
$pwd = "ZABBIX123zx"

# DB ignore
$DB_to_skip =  "master", "tempdb", "model", "msdb"

# Create a connection to MSSQL

# If windows authentication
#$connectionString = "Server = $SQLServer; User ID = $uid; Password = $pwd;"

# If integrated authentication
$connectionString = "Server = $SQLServer; Integrated Security = True;"

$connection = New-Object System.Data.SqlClient.SqlConnection
$connection.ConnectionString = $connectionString
$connection.Open()

# Create a request directly to MSSQL
$SqlCmd = New-Object System.Data.SqlClient.SqlCommand  
$SqlCmd.CommandText = "SELECT name FROM  sysdatabases"
$SqlCmd.Connection = $Connection
$SqlAdapter = New-Object System.Data.SqlClient.SqlDataAdapter
$SqlAdapter.SelectCommand = $SqlCmd
$DataSet = New-Object System.Data.DataSet
$SqlAdapter.Fill($DataSet) > $null
$Connection.Close()

# We get a list of databases. Write to the variable.
$basename = $DataSet.Tables[0]

# Pass on only the names of databases, which are not specified in the list $DB_to_skip
$dbsToZabbix = @() #empty array
foreach ($name in $basename)
{
    if (-not ($DB_to_skip -contains $name.name))
        {
        $dbsToZabbix += $name.name
        }
}

# Parse and pass a list of databases in zabbix. In the last line need to display the database name without a comma at the end.
$idx = 1
$sComma = ","
write-host "{"
write-host " `"data`":[`n"
foreach ($dbToZabbix in $dbsToZabbix)
{
    if ($idx -eq $dbsToZabbix.Count) # this is the last line
        {
        $sComma = ""
        }
    $line= "{ `"{#DBNAME}`" : `"" + $dbToZabbix + "`" }" + $sComma | convertto-encoding "cp866" "utf-8"
    write-host $line
    $idx++;
}

write-host
write-host " ]"
write-host "}"
