extends Node

#Variaveis de ambiente
var isInCity: bool = true #padrao TRUE
var isInBattle: bool = false #padrão FALSE
var firstVisit: bool = true #padrao TRUE

#Reset diario de missoes
var lastRefreshTimestamp = 0
var cachedMissions: Array[Mission] = []

#variaveis de mapa
var tileSize: int = 32
