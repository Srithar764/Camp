CREATE TABLE [Camp].[App_Catalog](
	[app_id] [smallint] IDENTITY(1,1) NOT NULL,
	[app_name] [varchar](50) NOT NULL,
	[icon_url] [nvarchar](max) NULL,
	[app_url] [nvarchar](max) NOT NULL,
	[description] [nvarchar](max) NULL,
	[is_default] [bit] NOT NULL,
	[last_updated_date] [datetime] NOT NULL,
	[is_active] [bit] NULL DEFAULT (1),
 CONSTRAINT [PK_ACA.App_Catalog_app_id] PRIMARY KEY CLUSTERED ([app_id] ASC)
 )
;

