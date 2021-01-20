USE VirtualManagerDB;
 
DECLARE @DeleteHostId GUID;
SET @DeleteHostId = 'YourHostGUID'
 
PRINT N'Deleting host with GUID ' + RTRIM(CAST(@DeleteHostID AS nvarchar(50)))
 
PRINT N'Getting host cluster GUID'
 
DECLARE @HostClusterID GUID;
SET @HostClusterID =
(
SELECT HostClusterID FROM [dbo].[tbl_ADHC_Host]
WHERE HostID = @DeleteHostId
)
 
IF (@HostClusterID IS NOT NULL)
PRINT N'Retreived host cluster GUID ' + RTRIM(CAST(@HostClusterID AS nvarchar(50)))
ELSE
PRINT N'This host does not belong to a cluster'
 
PRINT N'Deleteing physical objects'
 
DELETE FROM [dbo].[tbl_WLC_PhysicalObject]
WHERE HostId = @DeleteHostId
 
PRINT N'Deleteing virtual objects'
 
DELETE FROM [dbo].[tbl_WLC_VObject]
WHERE HostId = @DeleteHostId
 
PRINT N'Prepairing to delete host network adapters'
 
DECLARE @HostNetworkAdapterCursor CURSOR;
DECLARE @HostNetworkAdapterID GUID;
SET @HostNetworkAdapterCursor = CURSOR FOR
(SELECT NetworkAdapterID FROM [dbo].[tbl_ADHC_HostNetworkAdapter])
 
OPEN @HostNetworkAdapterCursor
 
FETCH NEXT FROM @HostNetworkAdapterCursor INTO @HostNetworkAdapterID
 
WHILE (@@FETCH_STATUS = 0)
BEGIN
PRINT N'Prepairing to delete host network adapter with GUID ' + RTRIM(CAST(@HostNetworkAdapterID AS nvarchar(50)))
 
PRINT N'Deleting logical network mapping for host network adapter with GUID ' + RTRIM(CAST(@HostNetworkAdapterID AS nvarchar(50)))
 
DELETE FROM [dbo].[tbl_NetMan_HostNetworkAdapterToLogicalNetwork]
WHERE HostNetworkAdapterID = @HostNetworkAdapterID
 
PRINT N'Deleting IP subnet VLAN mapping for host network adapter with GUID ' + RTRIM(CAST(@HostNetworkAdapterID AS nvarchar(50)))
 
DELETE FROM [dbo].[tbl_NetMan_HostNetworkAdapterToIPSubnetVLan]
WHERE HostNetworkAdapterID = @HostNetworkAdapterID
 
FETCH NEXT FROM @HostNetworkAdapterCursor INTO @HostNetworkAdapterID
END
 
CLOSE @HostNetworkAdapterCursor
DEALLOCATE @HostNetworkAdapterCursor
 
PRINT N'Completing host network adapters deletion'
 
DELETE FROM [dbo].[tbl_ADHC_HostNetworkAdapter]
WHERE HostID = @DeleteHostId
 
PRINT N'Deleting virtual networks'
 
DELETE FROM [dbo].[tbl_ADHC_VirtualNetwork]
WHERE HostID = @DeleteHostId
 
PRINT N'Deleting virtual switch extensions'
 
DELETE FROM [dbo].[tbl_NetMan_InstalledVirtualSwitchExtension]
WHERE HostID = @DeleteHostId
 
PRINT N'Deleting host volumes'
 
DELETE FROM [dbo].[tbl_ADHC_HostVolume]
WHERE HostID = @DeleteHostId
 
PRINT N'Deleting pass through disks'
 
DELETE FROM [dbo].[tbl_WLC_VDrive]
WHERE HostDiskId IN (SELECT DiskID FROM [dbo].[tbl_ADHC_HostDisk] WHERE HostID IN (SELECT HostID FROM [dbo].[tbl_ADHC_Host] WHERE HostID = @DeleteHostId))
 
PRINT N'Deleting host disks'
 
