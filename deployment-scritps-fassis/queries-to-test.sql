--Rotas monitoradas pelo usuário
SELECT * FROM dbo.MonitoredRoutes

--Descrição das rotas
SELECT * FROM dbo.Routes WHERE Id = 100113

--Posição dos ônibus das rotas monitoradas
SELECT * FROM dbo.BusData

--Descrição dos poligonos monitorados
SELECT TOP (1000) [Id]
      ,[Name]
      ,[GeoFence]
      ,[GeoFence].ToString()
  FROM [dbo].[GeoFences]

SELECT * FROM [dbo].[GeoFencesActive]

SELECT * FROM [dbo].[GeoFenceLog]
