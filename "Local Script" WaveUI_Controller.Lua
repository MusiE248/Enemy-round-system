-- WaveUI_Controller

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local gui = player:WaitForChild("PlayerGui"):WaitForChild("WaveUI")
local waveLabel = gui:WaitForChild("WaveLabel")
local countdownLabel = gui:WaitForChild("CountdownLabel")

local waveEvent = ReplicatedStorage:WaitForChild("Wave_Update")
local countdownEvent = ReplicatedStorage:WaitForChild("Countdown_Update")

waveEvent.OnClientEvent:Connect(function(waveNumber)
	waveLabel.Text = "Wave / " .. waveNumber
end)

countdownEvent.OnClientEvent:Connect(function(seconds)
	if seconds <= 0 then
		countdownLabel.Visible = false
	else
		countdownLabel.Visible = true
		countdownLabel.Text = tostring(seconds) .. "s"
	end
end)
