-- changement de taille en commande locale (lua_run_cl dans la console)
-- dans la console, utiliser print(machin) pour afficher le retour, et PrintTable(table) si le retour est une table
-- LocalPlayer():GetModelScale()								-- renvoie l'échelle du joueur
-- LocalPlayer():SetModelScale(0.5,1)							-- réduit l'échelle à 0.5 en 1 seconde -> ne bouge pas la camera
-- LocalPlayer():SetFOV(75 / 0.5,1)							-- réduit la FOV d'un facteur 0.5 en 1 seconde
-- LocalPlayer():SetCurrentViewOffset(Vector(0,0,64 * 0.5))	-- baisse la caméra de 0.5 (64 quand debout, 28 quand accroupi ave Shell)



function GM:Move(joueur,mvt)		-- ply pour le joueur concerné, sz pour la commande à effectuer (changement de taille)

	local rayon = 1000				-- Rayon du disque de Poincaré, 1000 correspond au bord de flatgrass

	local position = mvt:GetOrigin();
	local distance = position:Length2D();
	
	local vitesse = mvt:GetVelocity();
	local V_x = vitesse.x;
	local V_y = vitesse.y;
	
	if (V_x != 0 or V_y!= 0) then

		local ratio = 1 - math.pow(distance / rayon , 2);

		local Vh_x = V_x * ratio;
		local Vh_y = V_y * ratio;
		
		mvt:SetVelocity( Vector( Vh_x , Vh_y , vitesse.z ) );		-- modifie la vitesse du joueur
		
		joueur:SetModelScale(ratio,0);								-- modifie la taille du joueur

--		joueur:SetFOV( 75 + 105 * (1 - ratio),0 );					-- change la FOV pour changer la caméra de taille (75 par défaut)
-- Rajouter : un zoom de la caméra pour compenser le FOV qui agrandit le champ de vision.
-- Ne fonctionne pas correctement :		
		joueur:SetViewOffset( Vector(0,0,64 * ratio) );		-- change la position de la caméra pour la baisser (64 par défaut)
		joueur:SetViewOffsetDucked( Vector(0,0,28 * ratio));
		
		joueur:SetStepSize(18 * ratio);

-- pris sur un autre (merci à lui!) :
		local HULL_MIN = Vector( -16, -16, 0  )
		local HULL_MAX = Vector(  16,  16, 72 )

		local HULL_DUCK_MIN = Vector( -16, -16, 0  )
		local HULL_DUCK_MAX = Vector(  16,  16, 36 )

	    if ( ratio == 1 ) then
        joueur:ResetHull()
	    else
        joueur:SetHull( HULL_MIN, ratio * HULL_MAX )
        joueur:SetHullDuck( HULL_DUCK_MIN, ratio * HULL_DUCK_MAX )
    	end
-- fin de ce qui a été pris sur un autre

--[[ d'où j'ai pris ce qui précède :
local VIEW_OFFSET = Vector( 0, 0, 64 )
local VIEW_OFFSET_DUCK = Vector( 0, 0, 28 )

local HULL_MIN = Vector( -16, -16, 0  )
local HULL_MAX = Vector(  16,  16, 72 )

local HULL_DUCK_MIN = Vector( -16, -16, 0  )
local HULL_DUCK_MAX = Vector(  16,  16, 36 )

local STEP_SIZE = 18

local PLAYER = FindMetaTable( "Player" )

function PLAYER:SetSize( size )
    size = math.Clamp( size, 0.01, 20 ) -- if you don't clamp it at around 20, they will start lagging the server when they walk

    self:SetModelScale( size, 0 )
    self:SetViewOffset( size * VIEW_OFFSET )
    self:SetViewOffsetDucked( size * VIEW_OFFSET_DUCK )
    self:SetStepSize( size * STEP_SIZE )

    if ( size == 1 ) then
        self:ResetHull()
    elseif ( size < 1 ) then
        self:SetHull( HULL_MIN, size * HULL_MAX )
        self:SetHullDuck( HULL_DUCK_MIN, size * HULL_DUCK_MAX )
    else
        self:SetHull( HULL_MIN, HULL_MAX )
        self:SetHullDuck( HULL_DUCK_MIN, HULL_DUCK_MAX )
    end
end
]]--
		
		print(joueur:GetCurrentViewOffset());

	end
	
end;


--[[
function GM:Move( ply, mv )

 --
 -- Set up a speed, go faster if shift is held down
 --
 local speed = 0.0005 * FrameTime()
 if ( mv:KeyDown( IN_SPEED ) ) then speed = 0.005 * FrameTime() end

 --
 -- Get information from the movedata
 --
 local ang = mv:GetMoveAngles()
 local pos = mv:GetOrigin()
 local vel = mv:GetVelocity()

 --
 -- Add velocities. This can seem complicated. On the first line
 -- we're basically saying get the forward vector, then multiply it
 -- by our forward speed (which will be > 0 if we're holding W, < 0 if we're
 -- holding S and 0 if we're holding neither) - and add that to velocity.
 -- We do that for right and up too, which gives us our free movement.
 --
 vel = vel + ang:Forward() * mv:GetForwardSpeed() * speed
 vel = vel + ang:Right() * mv:GetSideSpeed() * speed
 vel = vel + ang:Up() * mv:GetUpSpeed() * speed

 --
 -- We don't want our velocity to get out of hand so we apply
 -- a little bit of air resistance. If no keys are down we apply
 -- more resistance so we slow down more.
 --
 if ( math.abs(mv:GetForwardSpeed()) + math.abs(mv:GetSideSpeed()) + math.abs(mv:GetUpSpeed()) < 0.1 ) then
 vel = vel * 0.90
 else
 vel = vel * 0.99
 end

 --
 -- Add the velocity to the position (this is the movement)
 --
 pos = pos + vel

 --
 -- We don't set the newly calculated values on the entity itself
 -- we instead store them in the movedata. They should get applied
 -- in the FinishMove hook.
 --
 mv:SetVelocity( vel )
 mv:SetOrigin( pos )

 --
 -- Return true to not use the default behavior
 --
 return true

end
]]--
