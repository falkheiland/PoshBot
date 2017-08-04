function Invoke-PoshbotWin32PingStatus
{
	<#
			.SYNOPSIS
			Pings  Host
			.DESCRIPTION
			Uses Win32_PingStatus class to ping Host and sends reponse to PoshBot
			.EXAMPLE
			!PingStatus 'www.google.com'
			.EXAMPLE
			!PingStatus 192.168.1.1
			.EXAMPLE
			!Invoke-PoshbotWin32PingStatus --Hostname 192.168.1.1
	#>


	[cmdletbinding()]	
	[PoshBot.BotCommand(
			CommandName = 'Invoke-PoshbotWin32PingStatus',
			Aliases = ('PingStatus'),
			Permissions = 'Read'
	)]
	param
	(
		[Parameter(Mandatory,HelpMessage='Ip Address  or Hostname',Position = 1)]
		[string]
		$Hostname
	)

	$Filter = 'Address="{0}"' -f $Hostname
	$Result = Get-WmiObject -Class Win32_PingStatus -Filter $Filter | 
		Select-Object -Property Address, ResponseTime, Timeout, StatusCode
	
	switch ($Result.StatusCode)
	{
		0     
		{
			$StatusCode = 'Success'
		}
		11001 
		{
			$StatusCode = 'Buffer Too Small'
		}
		11002 
		{
			$StatusCode = 'Destination Net Unreachable'
		}
		11003 
		{
			$StatusCode = 'Destination Host Unreachable'
		}
		11004 
		{
			$StatusCode = 'Destination Protocol Unreachable'
		}
		11005 
		{
			$StatusCode = 'Destination Port Unreachable'
		}
		11006 
		{
			$StatusCode = 'No Resources'
		}
		11007 
		{
			$StatusCode = 'Bad Option'
		}
		11008 
		{
			$StatusCode = 'Hardware Error'
		}
		11009 
		{
			$StatusCode = 'Packet Too Big'
		}
		11010 
		{
			$StatusCode = 'Request Timed Out'
		}
		11011 
		{
			$StatusCode = 'Bad Request'
		}
		11012 
		{
			$StatusCode = 'Bad Route'
		}
		11013 
		{
			$StatusCode = 'TimeToLive Expired Transit'
		}
		11014 
		{
			$StatusCode = 'TimeToLive Expired Reassembly'
		}
		11015 
		{
			$StatusCode = 'Parameter Problem'
		}
		11016 
		{
			$StatusCode = 'Source Quench'
		}
		11017 
		{
			$StatusCode = 'Option Too Big'
		}
		11018 
		{
			$StatusCode = 'Bad Destination'
		}
		11032 
		{
			$StatusCode = 'Negotiating IPSEC'
		}
		11050 
		{
			$StatusCode = 'General Failure'
		}
	}
	
	if ($Result.StatusCode -eq 0)
	{
		New-PoshBotCardResponse -Type Normal -Text ('{0} responded within {1} ms. ({2})' -f $Result.Address, $Result.ResponseTime, $StatusCode)
	}
	else
	{
		if ($Result.StatusCode)
		{
			New-PoshBotCardResponse -Type Normal -Text ('{0} did not respond. ({1})' -f $Result.Address, $StatusCode)
		}
		else
		{
			New-PoshBotCardResponse -Type Normal -Text ('{0} did not respond. (no StatusCode)' -f $Result.Address)
		}
	}
}

$CommandsToExport += 'Invoke-PoshbotWin32PingStatus'


Export-ModuleMember -Function $CommandsToExport