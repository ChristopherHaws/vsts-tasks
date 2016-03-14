# Start Website

## Overview
Starts a website in IIS.

 - **Machines**: Specify comma separated list of machine FQDNs/ip addresses along with port(optional). For example dbserver.fabrikam.com, dbserver_int.fabrikam.com:5986,192.168.34:5986. Port when not specified will be defaulted to WinRM defaults based on the specified protocol. i.e., (For *WinRM 2.0*):  The default HTTP port is 5985, and the default HTTPS port is 5986. Machines field also accepts 'Machine Groups' defined under 'Test' hub, 'Machines' tab. 
 - **Admin Login**: Domain/Local administrator of the target host. Format: &lt;Domain or hostname&gt;\ &lt; Admin User&gt;. Mandatory when used with list of machines, optional for Test Machine Group (will override test machine group value when specified). 
 - **Password**:  Password for the admin login. It can accept variable defined in Build/Release definitions as '$(passwordVariable)'. You may mark variable type as 'secret' to secure it. Mandatory when used with list of machines, optional for Test Machine Group (will override test machine group value when specified). 
 - **Protocol**:  Specify the protocol that will be used to connect to target host, either HTTP or HTTPS.
 - **Test Certificate**: Select the option to skip validating the authenticity of the machine's certificate by a trusted certification authority. The parameter is required for the WinRM HTTPS protocol.
 - **Website Name\*:** The name of the IIS website that will be started on the IIS server. The name of the website should be same as that specified in the web deploy zip package file. If a Parameter 