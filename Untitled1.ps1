function Invoke-Quiz {
    [CmdletBinding()]
    param (
        [string[]]$Path,
        $PassingScore
    )
    process {

        $MQF = Import-Csv -Path $Path
        $RandList = 0..($MQF.Question.Count - 1) | Sort-Object {Get-Random}
        $I = 1
        $CorrectAnswers = 0

        foreach ($num in $RandList) {
            $Answer = Get-Question -iter $I -num $num -MQF $MQF
            if ($Answer -eq $MQF.AnswerT[$num]) {
                if ($CONFIG_ReviewMode -eq $true){
                    Write-Host "Correct!" -ForegroundColor "Green"
                }

                $CorrectAnswers++
            }
            else {
                
                if ($CONFIG_ReviewMode -eq $true){
                    $out = [string]::Format("The correct answer is: {0}",$MQF.AnswerT[$num]) 
                    Write-Host "Incorrect!" -ForegroundColor "Red"
                    Write-Host $out -Foreground "Red"
                }
            }
            $I++
        }

        $Stats = Get-Stats -Total $MQF.Quesion.Count -Correct $CorrectAnswers -PassingScore $PassingScore

        Write-host $Stats
     
        pause
    }
}


function Get-Question {
    [CmdletBinding()]
    param (
        $iter,
        $num,
        $MQF
    )
    process {

        $output = [string]::Format(@"

---------------------
{0}. {1}
---------------------
1.{2}
2.{3}
3.{4}
4.{5}
---------------------

"@,$iter,
    $MQF.Question[$num],
    $MQF.Answer1[$num],
    $MQF.Answer2[$num],
    $MQF.Answer3[$num],
    $MQF.Answer4[$num])

        Write-Host $output

        $Answer = Read-Host ">"

        switch ($Answer)
        {
            '1'{$Answer = $MQF.Answer1[$num]}
            '2'{$Answer = $MQF.Answer2[$num]}
            '3'{$Answer = $MQF.Answer3[$num]}
            '4'{$Answer = $MQF.Answer4[$num]}
        }

        $Answer
    }
}


function Get-Stats {
    [CmdletBinding()]
    param (
        $Total,
        $Correct,
        $PassingScore
    )
    process {

        $Score = ($Correct / $Total) * 100

        if ($Score -ge $PassingScore){
            $PassMsg = "You Passed!"
        }
        else {
            $PassMsg = "You did not Pass this time :("
        }

        $Output = [string]::Format(@"

============
SCORE SHEET
============
{0} correct out of {1} total

Percentage Score: {2}%

Passing Score: {3}%

{4}

"@,$Correct,
    $Total,
    $Score,
    $PassingScore,
    $PassMsg)
        $Output

    }
    
}


function Show-Menu {
    [CmdletBinding()]
    param()

    process{

        if ($CONFIG_ReviewMode -eq $true){
            $mode = "ON"
            $modeFlip = "OFF"
        }
        else {
            $mode = "OFF"
            $modeFlip = "ON"
        }

        $banner1 = "============================================================="

        $banner2 = @"
      ____                                ____        _    
     / __ \____ _      _____  _____      / __ \__  __(_)___
    / /_/ / __ \ | /| / / _ \/ ___/_____/ / / / / / / /_  /
   / ____/ /_/ / |/ |/ /  __/ /  /_____/ /_/ / /_/ / / / /_
  /_/    \____/|__/|__/\___/_/         \___\_\__,_/_/ /___/

"@
       
        $banner3 = [string]::Format(@"
     Current Quiz: {0}      Current Passing Score: {1}
     Review Mode:  {2}

1) Start COD MQF Practice Test
2) Turn Review Mode {3}
3) Change Passing Score

"@,(($CONFIG_Quiz -split '\\')[-1] -split '\.')[0],$CONFIG_PassingScore,$mode,$modeFlip)


        Write-Host $banner1 -Foreground "Green"
        Write-Host $banner2 -Foreground "Red"
        Write-Host $banner1 -Foreground "Green"
        Write-Host $banner3
        Write-Host "Q) Quit/Exit the Script" -Foreground "Red"
    }
    
    
}

function Start-Menu {
    [CmdletBinding()]
    param()

    do 
    {
        Clear-Host
        Show-Menu
        $selection = Read-Host "Please make a selection"
        switch ($selection){
            '1' {
                Invoke-Quiz -Path $CONFIG_Quiz -PassingScore $CONFIG_PassingScore
            }
            '2' {
                if ($CONFIG_ReviewMode -eq $true){
                    $CONFIG_ReviewMode = $false
                }
                elseif ($CONFIG_ReviewMode -eq $false){
                    $CONFIG_ReviewMode = $true
                }
            }
            '3' {
                $score = Read-Host "Enter in new passing score value"
                $CONFIG_PassingScore = [int]$score
            }
        }   
    }
    until($selection -eq 'q')

}


$CONFIG_Quiz = 'C:\Users\1276726672A\Quizzer\COD MQF.csv'
$CONFIG_PassingScore = 85
$CONFIG_ReviewMode = $true


Start-Menu