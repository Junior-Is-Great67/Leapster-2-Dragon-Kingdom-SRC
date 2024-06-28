@echo off
rem DataWrangler for ActionScript
rem At least 3 parameters are required, -? -h or ? will give the usage


"\Program Files\LeapFrog Tools\ToolPad 2.3\ToolsJre\bin\java" -jar "\Program Files\LeapFrog Tools\ToolPad 2.3\bin\ActionScriptDataWrangler.jar" dragonData.desc dragonData.as dragonData.dtd dragonData.err
goto :end
                
:usage
echo.
echo USAGE: DataWrangler_Leapster descriptionInputFile actionScriptOutputFile dtdOutputFile [errorOutputFile]
echo.
echo EXAMPLE: DataWrangler_Leapster a.desc a.as a.dtd a.err
echo.
echo EXAMPLE: DataWrangler_Leapster a.desc a.as a.dtd
echo.

:end

