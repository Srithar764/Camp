CREATE TABLE [Camp].[Section](
	[section_id] [int] IDENTITY(1,1) NOT NULL,
	[section_name] [varchar](50) NULL,
	[is_active] [bit] NULL,
	[last_updated_date] [datetime] NULL,
PRIMARY KEY CLUSTERED ([section_id] ASC));

