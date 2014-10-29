# Create a VPC
# http://awsscripting.wordpress.com/

# Set Default AWS Credentials (ignore this if default credentials are already setup.)
 Initialize-AWSDefaults -AccessKey ‘AccessKey’ -SecretKey ‘SecretKey’ -Region ‘Region’

The following script will create
 VPC 10.20.0.0/16, Subnet1 10.20.1.0/24, Subnet2 10.20.2.0/24

#Create new VPC
 $vpcResult = New-EC2Vpc -CidrBlock ‘10.20.0.0/16′
 $vpcId = $vpcResult.VpcId
 Write-Output “VPC ID : $vpcId”

#Enable DNS Support & Hostnames in VPC
 Edit-EC2VpcAttribute -VpcId $vpcId -EnableDnsSupport $true
 Edit-EC2VpcAttribute -VpcId $vpcId -EnableDnsHostnames $true

#Create new Internet Gateway
 $igwResult = New-EC2InternetGateway
 $igwId = $igwResult.InternetGatewayId
 Write-Output “Internet Gateway ID : $igwId”

#Attach Internet Gateway to VPC
 Add-EC2InternetGateway -InternetGatewayId $igwId -VpcId $vpcId

#Create new Route Table
 $rtResult = New-EC2RouteTable -VpcId $vpcId
 $rtId = $rtResult.RouteTableId
 Write-Output “Route Table ID : $rtId”

#Create new Route
 $rResult = New-EC2Route -RouteTableId $rtId -GatewayId $igwId -DestinationCidrBlock ‘0.0.0.0/0′

#Create Subnet1 & associate route table
 $sn1Result = New-EC2Subnet -VpcId $vpcId -CidrBlock ‘10.20.1.0/24′ -AvailabilityZone ‘us-east-1d’
$sn1Id = $sn1Result.SubnetId
 Write-Output “Subnet1 ID : $sn1Id”
Register-EC2RouteTable -RouteTableId $rtId -SubnetId $sn1Id

#Create Subnet2 & associate route table
 $sn2Result = New-EC2Subnet -VpcId $vpcId -CidrBlock ‘10.20.2.0/24′ -AvailabilityZone ‘us-east-1d’
$sn2Id = $sn2Result.SubnetId
 Write-Output “Subnet2 ID : $sn2Id”
Register-EC2RouteTable -RouteTableId $rtId -SubnetId $sn2Id

Write-Output “VPC Setup Complete”
