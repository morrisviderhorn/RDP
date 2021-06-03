# RDP
Register public EC2 IP address with Route 53
Goal: When Amazon AWS Windows EC2 instance is powering up it receive a dynamic IP address and the goal is to create and register it is public IP address with Route 53 Amazon host domain as a CNAME record that is pointing to the public IP address.
Create an RDP file that point to the DNS CNAME.
Assumption:
You will need a paid public Amazon Route 53 hosted DNS zone to make it to work (in regards to the RDP file), my tests were only to check if CNAME record has been changed and registered (updated) each time Amazon Windows EC2 instance powered on an free Amazon route 53.

The steps:
1.	Created a standard Windows EC2 Instance on Amazon AWS – Instructions can be found here
2.	Created a public Amazon AWS Route 53 hosted zone and got the zone ID – Instruction can be found here
3.	Created the following PowerShell script inside the Windows EC2 Instance using Amazon PowerShell cmdlets 

The PowerShell Script:
*** The script contains the following steps **
1.	Variables.
2.	Look for existing CNAME record devops-rdp.viderhornaws.com in Route 53 VIDERHORNAWS.COM hosted zone and delete it.
3.	Create new CNAME record for Windows EC2 instance Public IP Address in Route 53 VIDERHORNAWS.COM hosted zone.
4.	Saved the script as RegisterDNS.ps1
5.	Created a basic task in the task schedular that each time the machine start it runs the script.


To register public dynamic IP address with route 53 using Amazon EC2 user data:

1. Login to the running ec2 instance -> Open PowerShell command window and exceute the script:

C:\ProgramData\Amazon\EC2-Windows\Launch\Scripts\InitializeInstance.ps1 –Schedule

2. Stop the ec2 windows instance -> then choose, Actions, Instance Settings, Edit User Data.
3. Enter the following

<powershell>
Enter the registerDNS.ps1 code
</powershell>
<persist>true</persist>