DELETE FROM [dbo].[tbl_ADHC_HostDisk]
WHERE HostID = @DeleteHostId
 
PRINT N'Prepairing to delete host bus adapters'
 
DECLARE @HostBusAdapterCursor CURSOR;
DECLARE @HostBusAdapterID GUID;
SET @HostBusAdapterCursor = CURSOR FOR
(SELECT HbaID FROM [dbo].[tbl_ADHC_HostBusAdapter])
 
OPEN @HostBusAdapterCursor
 
FETCH NEXT FROM @HostBusAdapterCursor INTO @HostBusAdapterID
 
WHILE (@@FETCH_STATUS = 0)
BEGIN
 
PRINT N'Prepairing to delete host bus adapter with GUID ' + RTRIM(CAST(@HostBusAdapterID AS nvarchar(50)))
 
PRINT N'Deleting fiber port mapping for host bus adapter with GUID ' + RTRIM(CAST(@HostBusAdapterID AS nvarchar(50)))
 
DECLARE @FiberPortID GUID;
SET @FiberPortID =
(
SELECT PortID FROM [dbo].[tbl_ADHC_FCHbaToFibrePortMapping]
WHERE FCHbaID = @HostBusAdapterID
)
 
DELETE FROM [dbo].[tbl_ADHC_FCHbaToFibrePortMapping]
WHERE FCHbaID = @HostBusAdapterID
 
PRINT N'Deleting fiber port with GUID ' + RTRIM(CAST(@FiberPortID AS nvarchar(50)))
 
DELETE FROM [dbo].[tbl_ADHC_FibrePort]
WHERE PortID = @FiberPortID
 
PRINT N'Deleting fiber channel mapping for host bus adapter with GUID ' + RTRIM(CAST(@HostBusAdapterID AS nvarchar(50)))
 
DELETE FROM [dbo].[tbl_ADHC_HostFibreChannelHba]
WHERE FCHbaID = @HostBusAdapterID

PRINT N'Deleting SAS host bus adapter for host bus adapter with GUID ' + RTRIM(CAST(@HostBusAdapterID AS nvarchar(50)))
 
DELETE FROM [dbo].[tbl_ADHC_HostSASHba]
WHERE SASHbaID = @HostBusAdapterID
 
PRINT N'Deleting any iSCSI entries for host bus adapter with GUID ' + RTRIM(CAST(@HostBusAdapterID AS nvarchar(50)))
 
DECLARE @iSCSITargets TABLE
(
TargetID GUID
)
INSERT INTO @iSCSITargets (TargetID)
SELECT TargetID FROM [dbo].[tbl_ADHC_ISCSIHbaToTargetMapping]
WHERE ISCSIHbaID = @HostBusAdapterID
 
PRINT N'Deleting iSCSI host bus adapter to target mapping for mapping for host bus adapter with GUID ' + RTRIM(CAST(@HostBusAdapterID AS nvarchar(50)))
 
DELETE FROM [dbo].[tbl_ADHC_ISCSIHbaToTargetMapping]
WHERE ISCSIHbaID = @HostBusAdapterID

PRINT N'Deleting iSCSI host bus adapter to portal mapping for mapping for host bus adapter with GUID ' + RTRIM(CAST(@HostBusAdapterID AS nvarchar(50)))
 
DELETE FROM [dbo].[tbl_ADHC_ISCSIHbaToPortalMapping]
WHERE ISCSIHbaID = @HostBusAdapterID
 
PRINT N'Deleting iSCSI host bus adapter with GUID ' + RTRIM(CAST(@HostBusAdapterID AS nvarchar(50)))
 
DELETE FROM [dbo].[tbl_ADHC_HostInternetSCSIHba]
WHERE ISCSIHbaID = @HostBusAdapterID
 
PRINT N'Deleting iSCSI targets for host bus adapter with GUID ' + RTRIM(CAST(@HostBusAdapterID AS nvarchar(50)))
 
