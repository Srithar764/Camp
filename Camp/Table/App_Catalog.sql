CREATE TABLE [Camp].[App_Catalog](
	[app_id] [smallint] IDENTITY(1,1) NOT NULL,
	[app_name] [varchar](50) NOT NULL,
	[icon_url] [nvarchar](max) NULL,
	[app_url] [nvarchar](max) NOT NULL,
	[description] [nvarchar](max) NULL,
	[is_default] [bit] NOT NULL,
	[last_updated_date] [datetime] NOT NULL,
	[is_active] [bit] NULL DEFAULT (1),
	[section_id] INT 
 CONSTRAINT [PK_ACA.App_Catalog_app_id] PRIMARY KEY CLUSTERED ([app_id] ASC),
 CONSTRAINT [FK_Camp_App_Catalog_section_id_Section_section_id] FOREIGN KEY (section_id) REFERENCES Camp.Section(section_id)
 )
;

