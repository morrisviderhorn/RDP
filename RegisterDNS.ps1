#### System Variables for the DNS record script ###

$instance = (Get-EC2Instance $InstanceId).RunningInstance

$instance.PublicIpAddress

$name = "devops-rdp.viderhornaws.com"

$hostinfo = Get-R53ResourceRecordSet -HostedZoneId /hostedzone/Z09386662UQII2XH9J5NP | Select -ExpandProperty ResourceRecordSets

$hostedzoneid = "Z09386662UQII2XH9J5NP"

$zonename = "viderhornaws.com"

$R53RRS = Get-R53ResourceRecordSet -HostedZoneId $hostedzoneid  -Select ResourceRecordSets

$RSS = $R53RRS | where {$_.Name -eq "devops-rdp.viderhornaws.com."}

$ActualIP = $RSS.ResourceRecords |foreach { $_.Value }

$NewIP = (Invoke-WebRequest -uri "http://ifconfig.me/ip").Content


### Look for exisitng CNAME record devops-rdp.viderhornaws.com in Route 53 VIDERHORNAWS.COM hosted zone and delete it ###

$result = Get-R53ResourceRecordSet -HostedZoneId $hostedzoneid -StartRecordName $name -MaxItems 1

if ($result -ne $null) {

$change2 = New-Object Amazon.Route53.Model.Change
$change2.Action = "DELETE"
$change2.ResourceRecordSet = New-Object Amazon.Route53.Model.ResourceRecordSet
$change2.ResourceRecordSet.Name = "devops-rdp.viderhornaws.com"
$change2.ResourceRecordSet.Type = "CNAME"
$change2.ResourceRecordSet.TTL = 600
$change2.ResourceRecordSet.ResourceRecords.Add(@{Value=$ActualIP})



$params = @{
    HostedZoneId="$hostedzoneid"
	ChangeBatch_Comment="This to delete existing CNAME record"
	ChangeBatch_Change=$change2
}

Edit-R53ResourceRecordSet @params

}


#### Create new CNAME record for Windows EC2 instance Public IP Address in Route 53 VIDERHORNAWS.COM hosted zone ###

$change3 = New-Object Amazon.Route53.Model.Change
$change3.Action = "CREATE"
$change3.ResourceRecordSet = New-Object Amazon.Route53.Model.ResourceRecordSet
$change3.ResourceRecordSet.Name = "devops-rdp.viderhornaws.com"
$change3.ResourceRecordSet.Type = "CNAME"
$change3.ResourceRecordSet.TTL = 600
$change3.ResourceRecordSet.ResourceRecords.Add(@{Value=$instance.PublicIpAddress})

$params = @{
    HostedZoneId="$hostedzoneid"
	ChangeBatch_Comment="This change batch creates a CNAME record"
	ChangeBatch_Change=$change3
}

Edit-R53ResourceRecordSet @params 
