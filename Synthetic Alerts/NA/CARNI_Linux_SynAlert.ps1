#######Carnival_Prod_Synthetic###########
$platform= 'Linux'
$node = 'ccldevsppmsdb02'
$diskName = '/tmp'
$serviceName = 'qualys-cloud-agent'
$templateName = 'CARNI.CG-IMOC-ALM Monitoring'
$alert = 'CARNI_Linux_Connectivity_LAN'
<#
-### Alerts ###-
Linux

Linux_Process_Monitoring
Linux_CPU_Utilization
Linux_Memory_Utilization
CARNI_Linux_Connectivity_LAN_CRITICAL
CARNI_Linux_Disk_Utilization_WARNING
#>

$extSysID = "AHUAT_" + (Get-Date -Format yyyymmddHHmmssff)

$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$headers.Add("Content-Type", "application/x-www-form-urlencoded")

$body = "client_id=vAgUjQk9xHPu1aNQ_p12gEfszvQa&client_secret=0Qu4zjNzmLt6TdlfGdyLbzGD_tAa&grant_type=client_credentials"

$responsen = Invoke-RestMethod 'https://ipaasprod-apis.us1.ccp.capgemini.com/token' -Method 'POST' -Headers $headers -Body $body
$responsen | ConvertTo-Json
$token=$responsen.access_token

$url="https://ipaasprod-apis.us1.ccp.capgemini.com/alert-business-service/alerts/event/update"
$headers=@{"Authorization"="Bearer $token"
            "Content-Type"="application/json"
            "Cookie"="SERVERID=apim-api-manager-gateway-0"
        }
 $new=@"
 {
"header":{
    "topic":"cn/carnival/de/ec/ic/%2B/tn/%2B/cs/%2B/sp/%2B/at/Linux_CPU_Utilization",
    "applicationId":"518b56fa-284f-4028-abe2-a5adc02d99ef"
    },
    "body": {

    "companyName":"carnival",
    "urgency":"3 - Medium",
    "impact":"3 - Moderate/Limited",
    "systemPlatform":"$platform",
    "impactedCi":"$node",
    "templateName":"$templateName",
    "externalSystemTicketId":"$extSysID",
    "externalSystem":"Splunk_NA",
    "shortDescription":"Autoheal Test for $alert",
    "fullDescription":"Automation Test Ticket. Please do not pick. Please cancle ticket after 1 Hour Saying it was test ticket by Automation team.",
    "customerShortname":"Carni",
    "ipAddress":"",
    "alertId":"Dummy",
    "alertType":"$alert",
    "correlationFlag":"No Correlation",
    "correlationId":"",
    "suppressionFlag":"Not in MWM",
    "suppressionId":"NULL",
    "deviceType":"",
    "modelClass":"",
    "modelType":"",
    "diskName":"$diskName",
    "memoryThreshold":"",
    "serviceName":"$serviceName",
    "cpuThreshold":"90"
    }
}
"@
$responsenew1=Invoke-RestMethod -Uri $url  -Method Post -Headers $headers -Body $new
$responsenew1|ConvertTo-Json

$extSysID