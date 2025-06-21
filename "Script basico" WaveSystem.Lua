-- WaveSystem Script
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local enemyFolder = ReplicatedStorage:WaitForChild("Enemy_Models")
local spawnFolder = Workspace:WaitForChild("SpawnPoints_Enemies")
local activeFolder = Workspace:WaitForChild("Data_Model") -- Aquí van los enemigos
local waveEvent = ReplicatedStorage:WaitForChild("Wave_Update")
local countdownEvent = ReplicatedStorage:WaitForChild("Countdown_Update")

-- CONFIGURACIÓN GENERAL
local enemyName = "Zombie_Common"
local timeBetweenWaves = 10 -- Puedes cambiar a 30 cuando termines pruebas
local waveNumber = 0

-- Función para calcular la cantidad de enemigos
local function calculateEnemyCount(wave)
	local base = 10 + ((wave - 1) * 2)
	local extraPerPlayer = 5 + (wave - 1)
	local playerCount = #Players:GetPlayers()
	return base + (playerCount * extraPerPlayer)
end

local function getRandomSpawn()
	local spawnPoints = spawnFolder:GetChildren()
	return spawnPoints[math.random(1, #spawnPoints)]
end

local function allEnemiesDead()
	local enemies = activeFolder:GetChildren()
	for _, enemy in pairs(enemies) do
		if enemy and enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
			return false
		end
	end
	return true
end

local function clearEnemies()
	for _, child in pairs(activeFolder:GetChildren()) do
		child:Destroy()
	end
end

local function runCountdown(seconds)
	for i = seconds, 0, -1 do
		countdownEvent:FireAllClients(i)
		task.wait(1)
	end
end

local function startWave()
	waveNumber += 1
	print("Iniciando ola " .. waveNumber)

	waveEvent:FireAllClients(waveNumber)

	clearEnemies()

	local enemyTemplate = enemyFolder:FindFirstChild(enemyName)
	if not enemyTemplate then
		warn("No se encontró el enemigo: " .. enemyName)
		return
	end

	local totalEnemies = calculateEnemyCount(waveNumber)

	for i = 1, totalEnemies do
		local clone = enemyTemplate:Clone()
		local spawnPoint = getRandomSpawn()
		clone:SetPrimaryPartCFrame(spawnPoint.CFrame + Vector3.new(0, 3, 0))
		clone.Parent = activeFolder
		task.wait(0.2)
	end

	print("Enemigos generados: " .. totalEnemies)
end
runCountdown(timeBetweenWaves)
while true do
	startWave()

	repeat
		task.wait(1)
	until allEnemiesDead()

	print("Ola " .. waveNumber .. " completada.")

	runCountdown(timeBetweenWaves)
end
