CREATE TABLE [Camp].[Role](
	[role_id] [smallint] IDENTITY(1,1) NOT NULL,
	[role_name] [nvarchar](50) NOT NULL,
	[description] [nvarchar](max) NULL,
	[last_updated_date] [datetime] NOT NULL,
 CONSTRAINT [PK_ACA.Role_role_id] PRIMARY KEY CLUSTERED ([role_id] ASC)) 
GO

