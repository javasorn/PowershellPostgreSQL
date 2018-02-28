<#
.SYNOPSIS
Sample Powershell work with PostgreSQL

.DESCRIPTION
use npgsql is an open source ADO.NET Data Provider for PostgreSQL
Fine working in Npgsql.3.1.10

.PARAMETER
- Create table
- Insert data to table
- Select data from table
.EXAMPLE

.NOTES

.LINK
http://www.npgsql.org/

#>
#---------------------------------------------------------[Initialisations/Declarations]--------------------------------------------------------

$connectionString = "Host=hostName;Database=sampledb;User Id=username;Password=password"
$dllPath = "C:\Program Files\PackageManagement\NuGet\Packages\Npgsql.3.1.10\lib\net451\Npgsql.dll"

#-----------------------------------------------------------[Functions]-------------------------------------------------------------------------
Function Insert-table {
param(
    [Parameter(Mandatory = $true)] $Connection
)
    $sql = "insert into books (title,created) VALUES ('Book Title',Now())"
    $command = New-Object Npgsql.NpgsqlCommand $sql,  $Connection
    $command.ExecuteNonQuery()
}
Function Select-table {
param(
    [Parameter(Mandatory = $true)] $Connection
)
    $sql = "select * from books"
    $command = New-Object Npgsql.NpgsqlCommand $sql,  $Connection
    $dr = $command.ExecuteReader()
    while ( $dr.Read() ){
        $dr[0], $dr[1], $dr[2]
    }
}
Function Create-table {
param(
    [Parameter(Mandatory = $true)] $Connection
)
    $sql  = '
    CREATE TABLE books (
    id              SERIAL PRIMARY KEY,
    title           VARCHAR(100) NOT NULL,
    created         timestamp with time zone
    );'
    $command = New-Object Npgsql.NpgsqlCommand $sql,  $Connection
    $command.ExecuteNonQuery()
}

#-----------------------------------------------------------[Execution]-------------------------------------------------------------------------

[Reflection.Assembly]::LoadFrom($dllPath) > $null
$conn = new-object Npgsql.NpgsqlConnection $connectionString
$conn.Open()

#create a new table
Create-table -Connection $conn

#insert a new row
Insert-table -Connection $conn

#select from table
Select-table -Connection $conn

$conn.Close()