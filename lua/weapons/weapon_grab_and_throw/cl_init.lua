include("shared.lua")

local grabbed = false

local WorldModel = ClientsideModel(SWEP.WorldModel)

function SWEP:Initialize()
	grabbed = false
end

-- Settings...
WorldModel:SetSkin(1)
WorldModel:SetNoDraw(true)

function SWEP:DrawWorldModel()
	local _Owner = self:GetOwner()

	if (IsValid(_Owner)) then
		-- Specify a good position
		local offsetVec = Vector(0, 0, 0)
		local offsetAng = Angle(0, 0, 180)

		local boneid = _Owner:LookupBone("ValveBiped.Bip01_R_Hand") -- Right Hand
		if !boneid then return end

		local matrix = _Owner:GetBoneMatrix(boneid)
		if !matrix then return end

		local newPos, newAng = LocalToWorld(offsetVec, offsetAng, matrix:GetTranslation(), matrix:GetAngles())

		WorldModel:SetPos(newPos)
		WorldModel:SetAngles(newAng)

		WorldModel:SetupBones()
	else
		WorldModel:SetPos(self:GetPos())
		WorldModel:SetAngles(self:GetAngles())
	end

	WorldModel:DrawModel()
end

local material = Material("vgui/white")

net.Receive("SendGrabbed", function(len, ply)
	grabbed = net.ReadBool()
end)

function SWEP:PostDrawViewModel()

	local ow = self:GetOwner()
	local etrace = ow:GetEyeTrace()
	local targetent = etrace.Entity

	if not targetent:IsPlayer() or not IsValid( targetent ) then return end

	local distancevector = ow:GetPos() - targetent:GetPos()
	local matcolor = {}
	if (grabbed) then
		matcolor[1] = Color(0, 101, 169, 25)
		matcolor[2] = Color(0, 167, 251, 50)
	else
		if (distancevector:Length() > GRAB_AND_THROW.CVARS.grab_and_throw_range or CurTime() <= self:GetNextSecondaryFire()) then
			matcolor[1] = Color(169, 0, 0, 25)
			matcolor[2] = Color(251, 0, 0, 50)
		else
			matcolor[1] = Color(0, 169, 54, 25)
			matcolor[2] = Color(0, 251, 96, 50)
		end
	end

	cam.Start3D()
	render.SetMaterial(material)
	render.DrawBox(targetent:GetPos() + Vector(0, 0, 40), Angle(0,0,0), -Vector(15, 15, 40), Vector(15, 15, 40), matcolor[1])
	render.DrawWireframeBox(targetent:GetPos() + Vector(0, 0, 40), Angle(0,0,0), -Vector(15, 15, 40), Vector(15, 15, 40), matcolor[2])
	cam.End3D()
end

function SWEP:PrimaryAttack()

end

