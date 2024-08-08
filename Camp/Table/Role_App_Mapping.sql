CREATE TABLE [Camp].[Role_App_Mapping](
	[role_app_id] [smallint] IDENTITY(1,1) NOT NULL,
	[app_id] [smallint] NOT NULL,
	[role_id] [smallint] NOT NULL,
	[last_updated_date] [datetime] NOT NULL,
 CONSTRAINT [PK_ACA_Role_App_Mapping_role_app_id] PRIMARY KEY CLUSTERED ([role_app_id] ASC), 
 CONSTRAINT [FK_ACA_Role_App_Mapping_role_id] FOREIGN KEY([role_id])REFERENCES [Camp].[Role] ([role_id]),
 CONSTRAINT [FK_Role_App_Mapping_app_id] FOREIGN KEY([app_id])REFERENCES [Camp].[App_Catalog] ([app_id])
);
