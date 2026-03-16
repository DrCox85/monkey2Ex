
Namespace httprequest

Function Hello()
End

Class HttpRequest Extends HttpRequestBase
	
	Method New()
	End
	
	Protected
	
	Method OnSend( text:String ) Override
		
		Global id:=0
		
		id+=1
		
#If __TARGET__="windows"
		_tmp=GetEnv( "TMP" )+"\mx2_wget-"+id+".dat"
#Else
		_tmp="/tmp/mx2_wget-"+id+".txt"
#endif
	
		'WGET
		Local post_data:=_req="POST" ? " -post-data=~q"+text+"~q" Else ""
		
		Local cmd:="wget -q -T "+_timeout+" -O ~q"+_tmp+"~q --method="+_req+" --show-progress --progress=bar:force:noscroll --content-on-error"+post_data+" ~q"+_url+"~q"
	
		'CURL
'		Local cmd:="curl -s -m "+_timeout+" -o ~q"+_tmp+"~q ~q"+_url+"~q"
		
		_process=New Process
		
		_process.StderrReady=Lambda()
			Local stdout:=_process.ReadStderr()
			If stdout
			
				stdout=stdout.Replace( "~r~n","~n" ).Replace( "~r","~n" )
				Local prozentLoc:=stdout.Find("%")
				If prozentLoc>0 Then _percentDownload=Int(stdout.Mid(prozentLoc-3,3))
			Endif
		End
		
		_process.StdoutReady=Lambda()
			Local stdout:=_process.ReadStdout()
			
			If stdout
				
				Print stdout
			Endif
		End
		
		_process.Finished=Lambda()
		
			If Not _process Return
				
			If _process.ExitCode=0
				
				_response=LoadString( _tmp )
				_responseData=DataBuffer.Load( _tmp )
				
				DeleteFile( _tmp )
				
				_status=200
				
				SetReadyState( ReadyState.Done )
				
			Else
				
				DeleteFile( _tmp )
				
				_status=404
				
				
				
				SetReadyState( ReadyState.Error )
				
			Endif
			
		End
		
		SetReadyState( ReadyState.Loading )
		
		_process.Start( cmd )
	End
	
	
	     
	Method OnCancel() Override
		
		If Not _process Return

		DeleteFile( _tmp )
		
		_process.Terminate()
		
		_process=Null
		
		_status=-1

		SetReadyState( ReadyState.Error )
	End
	
	Private
	
	Field _process:Process
	
	Field _tmp:String
End
