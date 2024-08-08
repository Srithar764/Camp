CREATE TABLE [Camp].[User_Role_Mapping](
	[user_role_id] [smallint] IDENTITY(1,1) NOT NULL,
	[user_id] [smallint] NOT NULL,
	[role_id] [smallint] NOT NULL,
	[last_updated_date] [datetime] NOT NULL,
 CONSTRAINT [PK_ACA.User_Role_Mapping_user_role_id] PRIMARY KEY CLUSTERED ([user_role_id] ASC),
 CONSTRAINT [FK_ACA.User_Role_Mapping_role_id] FOREIGN KEY([role_id])REFERENCES [Camp].[Role] ([role_id]));
 GO