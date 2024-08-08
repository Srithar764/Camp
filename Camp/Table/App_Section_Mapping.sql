CREATE TABLE [Camp].[App_Section_Mapping](
	[section_app_id] [int] IDENTITY(1,1) NOT NULL,
	[section_id] [int] NOT NULL,
	[app_id] [smallint] NOT NULL,
	[last_updated_date] [datetime] NOT NULL,
	[is_active] [bit] NULL,
 PRIMARY KEY CLUSTERED ([section_app_id] ASC),
 CONSTRAINT [Fk__App_Catalog__app_id] FOREIGN KEY([app_id])REFERENCES [Camp].[App_Catalog] ([app_id]),
 CONSTRAINT [FK_App_Section__section_id] FOREIGN KEY([section_id]) REFERENCES [Camp].[Section] ([section_id])
);
GO