
local composer = require( "composer" )
local scene = composer.newScene()
local json = require("json") 

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

-- chargement des variables locales de scenescore
local scoresTable = {}

local filePath = system.pathForFile("scores.json", system.DocumentsDirectory)

local function loadScores() 
  
  local file = io.open(filePath, "r") 
  
  if file then 
    local contents = file:read("*a") 
    io.close(file) 
    scoresTable = json.decode( contents )
  end
  
  if ( scoresTable == nil or #scoresTable == 0) then 
    scoresTable = {0,0,0}
  end
end

local function saveScores() 
  for i = #scoresTable, 4, -1 do 
    table.remove ( scoresTable, i )
  end
  
  local file = io.open (filePath, "w")
  
  if file then 
    file:write (json.encode( scoresTable ) )
    io.close( file ) 
  end
end

local function gotoMenu() 
  composer.gotoScene("scenemenu", {time=500, effect="fade"})
end

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

	local sceneGroup = self.view
  -- Le code fonctionne des que la scene est crée mais qu'elle n'apparait pas à l'écran
  -- Chargement des anciens scores
  loadScores ()

  -- Insertion du score dans la table scoreTable 
  table.insert( scoresTable, composer.getVariable( "finalScore") )
  composer.setVariable( "finalScore", 0 )

  -- Trie du plus haut au plus petit score
  local function compare (a, b)
    return a > b 
  end
  table.sort(scoresTable, compare)
  
  -- Sauvegarde les scores
  saveScores()
  
  local decorScore = display.newImageRect("menu2.png", display.actualContentWidth, display.actualContentHeight) 
  decorScore.x = display.contentCenterX
  decorScore.y = display.contentCenterY

  sceneGroup:insert( decorScore )

  -- Titre du Score, bestscore et du lastscore 
  local highScoresHeader = display.newText(sceneGroup, "Scores", display.contentCenterX, 50, "Silom.ttf", 30)
  local bestScoreHeader = display.newText(sceneGroup, "Best score :", display.contentCenterX - 30, 140, "Silom.ttf", 25)

    for i = 1, 3 do
      if (scoresTable[i]) then 
        local yPos = 170 + ( i * 20 ) 

    local rankNum = display.newText( sceneGroup, i ..")", display.contentCenterX-40, yPos, "Silom.ttf", 20) 
    rankNum:setFillColor(0.2)
    rankNum.anchorX = 1
    
    local thisScore = display.newText(sceneGroup, scoresTable[i], display.contentCenterX-20, yPos, "Silom.ttf", 17) 
    thisScore.anchorX = 0 
      end
    end

  local menuButton = display.newText( sceneGroup, "Menu", display.contentCenterX, display.contentCenterY + 100, "Silom.ttf", 20) 
  menuButton:setFillColor(1, 1, 1) 
  menuButton:addEventListener("tap", gotoMenu) 

end
-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)
	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen

	end
end


-- hide()
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)

	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen
    composer.removeScene("scenescore")


	end
end


-- destroy()
function scene:destroy( event )

	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view

end


-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------

return scene
