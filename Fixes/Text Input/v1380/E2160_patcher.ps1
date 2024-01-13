<# PeekMessageA function wrapper for NO_SSE exe
The altered function discards passed wMsgFilterMin and wMsgFilterMax parameters and replaces them with WM_KEYFIRST(0x100) and WM_KEYLAST(0x109) respectively

0:  55                      push   ebp
1:  89 e5                   mov    ebp,esp
3:  57                      push   edi
4:  8b 45 18                mov    eax,DWORD PTR [ebp+0x18]
7:  50                      push   eax
8:  68 09 01 00 00          push   0x109
d:  68 00 01 00 00          push   0x100
12: 6a 00                   push   0x0
14: 8b 45 08                mov    eax,DWORD PTR [ebp+0x8]
17: 50                      push   eax
18: 8b 3d 40 04 9b 00       mov    edi,DWORD PTR ds:0x9b0440
1e: ff d7                   call   edi
20: 5f                      pop    edi
21: 5d                      pop    ebp
22: c2 14 00                ret    0x14
#>
function ApplyTextInputFixes_NO_SSE([Parameter(Mandatory = $true)] [byte[]]$bytes)
{
	"Injecting PeekMessageA function wrapper..."
	$offset = 0x005af9d0
	$bytes[$offset++] = 0x55
	$bytes[$offset++] = 0x89
	$bytes[$offset++] = 0xe5
	$bytes[$offset++] = 0x57
	$bytes[$offset++] = 0x8b
	$bytes[$offset++] = 0x45
	$bytes[$offset++] = 0x18
	$bytes[$offset++] = 0x50
	$bytes[$offset++] = 0x68
	$bytes[$offset++] = 0x09
	$bytes[$offset++] = 0x01
	$bytes[$offset++] = 0x00
	$bytes[$offset++] = 0x00
	$bytes[$offset++] = 0x68
	$bytes[$offset++] = 0x00
	$bytes[$offset++] = 0x01
	$bytes[$offset++] = 0x00
	$bytes[$offset++] = 0x00
	$bytes[$offset++] = 0x6a
	$bytes[$offset++] = 0x00
	$bytes[$offset++] = 0x8b
	$bytes[$offset++] = 0x45
	$bytes[$offset++] = 0x08
	$bytes[$offset++] = 0x50
	$bytes[$offset++] = 0x8b
	$bytes[$offset++] = 0x3d
	$bytes[$offset++] = 0x40
	$bytes[$offset++] = 0x04
	$bytes[$offset++] = 0x9b
	$bytes[$offset++] = 0x00
	$bytes[$offset++] = 0xff
	$bytes[$offset++] = 0xd7
	$bytes[$offset++] = 0x5f
	$bytes[$offset++] = 0x5d
	$bytes[$offset++] = 0xc2
	$bytes[$offset++] = 0x14
	$bytes[$offset] = 0x00
	
	"Injecting PeekMessageA function wrapper pointer..."
	$offset = 0x005af9c8
	$bytes[$offset++] = 0xd0
	$bytes[$offset++] = 0xf9
	$bytes[$offset++] = 0x9a
	$bytes[$offset] = 0x00
	

	"Replacing PeekMessageA function addresses..."
	$offset = 0x002fdfee
	$bytes[$offset++] = 0xc8
	$bytes[$offset++] = 0xf9
	$bytes[$offset++] = 0x9a
	$bytes[$offset] = 0x00
}

<# PeekMessageA function wrapper for SSE exe
TThe altered function discards passed wMsgFilterMin and wMsgFilterMax parameters and replaces them with WM_KEYFIRST(0x100) and WM_KEYLAST(0x109) respectively

0:  55                      push   ebp
1:  89 e5                   mov    ebp,esp
3:  57                      push   edi
4:  8b 45 18                mov    eax,DWORD PTR [ebp+0x18]
7:  50                      push   eax
8:  68 09 01 00 00          push   0x109
d:  68 00 01 00 00          push   0x100
12: 6a 00                   push   0x0
14: 8b 45 08                mov    eax,DWORD PTR [ebp+0x8]
17: 50                      push   eax
18: 8b 3d 4c d4 9d 00       mov    edi,DWORD PTR ds:0x9dd44c
1e: ff d7                   call   edi
20: 5f                      pop    edi
21: 5d                      pop    ebp
22: c2 14 00                ret    0x14
#>
function ApplyTextInputFixes_SSE([Parameter(Mandatory = $true)] [byte[]]$bytes)
{
	"Injecting PeekMessageA function wrapper..."
	$offset = 0x005dc620
	$bytes[$offset++] = 0x55
	$bytes[$offset++] = 0x89
	$bytes[$offset++] = 0xe5
	$bytes[$offset++] = 0x57
	$bytes[$offset++] = 0x8b
	$bytes[$offset++] = 0x45
	$bytes[$offset++] = 0x18
	$bytes[$offset++] = 0x50
	$bytes[$offset++] = 0x68
	$bytes[$offset++] = 0x09
	$bytes[$offset++] = 0x01
	$bytes[$offset++] = 0x00
	$bytes[$offset++] = 0x00
	$bytes[$offset++] = 0x68
	$bytes[$offset++] = 0x00
	$bytes[$offset++] = 0x01
	$bytes[$offset++] = 0x00
	$bytes[$offset++] = 0x00
	$bytes[$offset++] = 0x6a
	$bytes[$offset++] = 0x00
	$bytes[$offset++] = 0x8b
	$bytes[$offset++] = 0x45
	$bytes[$offset++] = 0x08
	$bytes[$offset++] = 0x50
	$bytes[$offset++] = 0x8b
	$bytes[$offset++] = 0x3d
	$bytes[$offset++] = 0x4c
	$bytes[$offset++] = 0xd4
	$bytes[$offset++] = 0x9d
	$bytes[$offset++] = 0x00
	$bytes[$offset++] = 0xff
	$bytes[$offset++] = 0xd7
	$bytes[$offset++] = 0x5f
	$bytes[$offset++] = 0x5d
	$bytes[$offset++] = 0xc2
	$bytes[$offset++] = 0x14
	$bytes[$offset] = 0x00
	
	"Injecting PeekMessageA function wrapper pointer..."
	$offset = 0x005dc618
	$bytes[$offset++] = 0x20
	$bytes[$offset++] = 0xc6
	$bytes[$offset++] = 0x9d
	$bytes[$offset] = 0x00
	

	"Replacing PeekMessageA function addresses..."
	$offset = 0x002fe49e
	$bytes[$offset++] = 0x18
	$bytes[$offset++] = 0xc6
	$bytes[$offset++] = 0x9d
	$bytes[$offset] = 0x00
}

"============================================"
"Patching Earth2160_NO_SSE.exe"
"============================================"
[byte[]]$bytes = Get-Content Earth2160_NO_SSE.exe -Encoding Byte -Raw
ApplyTextInputFixes_NO_SSE  -bytes $bytes
,$bytes |Set-Content Earth2160_NO_SSE.exe -Encoding Byte

""
"============================================"
"Patching Earth2160_SSE.exe"
"============================================"
[byte[]]$bytes2 = Get-Content Earth2160_SSE.exe -Encoding Byte -Raw
ApplyTextInputFixes_SSE  -bytes $bytes2
,$bytes2 |Set-Content Earth2160_SSE.exe -Encoding Byte