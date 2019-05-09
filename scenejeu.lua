
local composer = require( "composer" )
local scene = composer.newScene()
local widget = require "widget"
local physics = require "physics"
physics.start()
physics.setGravity(0, 20)
--physics.setDrawMode("hybrid") 

local globalView
-- physics de raquette et de balle
local physicsData = (require "raquette").physicsData(1)
local raquette
local balle
local nombreBalles
local labelNombreBalles
local decor

local gameScore 
local labelScore

local sonBump = audio.loadSound("bump.wav") 
local sonRaquette = audio.loadSound("raquette.wav") 

function RaquetteDroite ()
  transition.to (raquette, {
      time = 1500,
      x = display.screenOriginX + display.actualContentWidth - 43,
      rotation = -5, 
      onComplete = RaquetteGauche })
end

function RaquetteGauche ()
  transition.to (raquette, {
      time = 1700,
      x = display.screenOriginX + 43,
      rotation = 5, 
      onComplete = RaquetteDroite })
end

function AjouteScore (pScore)
  gameScore = gameScore + pScore
  labelScore.text = ("Score : "..tostring(gameScore))
end
function AjouteVie (pVie)
  labelNombreBalles.text = ("Balles : "..tostring(nombreBalles))
end

function CreeNiveau ()
  
  local lig, col, x, y
  
  local largeurColonne = (display.actualContentWidth/(5+1))
  
  x = display.screenOriginX + largeurColonne
  y = display.screenOriginY + 100
  
  local function onToucheCible(self, event)
    self:removeSelf()
    audio.play(sonBump)
    if event.phase == "began" then 
      AjouteScore (10) 
    end
  end
  
  for lig = 1, 5 do
  
    for col = 1, 5 do
    local circle = display.newCircle(x, y, 10)
    x = x + largeurColonne
    circle:setFillColor(1, math.random(), math.random())
    physics.addBody(circle, "static", {density = 1.0, friction = 0.5, bounce = 0.4, radius = 8})
    circle.collision = onToucheCible
    circle:addEventListener("collision")
    globalView:insert (circle) 
    end

  x = display.screenOriginX + largeurColonne
  y = y + 50 
  
  end

  gameScore = 0
  nombreBalles = 3

end

function AjouteBalle (pX)
  if balle ~= nil then 
    --print ("balle déja à l'écran") 
  return 
  end
  balle = display.newImage("circle.png")
  balle.x = pX
  physics.addBody (balle, "dynamic", physicsData:get("circle") )
  globalView:insert( balle )
  --print("on lance balle : ", balle.x)
end

function scene:create( event )
  
	local sceneGroup = self.view
  globalView = sceneGroup
  
  decor = display.newImageRect( "decor.jpg", 320, 480 )
  decor.x = display.contentWidth/2
  decor.y = display.contentHeight/2

  function onToucheDecor (event)
    --print("on touche décor")
    AjouteBalle(event.x)
  end

  decor:addEventListener("tap", onToucheDecor)

  sceneGroup:insert( decor )

  local function onToucheRaquette (self, event)
    audio.play(sonRaquette)
    if event.phase == "began" then
      AjouteScore (40)
    end
  end
  
  local murDroite = display.newRect(display.screenOriginX+display.actualContentWidth, display.screenOriginY, 1, display.actualContentHeight)
  murDroite.anchorX = 0
  murDroite.anchorY = 0
  physics.addBody(murDroite, "static", {bounce = 0.5})
  
  local murGauche = display.newRect(display.screenOriginX, display.screenOriginY, 1, display.actualContentHeight)
  murGauche.anchorX = 1
  murGauche.anchorY = 0
  physics.addBody(murGauche, "static", {bounce = 0.5})

  local zoneFin =  display.newRect(display.contentWidth/2, display.screenOriginY+display.actualContentHeight, display.actualContentWidth, 10)
  zoneFin.anchorY = 0
  physics.addBody(zoneFin, "static", {isSensor = true})

  raquette = display.newImage("raquette.png")
  physics.addBody( raquette, "static", physicsData:get("raquette") )
  raquette.y = display.screenOriginY + display.actualContentHeight - 25
  raquette.x = display.screenOriginX 

  raquette.collision = onToucheRaquette 
  raquette:addEventListener( "collision" ) 
  
  local function onCollisionZoneFin (self, event) 
    --print ("touche la zone de fin")
    balle:removeSelf()
    balle = nil

    -- Enleve une balle
    nombreBalles = nombreBalles - 1
    AjouteVie (1)
    if nombreBalles == 0 then
      transition.cancel (raquette)
      composer.setVariable("finalScore", gameScore) -- envoi le gameScore à scenescore
      composer.gotoScene("scenemenu", {effect = "fade", time = 200})
    end
  end

  zoneFin.collision = onCollisionZoneFin
  zoneFin:addEventListener ("collision")
  
  labelScore = display.newText("Score : 0", display.screenOriginX + 50, display.screenOriginY + 25, "Silom.ttf", 15)
  labelScore:setFillColor(0.83, 0.92, 0.4)
  
  labelNombreBalles = display.newText("Balles : 3", display.screenOriginX + 50, display.screenOriginY + 45, "Silom.ttf", 15)
  labelNombreBalles:setFillColor(0.83, 0.92, 0.4)
  
  sceneGroup:insert( raquette )
  sceneGroup:insert( murDroite )
  sceneGroup:insert( murGauche )
  sceneGroup:insert( zoneFin )
  sceneGroup:insert( labelNombreBalles )
  sceneGroup:insert( labelScore ) 
  

end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then
		-- Exécuté avant que la scène ne vienne à l'écran
    CreeNiveau()
    RaquetteDroite ()
	elseif phase == "did" then
		-- Exécuté une fois que la scène est à l'écran
	end	
end

function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if event.phase == "will" then
    -- Exécuté juste avant que la scène ne disparaisse de l'écran
	elseif phase == "did" then
		-- Exécuté après que la scène ai disparu de l'écran
	end	
end

function scene:destroy( event )
	local sceneGroup = self.view
	
  -- Exécuté à la suppression de la scène de la mémoire
	-- Supprimez ici les objets que vous avez créés
end

---------------------------------------------------------------------------------

-- Branchement des événements
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene