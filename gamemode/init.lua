GM.StartTime = SysTime();

GM.Name = "Hyperbolic World";
GM.Author = "BeujSensei";
GM.Website 	= "http://hyperbolicworld.wordpress.com/";

DeriveGamemode("base");

AddCSLuaFile("resources.lua");
AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");

AddCSLuaFile("sh_hyper.lua");

include("resources.lua");
include("cl_init.lua");
include("shared.lua");



function GM:PlayerSpawn( joueur )  --What happens when the player spawns
 
    self.BaseClass:PlayerSpawn( joueur )   -- les lignes suivantes sont en cas de problème
    
    --joueur:SetGravity( 0.75 )  
    --joueur:SetMaxHealth( 100, true )  
 
    --joueur:SetWalkSpeed( 325 )  
	--joueur:SetRunSpeed( 325 ) 
 
 -- peut-être pas utile, à voir :
	joueur.V0_walk = joueur:GetWalkSpeed()
	joueur.V0_run = joueur:GetRunSpeed()
	joueur.V0_max = joueur:GetMaxSpeed()
	joueur.V0_crouched = joueur:GetCrouchedWalkSpeed()
	joueur.V0_jump =  joueur:GetJumpPower() 
 
end
 
function GM:PlayerInitialSpawn( joueur )  -- When spawning after joining the server, donc pour initialiser l'hyperbolisme
--pour peaufiner, avec la notion d'admin
--	if joueur:IsAdmin() then --Is the connecting player admin?
--		sb_team2( joueur ) //If he is then set his team to team 2, mais c'est pour gérer l'affichage des infos surtout.
--	else -- If he isn't admin then, rien
--	end --Close the if
end --close the function