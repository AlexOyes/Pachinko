
local composer = require( "composer" )
local scene = composer.newScene()
local widget = require "widget"

-- Variable globales

local labelDernierScore 
local labelMeilleurScore
local title
local about 

   -- Appuie sur le bouton jouer pour rentrer dans le jeu
  local function onBoutonPlay()
  composer.removeScene( "scenejeu" )
  composer.gotoScene ( "scenejeu", "slideUp", 1000 ) 
  end

  -- Appuie sur le bouton Score pour afficher les scores 
  local function onBoutonScore()
  composer.removeScene("scenescore")
  composer.gotoScene ( "scenescore", "fade", 1000 )
  end


  local function onBoutonAbout(self, event)
    if (event.phase == "began") then 
      about.isVisible = true
    elseif (event.phase == "ended") then 
      about.isVisible = false
    end    
  end


function scene:create( event )
	local sceneGroup = self.view

local decorMenu = display.newImageRect( "menu1.png", display.actualContentWidth, display.actualContentHeight )
decorMenu.x = display.contentCenterX
decorMenu.y = display.contentCenterY
  
sceneGroup:insert (decorMenu)
  
-- Image sheet options and declaration
-- For testing, you may copy/save the image under "2-Frame Construction" above
local options = {
    width = 110,
    height = 55,
    numFrames = 2,
    sheetContentWidth = 220,
    sheetContentHeight = 55
}
local buttonSheet = graphics.newImageSheet( "bouttonmenu.png", options )
 
-- Create the widget start 
local button1 = widget.newButton(
    {
        sheet = buttonSheet,
        defaultFrame = 1,
        overFrame = 2,
        label = "START",
        labelColor = { default={ 0, 0, 1 }, over={ 1, 1, 1 } }, 
        font = "Silom.ttf", 
        onRelease = onBoutonPlay
    }
)
-- Create the widget score
local button2 = widget.newButton(
    {
        sheet = buttonSheet,
        defaultFrame = 1,
        overFrame = 2,
        label = "SCORE",
        labelColor = { default={ 1, 1, 1 }, over={ 1, 1, 1 } }, 
        font = "Silom.ttf", 
        onRelease = onBoutonScore
    }
)

-- Create the widget score
local button3 = widget.newButton(
    {
        sheet = buttonSheet,
        defaultFrame = 1,
        label = "ABOUT",
        labelColor = { default={ 1, 0, 0 }, over={ 1, 1, 1 } }, 
        font = "Silom.ttf"
    }
)

-- Centrer le boutton
button1.x = display.contentCenterX
button1.y = display.contentCenterY 

button2.x = display.contentCenterX 
button2.y = display.contentCenterY + 55

button3.x = display.contentCenterX 
button3.y = display.contentCenterY + 110
button3.touch = onBoutonAbout
button3:addEventListener("touch", button3)

about = display.newImageRect("aboutMenu.png", 110, 55)
about.x = display.contentCenterX
about.y = display.contentCenterY + 110
about.isVisible = false
  
sceneGroup:insert( button1 )
sceneGroup:insert( button2 )
sceneGroup:insert( button3 )
sceneGroup:insert( about )

end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then
		-- Exécuté avant que la scène ne vienne à l'écran
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