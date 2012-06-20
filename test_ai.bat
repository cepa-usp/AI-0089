copy .\bin\AI-0089.swf C:\wamp\www\AI-0089\swf
copy .\bin\AI-0089.swf .\deployment\swf

del  .\deployment\AI-0089_SCO.zip
del C:\wamp\www\AI-0089\AI-0089_SCO.zip
"C:\Arquivos de Programas\7-Zip\7z.exe" a C:\wamp\www\AI-0089\AI-0089_SCO.zip C:\wamp\www\AI-0089\*.* -r
"C:\Arquivos de Programas\7-Zip\7z.exe" a .\deployment\AI-0089_SCO.zip .\deployment\*.* -r