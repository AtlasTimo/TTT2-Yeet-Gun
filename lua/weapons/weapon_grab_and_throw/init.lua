AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

local shootSound = Sound("yeet.ogg")

function SWEP:PrimaryAttack()
	self:SetNextPrimaryFire(CurTime() + 2.0)

	if (self.target ~= nil and IsValid(self.target) and self.grabbed) then
		local ow = self:GetOwner()
		self.target:SetVelocity(ow:GetAimVector() * GRAB_AND_THROW.CVARS.grab_and_throw_strength)
		ow:EmitSound(shootSound, 100, 100, 1)
		self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
		self.AllowDrop = false
		timer.Simple(0.25, function()
			ow:StripWeapon("weapon_grab_and_throw")
		end)
	end
end

util.AddNetworkString("SendGrabbed")

function SWEP:SecondaryAttack()
	local ow = self:GetOwner()
	if (self.target ~= nil and IsValid(self.target) and self.grabbed) then
		ow:StripWeapon("weapon_grab_and_throw")
		if (IsValid(self)) then
			self:Remove()
		end
	else
		local targetent = ow:GetEyeTrace().Entity
		if not targetent:IsPlayer() or not IsValid( targetent ) then return end

		self:SetNextSecondaryFire(CurTime() + 1)

		local distancevector = ow:GetPos() - targetent:GetPos()
		if distancevector:Length() > GRAB_AND_THROW.CVARS.grab_and_throw_range then return end

		self.AllowDrop = false
		self.target = targetent
		self.grabbed = true
		self.grabTime = CurTime()
	end

	net.Start("SendGrabbed")
	net.WriteBool(self.grabbed)
	net.Send(ow)
end

function SWEP:Think()
	local ow = self:GetOwner()
	if (((not ow:Alive()) or (not IsValid(ow))) and self.grabbed) then
		self.target = nil
		self.grabbed = false
		if (IsValid(self)) then
			self:Remove()
		end
		return
	end

	if (self.target ~= nil and IsValid(self.target) and self.grabbed) then

		self.target:SetGravity(0)

		local aimVector = ow:GetAimVector() * 100
		local globalAimVector = ow:GetPos() + aimVector

		local targetToAimVector = globalAimVector - self.target:GetPos()
		targetToAimVector.z = 0
		self.target:SetVelocity(targetToAimVector * 5)

		if (CurTime() >= self.grabTime + 10) then
			self.target = nil
			self.grabbed = false

			net.Start("SendGrabbed")
			net.WriteBool(self.grabbed)
			net.Send(ow)

			ow:StripWeapon("weapon_grab_and_throw")
			if (IsValid(self)) then
				self:Remove()
			end
		end
	end
	self:NextThink(CurTime() + 1 / 30)
	return true
end

function SWEP:OnDrop()
	if (self.AllowDrop) then return end
	self:Remove()
end