function Send-PoshbotWol
{
	<#
			.SYNOPSIS 
			Send a WOL Packet to a BroadCast address via PoshBot
			.PARAMETER MacAddress
			The MacAddress address of the device that need to wake up
			.PARAMETER IpAddress
			The IpAddress address where the WOL Packet will be sent to
			.EXAMPLE
			!WOL 00:11:22:33:44:55
			.EXAMPLE
			!WOL 00:11:22:33:44:55 --ip 192.168.1.254 --port 1234
			.EXAMPLE
			Send-PoshbotWol -MacAddress 00:11:22:33:44:55 -IpAddress 192.168.2.100
			.URL
			WOL Script via https://marcelvenema.com/Blog/ArticleID/58/Wake-on-LAN-with-PowerShell
	#>
	
	[cmdletbinding()]	
	[PoshBot.BotCommand(
			CommandName = 'Send-PoshbotWol',
			Aliases = ('WOL'),
			Permissions = 'Execute'
	)]
	param(
		[parameter(Mandatory,position = 1)]
		[string]
		$MacAddress,

		[parameter(position = 2)]
		[Alias('ip')]
		[string]
		$IpAddress = '255.255.255.255',
		
		[parameter(position = 3)]
		[Alias('port')]
		[int]
		$UdpPort = 9
	)

	$BroadCast = [IpAddress]::Parse($IpAddress)
	$MacAddress = (($MacAddress.replace(':','')).replace('-','')).replace('.','')
	$Target = 0, 2, 4, 6, 8, 10 | 
	ForEach-Object -Process {
		[Convert]::ToByte($MacAddress.substring($_,2),16)
	}

	$Packet = (,[Byte]255 * 6) + ($Target * 16)
	$UdpClient = New-Object -TypeName System.Net.Sockets.UdpClient
	$UdpClient.Connect($BroadCast,$UdpPort)
	$null = $UdpClient.Send($Packet, 102)
	
	New-PoshBotCardResponse -Type Normal -Text ('WOL magic packet send to MAC Address {0} via IP Address {1} on UDP Port {2}' -f $MacAddress, $IpAddress, $UdpPort)
}

$CommandsToExport += 'Send-PoshbotWol'


Export-ModuleMember -Function $CommandsToExport