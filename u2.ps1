$file_path = "\\mpls-fs-624dfs\shares\uem-profiles\1276726672A\Redirected_Folders\Documents\Tools\test.csv"

$File = Import-Csv -Path $file_path | Sort-Object {Get-Random}


$i = 1
foreach ($item in $File){
    
    $question = $item.Question 
    $answers = $item.Answer_1, $item.Answer_2, $item.Answer_3, $item.Answer_4 | Where-Object { $_ -ne '-'} | Sort-Object {Get-Random}

    $a = $answers.Count
    $b = 0
    $answers_ht = @{}
    $letters = 'A', 'B', 'C', 'D'
    
    while ($a -gt 0){
        $answers_ht[$letters[$b]] = $answers[$b]
        $a = $a - 1
        $b += 1
    }

    Write-Host ($answers_ht | Out-String)
    #Write-Host "$i. $question"
    #Write-Host $answers.Count

    

    $i += 1
}
