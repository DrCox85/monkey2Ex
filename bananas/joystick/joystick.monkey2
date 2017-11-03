
Namespace test

#Import "<std>"
#Import "<mojo>"

Using std..
Using mojo..

Class MyWindow Extends Window

	Method New()
		Super.New( "Joystick test",640,480 )
		
		JoystickDevice.JoystickAdded+=Lambda( index:Int )
			Print "Joystick added: index="+index
		End
		
		JoystickDevice.JoystickRemoved+=Lambda( index:Int )
			Print "Joystick removed: index="+index
		End
		
	End

	Method OnRender( canvas:Canvas ) Override
	
		App.RequestRender()
	
		canvas.DrawText( "NumJoysticks="+JoystickDevice.NumJoysticks(),0,0 )
		
		For Local i:=0 Until 4
		
			Local joy:=JoystickDevice.Open( i )
			If Not joy Exit
			
			Local x:=0,y:=i*144	'i*160,y:=i*160
			
			canvas.DrawText( "Name="+joy.Name,x,y+16 )
			canvas.DrawText( "GUID="+joy.GUID,x,y+32 )
			
			For Local axis:=0 Until 6
				
				canvas.DrawText( "Axis "+axis+"="+joy.GetAxis( axis ),x,(axis+3)*16+y )
			Next
			
		Next
		
	End
	
End

Function Main()

	New AppInstance
	
	New MyWindow
	
	App.Run()
	
End