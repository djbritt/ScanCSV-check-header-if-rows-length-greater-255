# Prompt user for CSV path 
$csvPath = Read-Host "Enter the path to the CSV file"

# Validate CSV path
if (-not (Test-Path $csvPath)) {
  Write-Host "Invalid CSV path: $csvPath"
  exit
}

# Import CSV 
$data = Import-Csv -Path $csvPath

# Get header row 
$headers = $data[0].PSObject.Properties | Select-Object -ExpandProperty Name

# Print headers
Write-Host "Column names:"
$headers | ForEach-Object { Write-Host $_ }

# Prompt for column name 
$columnName = Read-Host "Enter the name of the column to check"

# Validate column name
while (-not $headers.Contains($columnName)) {

  Write-Host "Column '$columnName' not found in CSV"
  $columnName = Read-Host "Enter the name of the column to check"

}

# Initialize exceeds length flag
$exceedsMaxLength = $false

# Import CSV data
$data = Import-Csv -Path $csvPath 

# Iterate through rows
foreach ($row in $data) {

  # Directly access column value
  $columnValue = $row.$columnName
  write-host $columnValue " - " $columnValue.length

  # Check if value exceeds 255 chars
  if ($columnValue.Length -gt 255) {
    
    Write-Host "Found value in column '$columnName' exceeding 255 chars in row $($row.'#'):"
    Write-Host $columnValue
    $exceedsMaxLength = $true

  }

}

# Check if any value exceeded length
if (-not $exceedsMaxLength) {
  Write-Host "No values exceeded 255 characters"
}
