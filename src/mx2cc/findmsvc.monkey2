
Namespace mx2cc

#If __TARGET__="windows"

Function FindMSVC:Bool()

	'---findmsvc new----------
		Local msvcs:String
		If GetFileType(AppDir()+"vspath.txt")=FileType.File Then
		
			Local _file2:=FileStream.Open(AppDir()+"vspath.txt","r")
			While Not _file2.Eof
				msvcs=_file2.ReadLine()
			Wend
			_file2.Close()
		Else
			Local pathVsWhere:=GetEnv("ProgramFiles(x86)")+"\Microsoft Visual Studio\Installer\vswhere.exe"
			If GetFileType(pathVsWhere)<>FileType.File Then Print "No Visual Studio installation found";Return False
			Local VsWhereCmd:="~q"+pathVsWhere+"~q -property installationPath >~q"+AppDir()+"vspath.txt~q"
			Local _file:FileStream
			_file=FileStream.Open(AppDir()+"vsPath.bat","w")
			_file.WriteLine("@echo off")
			_file.WriteLine(VsWhereCmd)
			_file.Close()
			OpenUrl(AppDir()+"vsPath.bat")
			Sleep(2)
			DeleteFile(AppDir()+"vsPath.bat")
		End		
	'--------------------------end
	If GetFileType( msvcs )<>FileType.Directory Return False
	msvcs+="\VC\Tools\MSVC"
	
	Local wkits:=GetEnv( "ProgramFiles(x86)" )+"\Windows Kits\10"
	If GetFileType( wkits )<>FileType.Directory Return False
	
	Local toolsDir:="",maxver:=""
	
	For Local f:=Eachin LoadDir( msvcs )
		
		Local dir:=msvcs+"\"+f
		
		If GetFileType( dir )<>FileType.Directory Continue
		
		toolsDir=dir
		
		maxver=f
		
	Next

	Local incsDir:=FindMaxVerDir( wkits+"\Include" )
	If Not incsDir Return False

	Local libsDir:=FindMaxVerDir( wkits+"\Lib" )
	If Not libsDir Return False
	
'	Print toolsDir
'	Print incsDir
'	Print libsDir
	Print "~nMSVC installation auto-detected:"
	Print "Tools='"+toolsDir+"'"
	Print "Include='"+incsDir+"'"
	Print "Lib='"+libsDir+"'"
	
	SetEnv( "MX2_MSVC_PATH_X86",toolsDir+"\bin\Hostx86\x86" )
	SetEnv( "MX2_MSVC_INCLUDE_X86",toolsDir+"\include;"+incsDir+"\ucrt;"+incsDir+"\shared;"+incsDir+"\um" )
	SetEnv( "MX2_MSVC_LIB_X86",toolsDir+"\lib\x86;"+libsDir+"\ucrt\x86;"+libsDir+"\um\x86" )
	
	SetEnv( "MX2_MSVC_PATH_X64",toolsDir+"\bin\Hostx64\x64" )
	SetEnv( "MX2_MSVC_INCLUDE_X64",toolsDir+"\include;"+incsDir+"\ucrt;"+incsDir+"\shared;"+incsDir+"\um" )
	SetEnv( "MX2_MSVC_LIB_X64",toolsDir+"\lib\x64;"+libsDir+"\ucrt\x64;"+libsDir+"\um\x64" )
	
	Return True
End

Function FindMaxVerDir:String( dir:String )
	
	Local maxver:Long=0,maxverDir:=""
	
	For Local f:=Eachin LoadDir( dir )
		
		Local verDir:=dir+"\"+f
		If GetFileType( verDir )<>FileType.Directory Continue
		
		Local ver:Long=Int( f.Replace( ".","" ) )
		
		If ver>maxver
			maxver=ver
			maxverDir=verDir
		Endif
	Next
	
	Return maxverDir
End

#else

Function FindMSVC:Bool()
	Return False
End

#endif