DECLARE @iSCSITargetIDCursor CURSOR;
DECLARE @iSCSITargetID GUID;
SET @iSCSITargetIDCursor = CURSOR FOR
(SELECT TargetID FROM @iSCSITargets)
 
OPEN @iSCSITargetIDCursor
 
FETCH NEXT FROM @iSCSITargetIDCursor INTO @iSCSITargetID
 
WHILE (@@FETCH_STATUS = 0)
BEGIN
 
PRINT N'Deleting iSCSI targets with GUID ' + RTRIM(CAST(@iSCSITargetID AS nvarchar(50)))
 
DELETE FROM [dbo].[tbl_ADHC_ISCSITarget]
WHERE TargetID = @iSCSITargetID
 
FETCH NEXT FROM @iSCSITargetIDCursor INTO @iSCSITargetID
END
 
CLOSE @iSCSITargetIDCursor
DEALLOCATE @iSCSITargetIDCursor
 
FETCH NEXT FROM @HostBusAdapterCursor INTO @HostBusAdapterID
END
 
CLOSE @HostBusAdapterCursor
DEALLOCATE @HostBusAdapterCursor
 
PRINT N'Completing host bus adapters deletion'
 
DELETE FROM [dbo].[tbl_ADHC_HostBusAdapter]
WHERE HostID = @DeleteHostId
 
PRINT N'Prepairing to delete agent servers'
 
DECLARE @AgentServerID  GUID;
SET @AgentServerID =
(
SELECT AgentServerID FROM [dbo].[tbl_ADHC_AgentServerRelation]
WHERE HostLibraryServerID = @DeleteHostID
)
 
PRINT N'Deleting agent server relations'
 
DELETE FROM [dbo].[tbl_ADHC_AgentServerRelation]
WHERE HostLibraryServerID = @DeleteHostID
 
PRINT N'Deleting health monitor data for agent server with GUID ' + RTRIM(CAST(@AgentServerID AS nvarchar(50)))
 
DELETE FROM [dbo].[tbl_ADHC_HealthMonitor]
WHERE AgentServerID = @AgentServerID
 
PRINT N'Deleting agent server with GUID ' + RTRIM(CAST(@AgentServerID AS nvarchar(50)))
 
DELETE FROM [dbo].[tbl_ADHC_AgentServer]
WHERE AgentServerID = @AgentServerID
 
PRINT N'Deleting host GPUs'
 
DELETE FROM [dbo].[tbl_ADHC_HostGPU]
WHERE HostID = @DeleteHostId

PRINT N'Deleting host Processor Compatibility Vector Mapping'
 
DELETE FROM [dbo].[tbl_ADHC_HostToProcessorCompatibilityVectorMapping]
WHERE HostId = @DeleteHostId
 
PRINT N'Deleting host'
 
DELETE FROM [dbo].[tbl_ADHC_Host]
WHERE HostID = @DeleteHostId
 
IF (@HostClusterID IS NOT NULL)
BEGIN
 
PRINT N'Checking to see if any other hosts are joined to the same cluster'
 
DECLARE @HostCount INT;
SET @HostCount =
(
SELECT COUNT(*) FROM [dbo].[tbl_ADHC_Host]
WHERE HostClusterID = @HostClusterID
)
 
PRINT N'There are ' + RTRIM(CAST(@HostCount AS nvarchar(50))) + N' currently joined to the same cluster'
 
IF (@HostCount = 0)
BEGIN
 
PRINT N'Deleting cluster disks'
 
DELETE FROM [dbo].[tbl_ADHC_ClusterDisk]
WHERE ClusterID = @HostClusterID
 
PRINT N'Deleting cluster'
 
DELETE FROM [dbo].[tbl_ADHC_HostCluster]
WHERE ClusterID = @HostClusterID
END
ELSE
PRINT N'This host is not the last host in the cluster, the cluster will be deleted upon the deletion of the last host.'
END
ELSE
PRINT N'This host does not belong to a cluster, no clusters will be deleted'
 
GO
