local lastUpdate = 0
BINDING_HEADER_TARGETASSIST = "Target Assist";

function TA_OnUpdate()
	local time = GetTime()
	if math.floor(time) > lastUpdate then
		lastUpdate = time;

		TA_ScanMarks(nil)
	end
end

function TA_ScanMarks(newTarget)
	local prefix = ""
	local num = 0
	local foundTarget = false

	if GetNumRaidMembers() > 0 then
		prefix = "RAID"
		num = GetNumRaidMembers()
	elseif GetNumPartyMembers() > 0 then
		prefix = "PARTY"
		num = GetNumPartyMembers()
	end

	if num > 0 then
		local marks = {}

		for i = 1,num,1 do
			local icon = GetRaidTargetIndex(prefix..i.."target")

			if icon ~= nil and UnitExists(prefix..i.."target") then
				marks[icon] = prefix..i.."target"
				if newTarget == icon then
					TargetUnit(marks[icon])
					foundTarget = true
				end
			end

			local icon2 = GetRaidTargetIndex(prefix..i)

			if icon2 ~= nil and UnitExists(prefix..i) then
				marks[icon2] = prefix..i
				if newTarget == icon2 then
					TargetUnit(marks[icon2])
					foundTarget = true
				end
			end
		end

		local counter = 1
		counter = TA_UpdateIcon(counter,8,marks[8])
		counter = TA_UpdateIcon(counter,7,marks[7])
		counter = TA_UpdateIcon(counter,4,marks[4])
		counter = TA_UpdateIcon(counter,6,marks[6])
		counter = TA_UpdateIcon(counter,5,marks[5])
		counter = TA_UpdateIcon(counter,3,marks[3])
		counter = TA_UpdateIcon(counter,2,marks[2])
		counter = TA_UpdateIcon(counter,1,marks[1])
	end

	return foundTarget
end

function TA_UpdateIcon(counter,index,target)
	if target ~= nil then
		local icon = getglobal("TAIcon"..counter)
		icon:Show()
		SetRaidTargetIconTexture(getglobal("TAIcon"..counter.."Texture"),index)
		icon.target = target
		icon.index = index
		return counter + 1
	else
		getglobal("TAIcon"..counter):Hide()
		return counter
	end
end

function TA_TargetIcon(newTarget)
	if not TA_ScanMarks(newTarget) then

		for i=0,20 do 
			if GetRaidTargetIndex("target") == nil or GetRaidTargetIndex("target") ~= newTarget then
				TargetNearestEnemy()
			else
				return
			end
		end

		ClearTarget()
	end
end

function TA_OnClick(frame)
	if frame.target ~= nil then
		TargetUnit(frame.target)
	end
end